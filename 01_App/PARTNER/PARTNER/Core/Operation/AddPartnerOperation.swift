//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class AddPartnerOperation: BaseOperation {

    var candidatePartner: PFUser!
    var candidatePartnerId: NSString!
    
    override init() {
        super.init()
        self.executeSerialBlock = {
            if self.candidatePartner != nil {
                return self.becomePartner()
            }
            var error: NSError?
            if let user = PFUser.query().getObjectWithId(self.candidatePartnerId, error: &error) as? PFUser {
                if error != nil {
                    return .Failure(NSError.code(.NetworkOffline))
                }
                self.candidatePartner = user
                return self.becomePartner()
            }
            return .Failure(NSError.code(.NotFoundUser))
        }
    }

    convenience init(candidatePartnerId : NSString){
        self.init()
        self.candidatePartnerId = candidatePartnerId
    }

    convenience init(candidatePartner: PFUser){
        self.init()
        self.candidatePartner = candidatePartner
    }
    
    func becomePartner() -> BaseOperationResult {
        var error: NSError?
        if let pfMyProfile = PFUser.query().getObjectWithId(MyProfile.read().id, error: &error) as? PFUser {
            let hasPartner = pfMyProfile["hasPartner"] as Bool
            if hasPartner {
                // ???: 既にパートナーがいる場合は、更新してよいかかくにんする
                self.savePartner()
                return .Success(nil)
            }

            pfMyProfile["partner"] = self.candidatePartner
            pfMyProfile["hasPartner"] = true
            pfMyProfile.save(&error)

            return self.savePartner()
        }
        return .Failure(NSError.code(.NotFoundUser))
    }
    
    func savePartner() -> BaseOperationResult {
        self.dispatchAsyncMainThread({
            let partner = Partner.read()
            partner.id = self.candidatePartner.objectId
            partner.image = UIImage(data: (self.candidatePartner["profileImage"] as PFFile).getData())
            partner.name = self.candidatePartner.username
            partner.isAuthenticated = true
            partner.save()

            let myProfile = MyProfile.read()
            myProfile.hasPartner = true
            myProfile.save()
        })
        return self.notify()
    }
    
    func notify() -> BaseOperationResult {
        let myProfile = MyProfile.read()

        let userQuery = PFUser.query().whereKey("objectId", equalTo: candidatePartner.objectId)
        let pushQuery = PFInstallation.query().whereKey("user", matchesQuery:userQuery)

        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(
            ["alert"            : "Added partner「\(myProfile.name)」",
             "objectId"         : myProfile.id,
             "notificationType" : "AddedPartner" ]
        )

        var error: NSError?
        push.sendPush(&error)
        if error != nil {
            return .Failure(NSError.code(.NetworkOffline))
        }
        return .Success(nil)
    }
}
