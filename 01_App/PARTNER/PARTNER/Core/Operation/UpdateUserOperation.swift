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

    init(username: NSString){
        self.username = username
        super.init()
    }

    func save(){
        var user = PFUser.currentUser()
        // FIXME: 仮
        user.password = "password"
        user.username = self.username
        user.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if(error == nil){
                return
            }
            NSLog("error:%@", error)
        })
    }
}
