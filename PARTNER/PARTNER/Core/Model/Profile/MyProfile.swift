//
//  MyProfile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/10/25.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class MyProfile: Profile{
    override class var sharedInstance : MyProfile {
        struct Static {
            static let instance = MyProfile()
        }
        return Static.instance
    }
}
