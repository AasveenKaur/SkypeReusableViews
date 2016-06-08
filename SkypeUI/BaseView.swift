//
//  BaseView.swift
//  SkypeUI
//
//  Created by Aasveen Kaur on 5/25/16.
//  Copyright © 2016 Aasveen Kaur. All rights reserved.
//

import UIKit
// for later use
public class BaseView: UIView {
var view: UIView!
    
    // MARK: View setup
    func setup(nibName:String) {
        self.view = UINib(nibName: nibName, bundle:
            NSBundle(forClass:self.dynamicType)).instantiateWithOwner(self,
                                                                      options: nil)[0] as! UIView
        self.view.frame = bounds
        self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(self.view)
        
        
    }
    
    
    

}
