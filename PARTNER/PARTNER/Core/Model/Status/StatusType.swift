//
//  StatusType.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/24.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

func countEnumElements(test: (Int) -> Any?) -> Int {
    var i = 0
    while test(i) != nil {
        i++
    }
    return i
}

enum StatusTypes : NSInteger {
    case GoodMorning = 0
    case GoingHome
    case ThunkYou
    case EatOut
    case AlmostThere
    case GodId
    case GoodNight
    case Sorry
    case Love
    
    var statusType : StatusType {
        switch self {
        case GoodMorning:
            return StatusType(iconImageName: "good_morning_icon", name: LocalizedString.key("GoodMorning"))
        case GoingHome:
            return StatusType(iconImageName: "going_home_icon", name: LocalizedString.key("GoingHome"))
        case ThunkYou:
            return StatusType(iconImageName: "thank_you_icon", name: LocalizedString.key("ThunkYou"))
        case EatOut:
            return StatusType(iconImageName: "have_dinner_icon", name: LocalizedString.key("EatOut"))
        case AlmostThere:
            return StatusType(iconImageName: "there_icon", name: LocalizedString.key("AlmostThere"))
        case GodId:
            return StatusType(iconImageName: "god_it_icon", name: LocalizedString.key("GodId"))
        case GoodNight:
            return StatusType(iconImageName: "good_night_icon", name: LocalizedString.key("GoodNight"))
        case Sorry:
            return StatusType(iconImageName: "bow_icon", name: LocalizedString.key("Sorry"))
        case Love:
            return StatusType(iconImageName: "love_icon", name: LocalizedString.key("Love"))
        }
    }
    
    static let count = countEnumElements({StatusTypes(rawValue: $0)})
}


class StatusType: NSObject, NSCoding {
    var identifier : String!
    var iconImageName : String!
    var name : String!

    init(iconImageName: String, name: String) {
        self.identifier = iconImageName
        self.iconImageName = iconImageName
        self.name = name
    }

    required init(coder aDecoder: NSCoder) {
        
        identifier = aDecoder.decodeObjectForKey("iconImageName") as! String
        iconImageName = aDecoder.decodeObjectForKey("iconImageName") as! String
        name = aDecoder.decodeObjectForKey("name") as! String
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "iconImageName")
        aCoder.encodeObject(iconImageName, forKey: "iconImageName")
        aCoder.encodeObject(name, forKey: "name")
    }
}
