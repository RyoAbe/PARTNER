//
//  GetUserOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class GetUserOperation: BaseOperation {
    
    // TODO: userIdに変更したい
    var objectId: NSString!

    init(objectId : NSString){
        super.init()
        self.objectId = objectId
        self.executeSerialBlock = {
            var error: NSError?
            if let user = PFUser.query().getObjectWithId(objectId, error: &error) {
                return .Success(user)
            }
            return .Failure(NSError.code(.NetworkOffline))
        }
    }
}
