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
        assert(MyProfile.read().isAuthenticated, "ログインしていない")
        self.executeSerialBlock = {
            return .Success(nil)
        }
    }
}
