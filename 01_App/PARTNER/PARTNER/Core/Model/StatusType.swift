//
//  StatusType.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/24.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

enum StatusTypes : NSInteger {
    case GoodMoning = 0
    case GoingHome
    case ThunkYou
    case HaveDinner
    case There
    case GodId
    case GoodNight
    case Location
    case Love
    
    var statusType : StatusType {
        switch self {
        case GoodMoning:
            return StatusType(type:self, iconImageName: "good_morning_icon", name: "Good morning.")
        case GoingHome:
            return StatusType(type:self, iconImageName: "going_home_icon", name: "I’m going home.")
        case ThunkYou:
            return StatusType(type:self, iconImageName: "thank_you_icon", name: "Thank You!")
        case HaveDinner:
            return StatusType(type:self, iconImageName: "have_dinner_icon", name: "I have dinner.")
        case There:
            return StatusType(type:self, iconImageName: "there_icon", name: "I’m almost there.")
        case GodId:
            return StatusType(type:self, iconImageName: "god_it_icon", name: "Got it.")
        case GoodNight:
            return StatusType(type:self, iconImageName: "good_night_icon", name: "Good night.")
        case Location:
            return StatusType(type:self, iconImageName: "location_icon", name: "Location")
        case Love:
            return StatusType(type:self, iconImageName: "love_icon", name: "I Love you.")
        }
    }
}

class StatusType: NSObject, NSCoding {
    var type : StatusTypes!
    var iconImageName : NSString!
    var name : NSString!
    
    init(type: StatusTypes, iconImageName: NSString, name: NSString) {
        self.type = type
        self.iconImageName = iconImageName
        self.name = name
    }

    required init(coder aDecoder: NSCoder) {
        type = StatusTypes(rawValue: aDecoder.decodeObjectForKey("type") as NSInteger)
        iconImageName = aDecoder.decodeObjectForKey("iconImageName") as NSString
        name = aDecoder.decodeObjectForKey("name") as NSString
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type.rawValue, forKey: "type")
        aCoder.encodeObject(iconImageName, forKey: "iconImageName")
        aCoder.encodeObject(name, forKey: "name")
    }
}
