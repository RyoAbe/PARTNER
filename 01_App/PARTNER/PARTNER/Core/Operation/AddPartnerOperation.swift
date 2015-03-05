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
        super.main()
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
        PFUser.query().getObjectInBackgroundWithId(MyProfile.read().id, block: { object, error in
            let hasPartner = object["hasPartner"] as Bool

            if hasPartner {
                self.savePartner()
                return
            }

            object["partner"] = self.user
            object["hasPartner"] = true
            object.saveInBackgroundWithBlock{ succeeded, error in
                self.notify()
                self.savePartner()
            }
        })
    }
    
    func savePartner() {
        let partner = Partner.read()
        
        partner.id = self.user.objectId
        partner.image = UIImage(data: (self.user["profileImage"] as PFFile).getData())
        partner.name = self.user.username
        partner.isAuthenticated = true
        partner.save()

        let myProfile = MyProfile.read()
        myProfile.hasPartner = true
        myProfile.save()
        self.finished = true
    }
    
    func notify() {
        
        let myProfile = MyProfile.read()

        let userQuery = PFUser.query()
        userQuery.whereKey("objectId", equalTo: self.user.objectId)
        
        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery:userQuery)
        
        let push = PFPush()
        push.setQuery(pushQuery)
        let data = ["alert"            : "Added partner「\(myProfile.name)」",
            "objectId"         : myProfile.id,
            "notificationType" : "AddedPartner" ]
        let notificationType = data["notificationType"]
        
        NSLog("notificationType:\(notificationType)")
        push.setData(data)
        // ???: errorのハンドリング
        push.sendPushInBackgroundWithBlock(nil)
    }
}
