//
//  Partner.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/10/25.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Partner: Profile {

    override class var key : NSString {
        return NSStringFromClass(Partner).componentsSeparatedByString(".").last!
    }

    override class var sharedInstance : Partner {
        // ???: Profileクラスでひとまとめに出来るかも
        struct Static {
            static let instance = Partner()
        }
        return Static.instance
    }
}
