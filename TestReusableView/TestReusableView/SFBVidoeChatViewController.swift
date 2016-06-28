//
//  SFBVidoeChatViewController.swift
//  TestReusableView
//
//  Created by Aasveen Kaur on 6/27/16.
//  Copyright © 2016 Aasveen Kaur. All rights reserved.
//

import UIKit
import GLKit

/** This is a convenience class that simplifies the video chat screen setup. 
Initialize it with your "Meeting Url" and "Meeting Display Name" and integarate in your application.
This class comes with an attached SFBVidoeChatViewController.xib file.
*/

 class SFBVidoeChatViewController: UIViewController,SfBConversationHelperDelegate,SfBAlertDelegate {
    
    @IBOutlet private  var selfVideoView: UIView!
    @IBOutlet private  var participantVideoView: GLKView!
    @IBOutlet private  var infoBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet private  var infoBar: UIView!
    @IBOutlet private  var endCallButton: UIButton!
    @IBOutlet private  var dateLabel: UILabel!
    @IBOutlet private  var muteButton: UIButton!
    
    
    let DisplayNameInfoKey:String = "displayName"
    var meetingUrl : String!
    var meetingDisplayName : String!
    
    private var conversationHelper:SfBConversationHelper? = nil
    private var endVideoChatCompletionHandler:(() -> Void)?
    
    func endVideoChatWithCompletionHandler(CompletionHandler:(() -> Void)){
        endVideoChatCompletionHandler = CompletionHandler
    }
    
    
    //MARK: Custom Initializer
    
    convenience init(meetingUrl: String, meetingDisplayName: String) {
        
        self.init()
        self.meetingUrl = meetingUrl
        self.meetingDisplayName = meetingDisplayName
        
    }
    
    //MARK:
    //MARK: UIViewController Life cycle methods
    //MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide back button of UINavigation
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Hide info bar
        
        self.setInfoBarPosition(-90)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Show info bar with animation
        
        self.setInfoBarPosition(0)
        self.setDate()
        self.joinMeeting()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:
    //MARK: Update Video Chat View as per our need
    //MARK:
    
    func setInfoBarPosition(position:CGFloat){
        
        self.infoBarBottomConstraint.constant = position;
        if (position == 0) {
            UIView.animateWithDuration(0.5) {
                self.infoBar.layoutIfNeeded()
            }
            
        }
    }
    func setDate(){
        // Set date label to current times
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        self.dateLabel.text = dateFormatter.stringFromDate(NSDate())
    }
    
    func enableEndCallButton(enable:Bool) {
        self.endCallButton.enabled = enable
        
    }
    
    func muteButtonTitle(title:String){
        
        self.muteButton.setTitle(title, forState: .Normal)
        
    }
    
    
    func hideSelfVideoView(hidden:Bool) {
        
        self.selfVideoView.hidden = hidden
        
        
    }
    
    func hideParticipantVideoView(hidden:Bool) {
        self.participantVideoView.hidden = hidden
    }
    
    
    //MARK:
    //MARK:Join A Skype Meeting.
    //MARK:
    private func joinMeeting() {
        
        //Override point for customization after application launch.
        let sfb: SfBApplication = SfBApplication.sharedApplication()!
        sfb.alertDelegate = self
        
        
        do {
            let urlText:String = meetingUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:urlText)
            let conversation: SfBConversation  = try sfb.joinMeetingAnonymousWithUri(url!, displayName: meetingDisplayName)
            conversation.alertDelegate = self
            
            
            self.conversationHelper = SfBConversationHelper(conversation: conversation,
                                                            delegate: self,
                                                            devicesManager: sfb.devicesManager,
                                                            outgoingVideoView:  selfVideoView,
                                                            incomingVideoLayer: participantVideoView.layer as! CAEAGLLayer,
                                                            userInfo: [DisplayNameInfoKey:meetingDisplayName])
            
            conversation.addObserver(self, forKeyPath: "canLeave", options: .Initial , context: nil)
            
            
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = getAlertWithError("Could Not Join Meeting!(System Error)")
            self.presentViewController(alertController, animated: true, completion: nil)
            
            //Enable end call button to let user exit video call screen after failure to join meeting
            enableEndCallButton(true)
        }
        
    }
    
    
    //MARK:
    //MARK: Action Methods
    //MARK:
    
    @IBAction private func toggleMute(sender: AnyObject) {
        do{
            try self.conversationHelper?.toggleAudioMuted()
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = getAlertWithError("Could Not Toggling Mute!")
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction private func endCall(sender: AnyObject) {
        
        // Get conversation handle and call leave.
        // Need to check for canLeave property of conversation,
        // in this case happens in KVO
        do{
            try self.conversationHelper?.conversation.leave()
            self.conversationHelper?.conversation.removeObserver(self, forKeyPath: "canLeave")
            
            endVideoChatCompletionHandler!()
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = getAlertWithError("Could Not Leave meeting!")
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK:
    //MARK: Skype SfBConversationHelperDelegate Functions
    //MARK:
   
    // At incoming video, unhide the participant video view
    
    func conversationHelper(conversationHelper: SfBConversationHelper, didSubscribeToVideo video: SfBParticipantVideo?) {
        
        hideParticipantVideoView(false)
        
    }
    
    // When video service is ready to start, unhide self video view and start the service.
    
    func conversationHelper(conversationHelper: SfBConversationHelper, videoService: SfBVideoService, didChangeCanStart canStart: Bool) {
        
        if (canStart) {
            if (selfVideoView.hidden) {
                hideSelfVideoView(false)
                
            }
            do{
                try videoService.start()
            }
            catch let error as NSError {
                print(error.localizedDescription)
                
            }
        }
    }
    
    // When the audio status changes, reflect in UI
    
    func conversationHelper(avHelper: SfBConversationHelper, selfAudio audio: SfBParticipantAudio, didChangeIsMuted isMuted: Bool) {
        if !isMuted {
            
            muteButtonTitle("Unmute")
        }
        else {
            
            muteButtonTitle("Mute")
        }
    }
    
    //MARK:
    //MARK: Additional KVO
    //MARK:
    
    // Monitor canLeave property of a conversation to prevent leaving prematurely
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "canLeave") {
            
            enableEndCallButton((self.conversationHelper?.conversation.canLeave)!)
            
        }
    }
    
    
    //MARK: - SKype SfBAlertDelegate Functions
    
    func didReceiveAlert(alert: SfBAlert) {
        let alertController = alert.getAlert()
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
