//
//  GetUserOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class GetUserOperation: BaseOperation {
    var userId: NSString!
    init(userId : NSString){
        super.init()
        self.userId = userId
        self.executeSerialBlock = {
            var error: NSError?
            if let user = PFUser.query().getObjectWithId(userId, error: &error) {
                return .Success(user)
            }
            return .Failure(NSError.code(.NotFoundUser))
        }
    }
}
