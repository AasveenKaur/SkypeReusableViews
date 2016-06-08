//
//  ViewController.swift
//  textSharedView
//
//  Created by Aasveen Kaur on 5/26/16.
//  Copyright © 2016 Aasveen Kaur. All rights reserved.
//

import UIKit
import SkypeUI

class VideoViewController: UIViewController,SfBConversationHelperDelegate,SfBAlertDelegate {
    
    var conversationHelper:SfBConversationHelper? = nil
    let DisplayNameInfoKey:String = "displayName"
    
    @IBOutlet var myVideoView: VideoChatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide back button of UINavigation
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // setup myVideoView handlers and date label.
        myVideoView.endCallHandler = self.endChat
        myVideoView.toggleMuteHandler = self.toggleMute
        myVideoView.date = NSDate()
    }
    
    // This gets called when end button in myVideoView is pressed
    func endChat() {
        
        do{
            try self.conversationHelper?.conversation.leave()
            self.conversationHelper?.conversation.removeObserver(self, forKeyPath: "canLeave")
            self.navigationController?.popViewControllerAnimated(true)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            self.handleError("Could Not Leave meeting!")
        }
    }
    
    // This gets called when mute/unmute button in myVideoView is pressed
    func toggleMute() {
        do{
            try self.conversationHelper?.toggleAudioMuted()
        }
        catch let error as NSError {
            print(error.localizedDescription)
            self.handleError("Could Not Toggling Mute!")
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // hide info bar
        myVideoView.infoBarPosition = -90
        
    }

    override func viewDidAppear(animated: Bool) {
        self.initializeUI()
        self.joinMeeting()
    }
    
    /**
     *  Initialize UI.
     *  Bring information bar from bottom to the visible area of the screen.
     */
    func initializeUI()  {
        myVideoView.infoBarPosition = 0
    }

    /**
     *  Joins a Skype meeting.
     */
    func joinMeeting() {
        
        
        
        let meetingURLString:String = getMeetingURLString
        let meetingDisplayName:String = getMeetingDisplayName
        
        //Override point for customization after application launch.
        let sfb: SfBApplication = SfBApplication.sharedApplication()!
        sfb.alertDelegate = self
        
        
        do {
            let url = NSURL(string:meetingURLString)
            let conversation: SfBConversation  = try sfb.joinMeetingAnonymousWithUri(url!, displayName: meetingDisplayName)
            conversation.alertDelegate = self
            
            self.conversationHelper = SfBConversationHelper(conversation: conversation,
                                                            delegate: self,
                                                            devicesManager: sfb.devicesManager,
                                                            outgoingVideoView:  myVideoView.selfVideoView,
                                                            incomingVideoLayer: myVideoView.participantVideoView.layer as! CAEAGLLayer,
                                                            userInfo: [DisplayNameInfoKey:meetingDisplayName])
            
            conversation.addObserver(self, forKeyPath: "canLeave", options: .Initial , context: nil)
            
            
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
            self.handleError("Could Not Join Meeting!(System Error)")
            //Enable end call button to let user exit video call screen after failure to join meeting
            myVideoView.enableEndCallButton = true
        }
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK - Skype SfBConversationHelperDelegate Functions
    
    // At incoming video, unhide the participant video view
    
    func conversationHelper(conversationHelper: SfBConversationHelper, didSubscribeToVideo video: SfBParticipantVideo?) {
        myVideoView.participantVideoView.hidden = false
    }
    
    // When video service is ready to start, unhide self video view and start the service.
    
    func conversationHelper(conversationHelper: SfBConversationHelper, videoService: SfBVideoService, didChangeCanStart canStart: Bool) {
        
        if (canStart) {
            if (myVideoView.selfVideoView.hidden) {
                myVideoView.selfVideoView.hidden = false
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
            myVideoView.muteButtonTitle = "Unmute"
            
        }
        else {
             myVideoView.muteButtonTitle = "Mute"
            
        }
    }
    
    
    
    
    //MARK: - Additional KVO
    
    // Monitor canLeave property of a conversation to prevent leaving prematurely
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "canLeave") {
            myVideoView.enableEndCallButton = (self.conversationHelper?.conversation.canLeave)!
            
        }
    }
    
    //MARK: - Helper UI
    
    func handleError(readableErrorDescription:String)  {
        let alertController:UIAlertController = UIAlertController(title: "ERROR!", message: readableErrorDescription, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion:nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func didReceiveAlert(alert: SfBAlert) {
                alert.show()
    }



}

