//
//  VideoChatView.swift
//  SkypeUI
//
//  Created by Aasveen Kaur on 5/18/16.
//  Copyright © 2016 Aasveen Kaur. All rights reserved.
//

import UIKit
import GLKit


public class VideoChatView: BaseView {
    let nibName:String = "VideoChatView"
   
    
    // Public to class that initialize SfBConversationHelper
    @IBOutlet public weak var selfVideoView: UIView!
    @IBOutlet public weak var participantVideoView: GLKView!
    
    // Private
    @IBOutlet  weak var infoBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet  weak var infoBar: UIView!
    @IBOutlet  weak var endCallButton: UIButton!
    @IBOutlet  weak var dateLabel: UILabel!
    @IBOutlet  weak var muteButton: UIButton!
    
    // action handlers
    public var endCallHandler:(() -> Void)?
    public var toggleMuteHandler:(() -> Void)?
    

    public var date:NSDate?{
        didSet {
            
            // Set date label to current times
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            self.dateLabel.text = dateFormatter.stringFromDate(date!)
            
        }
    }
    public var enableEndCallButton:Bool?{
        didSet {
            self.endCallButton.enabled = enableEndCallButton!
        }
    }
    
    public var muteButtonTitle:String?{
        didSet {
            self.muteButton.setTitle(muteButtonTitle, forState: .Normal)
        }
    }
    
    public var infoBarPosition:CGFloat?{
        didSet {
            self.infoBarBottomConstraint.constant = infoBarPosition!;
            if (infoBarPosition == 0) {
                UIView.animateWithDuration(0.5) {
                    self.infoBar.layoutIfNeeded()
                }
            }
            
        }
    }
    
    @IBAction func toggleMute(sender: AnyObject) {
        if(toggleMuteHandler == nil) {
            print("No toggleMuteHandler defined")
            return
        }
        
        toggleMuteHandler!()
        
    }
    
    @IBAction func endCall(sender: AnyObject) {
        
        if(endCallHandler == nil) {
            print("No endCallHandler defined")
            return
        }
        
        endCallHandler!()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(self.nibName)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(self.nibName)
    }
    
    
       

    
}
