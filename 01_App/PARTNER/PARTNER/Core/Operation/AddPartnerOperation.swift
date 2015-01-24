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
    var objectId: NSString!
    
    init(objectId : NSString){
        super.init()
        self.objectId = objectId
    }

    init(user: PFUser){
        self.user = user
        super.init()
    }

    override func main() {
        if self.user != nil {
            becomePartner()
            return
        }
        let op = GetUserOperation(objectId: self.objectId)
        op.start()
        op.completionBlock = {
            self.user = op.result
            self.becomePartner()
        }
    }
    
    func becomePartner() {
        let myProfile = MyProfile.read()
        
        let query = PFUser.query()
        query.getObjectInBackgroundWithId(myProfile.id, block: { object, error in
            
            let userQuery = PFUser.query()
            userQuery.whereKey("objectId", equalTo: self.user.objectId)
            let pushQuery = PFInstallation.query()
            pushQuery.whereKey("user", matchesQuery:userQuery)
            let push = PFPush()
            push.setQuery(pushQuery)
            push.setData(["alert": "Added partner「\(myProfile.name)」", "notificationType": "Message"])
            push.sendPushInBackgroundWithBlock{ succeeded, error in
                
                object["partner"] = self.user
                object["hasPartner"] = true
                
                object.saveInBackgroundWithBlock{ succeeded, error in
                    let partner = Partner.read()
                    let data = (self.user["profileImage"] as PFFile).getData()
                    
                    partner.id = self.user.objectId
                    partner.image = UIImage(data: data)
                    partner.name = self.user.username
                    partner.isAuthenticated = true
                    partner.save()

                    myProfile.hasPartner = true
                    myProfile.save()
                    
                    self.finished = true
                }
            }
        })
    }
}
