//
//  UpdateMyProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// ???: LoginToFBOperationの処理をこっち持ってこれるんじゃね？

class UpdateMyProfileOperation: BaseOperation {
    
    var username: NSString!
    var hasPartner: Bool!

    init(hasPartner: Bool){
        self.hasPartner = hasPartner
        super.init()
    }

    override func main() {
        let myProfile = MyProfile.read()
        let op = GetUserOperation(id: myProfile.id)
        op.start()
        op.completionBlock = {
            let user = op.result!
            user["hasPartner"] = self.hasPartner
            user.saveInBackgroundWithBlock{ success, error in
                if(success){
                    myProfile.hasPartner = self.hasPartner
                    myProfile.save()
                }
                self.finished = true
            }
        }
    }
}
