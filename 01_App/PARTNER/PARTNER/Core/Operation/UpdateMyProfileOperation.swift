//
//  UpdateMyProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateMyProfileOperation: BaseOperation {
    override init() {
        super.init()
        let myProfile = MyProfile.read()
        assert(myProfile.isAuthenticated, "ログインしていない")
        self.executeAsyncBlock = {
            var error: NSError?
            if let pfMyProfile = PFUser.currentUser() {
                self.updateMyProfile(pfMyProfile)
                self.addPartnerIfEixst(pfMyProfile)
                return
            }
            self.finish(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }
    
    func updateMyProfile(pfMyProfile: PFUser) {
        let profileImageData = (pfMyProfile["profileImage"] as PFFile).getData()
        self.dispatchAsyncMainThread({
            let myProfile = MyProfile.read()
            myProfile.id = pfMyProfile.objectId
            myProfile.image = UIImage(data: profileImageData)!
            myProfile.name = pfMyProfile.username
            myProfile.hasPartner = pfMyProfile["hasPartner"] as Bool
            myProfile.save()
        })
    }
    
    func addPartnerIfEixst(pfMyProfile: PFUser) {
        if let hasPartner = pfMyProfile["hasPartner"] as? PFUser {
            self.finish()
            return
        }
        if let pfPartner = pfMyProfile["partner"] as? PFUser {
            let op = AddPartnerOperation(candidatePartner: pfPartner)
            op.completionBlock = {
                let r: AnyObject? = op.error != nil ? op.error : op.result
                self.finish(r)
            }
            return
        }
        self.finish()
    }
}
