//
//  StatusType.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/24.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class StatusType: NSObject {
    var id : NSInteger!
    var iconImageName : NSString!
    var name : NSString!
    
    init(id: NSInteger, iconImageName: NSString, name: NSString) {
        self.id = id
        self.iconImageName = iconImageName
        self.name = name
    }
}
