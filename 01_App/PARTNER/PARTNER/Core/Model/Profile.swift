//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Profile: NSObject {
    var name: NSString!;
    var imageName: NSString!;
    
    class func createWithName(name:NSString!, imageName:NSString!) -> Profile{
        var profile = Profile()
        profile.name = name
        profile.imageName = imageName
        return profile;
    }
}
