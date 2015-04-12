//
//  UpdateMyProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateMyProfileOperation: UpdateProfileOperation {    
    override init() {
        super.init()
        let myProfile = MyProfile.read()
//        assert(myProfile.isAuthenticated, "ログインしていない")
        pfProfile = PFUser.currentMyProfile()
        profile = MyProfile.read()
    }
}
