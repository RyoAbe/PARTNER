//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: ロールバックの仕組みを作りたい
// TODO: パートナーが変わったらStatuesを削除
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
            if let candidatePartner = PFUser.query().getObjectWithId(self.candidatePartnerId, error: &error) as? PFUser {
                self.candidatePartner = candidatePartner
                return self.becomePartner()
            }
            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
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
        if let pfMyProfile = PFUser.currentUser() {

            /* TODO: 保留
            let myPartnerRelation = pfMyProfile.relationForKey("partner")
            myPartnerRelation.addObject(self.candidatePartner)
            */
            pfMyProfile["partner"] = self.candidatePartner
            pfMyProfile["hasPartner"] = true
            pfMyProfile.save(&error)
            if error != nil {
                return .Failure(error)
            }

            
            /* TODO: 保留
            *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'User cannot be saved unless they have been authenticated via logIn or signUp'
            let partnersPartnerRelation = self.candidatePartner.relationForKey("partner")
            partnersPartnerRelation.addObject(pfMyProfile)
            self.candidatePartner["hasPartner"] = true
            */
            self.candidatePartner.save(&error)
            if error != nil {
                return .Failure(error)
            }

            return self.savePartner()
        }
        return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
    }
    
    func savePartner() -> BaseOperationResult {
        let profileImageData = (self.candidatePartner["profileImage"] as PFFile).getData()
        self.dispatchAsyncMainThread({
            let partner = Partner.read()
            partner.id = self.candidatePartner.objectId
            partner.image = UIImage(data: profileImageData)
            partner.name = self.candidatePartner.username
            partner.isAuthenticated = true
            partner.save()

            let myProfile = MyProfile.read()
            myProfile.hasPartner = true
            myProfile.save()
        })

        if (candidatePartner["hasPartner"] as Bool) == true {
            return .Success(nil)
        }
        return notify()
    }
    
    func notify() -> BaseOperationResult {
        let pfMyProfile = PFUser.currentUser()

        let userQuery = PFUser.query().whereKey("objectId", equalTo: candidatePartner.objectId)
        // ???: ponter使えばいいかも
        let pushQuery = PFInstallation.query().whereKey("user", matchesQuery:userQuery)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(
            ["alert"            : "Added partner「\(pfMyProfile.username)」",
             "objectId"         : pfMyProfile.objectId,
             "notificationType" : "AddedPartner" ]
        )
        var error: NSError?
        push.sendPush(&error)
        if error != nil {
            return .Failure(error)
        }
        return .Success(nil)
    }
}
