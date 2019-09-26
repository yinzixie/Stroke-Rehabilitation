//
//  Alert.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/5/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation
import UIKit

public class Alert{
    //pop up warning alert with message
    static func warningAlert(message:String,view:UIViewController){
        let alert = UIAlertController(
            title:"Warnning",
            message:message,
            preferredStyle:UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(
            title:"OK",
            style:UIAlertAction.Style.cancel,
            handler:nil
        ))
        view.present(alert, animated: true, completion: nil)
    }
    
    //pop up a message window
    static func messageAlert(message:String,view:UIViewController) {
        let message = UIAlertController(
            title:"Message",
            message:message,
            preferredStyle:UIAlertController.Style.alert
        )
        message.addAction(UIAlertAction(
            title:"OK",
            style:UIAlertAction.Style.cancel,
            handler:nil
        ))
        view.present(message, animated: true, completion: nil)
    }
    
    //choose alert
    static func yesOrNoAlert(title:String, message:String, view:UIViewController)->Bool {
        var result = false
        let alert = UIAlertController(
            title:"title",
            message:message,
            preferredStyle:UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(
            title:"YES",
            style:UIAlertAction.Style.default,
            handler:{ (action: UIAlertAction!) in
                    result = true
        }))
        alert.addAction(UIAlertAction(
            title:"NO",
            style:UIAlertAction.Style.default,
            handler:{ (action: UIAlertAction!) in
                result = false
        }))
        view.present(alert, animated: true, completion: nil)
        return result
    }
    
}
