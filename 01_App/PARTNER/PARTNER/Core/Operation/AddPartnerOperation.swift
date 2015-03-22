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

    var candidatePartner: PFPartner!
    var candidatePartnerId: NSString!
    
    override init() {
        super.init()
        self.executeSerialBlock = {
            if self.candidatePartner != nil {
                return self.becomePartner()
            }
            var error: NSError?
            if let candidatePartner = PFUser.query().getObjectWithId(self.candidatePartnerId, error: &error) as? PFUser {
                self.candidatePartner = PFPartner(user: candidatePartner)
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
        self.candidatePartner = PFPartner(user: candidatePartner)
    }
    
    func becomePartner() -> BaseOperationResult {
        var error: NSError?
        let pfMyProfile = PFUser.currentMyProfile()

        pfMyProfile.partner = self.candidatePartner.pfUser
        pfMyProfile.hasPartner = true
        pfMyProfile.save(&error)
        if error != nil {
            return .Failure(error)
        }

        // TODO: 仕様で出来ないらしい
//        self.candidatePartner.partner = pfMyProfile.pfUser
//        self.candidatePartner.save(&error)
        if error != nil {
            return .Failure(error)
        }
        
        return self.savePartner()
    }
    
    func savePartner() -> BaseOperationResult {
        let profileImageData = self.candidatePartner.profileImage.getData()
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

        if candidatePartner.hasPartner {
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
