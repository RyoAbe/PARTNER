//
//  MyProfile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/10/25.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class MyProfile: Profile{
    
    override var key: NSString {
        return NSStringFromClass(MyProfile).componentsSeparatedByString(".").last!
    }

    // ???: PFUser.currentUser()でいいかも
    override class var sharedInstance : MyProfile {
        struct Static {
            static let instance = MyProfile()
        }
        return Static.instance
    }

    override class func read() -> MyProfile! {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefaults.dataForKey("MyProfile")
        return data == nil ? self.sharedInstance : NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? MyProfile
    }
}
