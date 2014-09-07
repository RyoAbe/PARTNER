//
//  UpdateUserOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateUserOperation: NSObject {
    
    var username: NSString!
    var partner: PFObject!

    init(username: NSString){
        self.username = username
        super.init()
    }

    init(partner: PFObject){
        self.partner = partner
        super.init()
    }

    func save(){
        var user = PFUser.currentUser()
        // FIXME: 仮
        user.password = "password"
        user["partner"] = self.partner == nil ? user["partner"] : self.partner
        user.username = self.username == nil ? user.username : self.username
        user.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if(error == nil){
                return
            }
            NSLog("error:%@", error)
        })
    }
}
