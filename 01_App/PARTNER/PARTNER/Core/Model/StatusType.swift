//
//  StatusType.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/24.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class StatusType: NSObject, NSCoding {
    var id : NSInteger!
    var iconImageName : NSString!
    var name : NSString!
    
    init(id: NSInteger, iconImageName: NSString, name: NSString) {
        self.id = id
        self.iconImageName = iconImageName
        self.name = name
    }

    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as NSInteger
        iconImageName = aDecoder.decodeObjectForKey("iconImageName") as NSString
        name = aDecoder.decodeObjectForKey("name") as NSString
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(iconImageName, forKey: "iconImageName")
        aCoder.encodeObject(name, forKey: "name")
    }
}
