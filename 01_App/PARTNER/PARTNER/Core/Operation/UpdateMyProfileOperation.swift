//
//  UpdateMyProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateMyProfileOperation: BaseOperation {

    override func main() {
        super.main()
        assert(MyProfile.read().isAuthenticated, "ログインしていない")

        let myProfile = MyProfile.read()
        let getUserOp = GetUserOperation(objectId: myProfile.id)
        getUserOp.start()
        getUserOp.completionBlock = {
            let myUser = getUserOp.result!
            if((myUser.allKeys() as NSArray).containsObject("partner")){
                let partner = myUser["partner"] as PFUser
                let op = AddPartnerOperation(user: partner)
                op.start()
                op.completionBlock = {
                    self.finished = true
                }
            }
        }
    }
}
