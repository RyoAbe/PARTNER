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
            return StatusType(iconImageName: "good_morning_icon", name: "Good morning.")
        case GoingHome:
            return StatusType(iconImageName: "going_home_icon", name: "I'll go home.")
        case ThunkYou:
            return StatusType(iconImageName: "thank_you_icon", name: "Thank you!")
        case HaveDinner:
            return StatusType(iconImageName: "have_dinner_icon", name: "I will eat out.")
        case There:
            return StatusType(iconImageName: "there_icon", name: "I’m almost there.")
        case GodId:
            return StatusType(iconImageName: "god_it_icon", name: "Got it.")
        case GoodNight:
            return StatusType(iconImageName: "good_night_icon", name: "Good night.")
        case Location:
            return StatusType(iconImageName: "bow_icon", name: "Sorry.")
        case Love:
            return StatusType(iconImageName: "love_icon", name: "I love you.")
        }
    }
}

class StatusType: NSObject, NSCoding {
    var iconImageName : NSString!
    var name : NSString!

    init(iconImageName: NSString, name: NSString) {
        self.iconImageName = iconImageName
        self.name = name
    }

    required init(coder aDecoder: NSCoder) {
        iconImageName = aDecoder.decodeObjectForKey("iconImageName") as NSString
        name = aDecoder.decodeObjectForKey("name") as NSString
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(iconImageName, forKey: "iconImageName")
        aCoder.encodeObject(name, forKey: "name")
    }
}
