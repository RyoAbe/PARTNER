//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class AddPartnerOperation: BaseOperation {

    var user: PFUser!
    
    init(user: PFUser){
        self.user = user
        super.init()
    }

    override func main() {
        let myProfile = MyProfile.read()

        let query = PFUser.query()
        query.getObjectInBackgroundWithId(myProfile.id, block: { object, error in

            self.user["partner"] = object
            // ???: partnerのuserの更新とmyUserのpartnerの更新は本当は並列にやりたい
            self.user.saveInBackgroundWithBlock{ succeeded, error in
                let myUser = object as PFUser
                myUser["partner"] = self.user
                object.saveInBackgroundWithBlock{ succeeded, error in
                    let partner = Partner.read()
                    let data = (self.user["profileImage"] as PFFile).getData()
                    
                    partner.id = self.user.objectId
                    partner.image = UIImage(data: data)
                    partner.name = self.user.username
                    partner.isAuthenticated = true
                    
                    partner.save()
                    
                    self.finished = true
                }
            }
        })
    }
}
