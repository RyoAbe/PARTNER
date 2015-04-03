//
//  UpdateMyProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateMyProfileOperation: BaseOperation {
    var pfMyProfile: PFMyProfile!
    var needAddPartner = false
    override init() {
        super.init()
        let myProfile = MyProfile.read()
        assert(myProfile.isAuthenticated, "ログインしていない")

        self.executeAsyncBlock = {
            self.pfMyProfile = PFUser.currentMyProfile()
            self.updateMyProfile()
        }
    }

    func updateMyProfile() {
        let profileImageData = self.pfMyProfile.profileImage.getData()
        self.dispatchAsyncMainThread({
            let myProfile = MyProfile.read()
            myProfile.id = self.pfMyProfile.objectId
            myProfile.image = UIImage(data: profileImageData)!
            myProfile.name = self.pfMyProfile.username
            myProfile.hasPartner = self.pfMyProfile.hasPartner
            myProfile.save()
        })
    }
}
