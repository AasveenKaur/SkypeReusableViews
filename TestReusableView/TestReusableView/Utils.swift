//+----------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// Module name: Utils.swift
//----------------------------------------------------------------

import Foundation
import UIKit
import SkypeForBusiness



extension SfBAlert {

    func getAlert() -> UIAlertController{
        //UIAlertView(title: "\(level): \(type)",
            //message: "\(error.localizedDescription)", delegate: nil, cancelButtonTitle: "OK").show()
        
       let alertController = UIAlertController(title:  "\(level): \(type)", message: "\(error.localizedDescription)", preferredStyle: .Alert)
        
       alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
       return alertController
        

    }

}

func getAlertWithError(readableErrorDescription:String)  -> UIAlertController {
    let alertController:UIAlertController = UIAlertController(title: "ERROR!", message: readableErrorDescription, preferredStyle: .Alert)
    
    alertController.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
    return alertController
}

