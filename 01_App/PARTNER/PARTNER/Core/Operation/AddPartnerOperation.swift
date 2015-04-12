//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: ロールバックの仕組みを作りたい
class AddPartnerOperation: BaseOperation {

    var candidatePartner: PFPartner!
    var candidatePartnerId: String!
    
    override init() {
        super.init()
        self.executeAsyncBlock = {
            if self.candidatePartner != nil {
                self.becomePartner()
            }
            var error: NSError?
            if let candidatePartner = PFUser.query()!.getObjectWithId(self.candidatePartnerId, error: &error) as? PFUser {
                self.candidatePartner = PFPartner(user: candidatePartner)
                self.becomePartner()
                return
            }
//            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
            self.finishWithError(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }

    convenience init(candidatePartnerId : String){
        self.init()
        self.candidatePartnerId = candidatePartnerId
    }
    // ???: いらなくなるはず
    convenience init(candidatePartner: PFUser){
        self.init()
        self.candidatePartner = PFPartner(user: candidatePartner)
    }
    convenience init(candidatePartner: PFPartner){
        self.init()
        self.candidatePartner = candidatePartner
    }

    func becomePartner() {
        var error: NSError?
        let pfMyProfile = PFUser.currentMyProfile()
        
        NSLog("PFUser.currentMyProfile().partner=\(PFUser.currentMyProfile().partner)")
        pfMyProfile.partner = self.candidatePartner.pfUser
        NSLog("PFUser.currentMyProfile().partner=\(PFUser.currentMyProfile().partner)")
        pfMyProfile.saveInBackgroundWithBlock{ saveInBackgroundWithBlock, error in
            if error != nil {
                self.finishWithError(error)
                return
            }
            NSLog("PFUser.currentMyProfile().partner=\(PFUser.currentMyProfile().partner)")
            self.savePartner()
        }
    }
    
    func savePartner() {
        let profileImageData = self.candidatePartner.profileImage.getData()
        NSLog("PFUser.currentMyProfile().partner=\(PFUser.currentMyProfile().partner)")
        self.dispatchAsyncMainThread({
            self.dispatchAsyncOperation(
                UpdatePartnerOperation(partnerId: self.candidatePartner.objectId)
            )
            NSLog("PFUser.currentMyProfile().partner=\(PFUser.currentMyProfile().partner)")
            self.dispatchAsyncOperation(
                UpdateMyProfileOperation()
            )
        })

        if candidatePartner.hasPartner {
            self.finish()
        }
        notify()
    }
    
    func notify() {
        let pfMyProfile = PFUser.currentUser()!
        let userQuery = PFUser.query()!.whereKey("objectId", equalTo: candidatePartner.objectId)
        // ???: ponter使えばいいかも
        let pushQuery = PFInstallation.query()!.whereKey("user", matchesQuery:userQuery)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(["alert"            : "Added Partner「\(pfMyProfile.username!)」",
                      "objectId"         : pfMyProfile.objectId!,
                      "notificationType" : "AddedPartner" ])
        var error: NSError?
        push.sendPush(&error)
        if error != nil {
            self.finishWithError(error)
            return
        }
        self.finish()
    }
}
