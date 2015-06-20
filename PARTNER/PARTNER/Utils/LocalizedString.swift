//
//  LocalizedString.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/05/31.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class LocalizedString {
    class func key(key: String) -> String {
        return NSLocalizedString(key, tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}