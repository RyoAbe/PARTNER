//
//  Partner.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/10/25.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Partner: Profile {
    
    override var key: NSString {
        return NSStringFromClass(Partner).componentsSeparatedByString(".").last!
    }

    override class var sharedInstance : Partner {
        // ???: Profileクラスでひとまとめに出来るかも
        struct Static {
            static let instance = Partner()
        }
        return Static.instance
    }

    override class func read() -> Partner! {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefaults.dataForKey("Partner")
        return data == nil ? self.sharedInstance : NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? Partner
    }
}
