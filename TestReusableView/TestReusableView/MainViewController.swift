//
//  MainViewController.swift
//  TestReusableView
//
//  Created by Aasveen Kaur on 6/27/16.
//  Copyright © 2016 Aasveen Kaur. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startVideoChat(sender: AnyObject) {
        
        // initialzise and show video chat screen
        
        let vc:SFBVidoeChatViewController = SFBVidoeChatViewController(meetingUrl: "https://join.microsoft.com/meet/v-aakaur/R5KC3H72", meetingDisplayName: "Aasveen")
        
        vc.endVideoChatWithCompletionHandler {
            // Pop Video Chat Screen from navigation controller
                self.popSFBVidoeChatViewController()
            
            /** NOTE - Use this to Dismiss Video Chat Screen if presented modally
                self.dismissSFBVidoeChatViewController()
            **/
        }
        
            // Push Video Chat Screen to navigation controller stack
                pushSFBVidoeChatViewController(vc)
        
        
            /** NOTE - Use this to present Video Chat Screen modally
                self.presentSFBVidoeChatViewControllerModally(vc)
            **/
        
        
    }
    
    func pushSFBVidoeChatViewController(vc:SFBVidoeChatViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popSFBVidoeChatViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func presentSFBVidoeChatViewControllerModally(vc:SFBVidoeChatViewController) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func dismissSFBVidoeChatViewController() {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
