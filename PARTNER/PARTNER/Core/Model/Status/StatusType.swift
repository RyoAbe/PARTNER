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
    case GoodMoning = 0
    case GoingHome
    case ThunkYou
    // TODO: 命名変更(I will eat out.)
    case HaveDinner
    case There
    case GodId
    case GoodNight
    // TODO: 命名変更(Sorry)
    case Location
    case Love
    
    var statusType : StatusType {
        switch self {
        case GoodMoning:
            let name = NSLocalizedString("GoodMoning", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "good_morning_icon", name: name)
        case GoingHome:
            let name = NSLocalizedString("GoingHome", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "going_home_icon", name: name)
        case ThunkYou:
            let name = NSLocalizedString("ThunkYou", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "thank_you_icon", name: name)
        case HaveDinner:
            let name = NSLocalizedString("HaveDinner", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "have_dinner_icon", name: name)
        case There:
            let name = NSLocalizedString("There", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "there_icon", name: name)
        case GodId:
            let name = NSLocalizedString("GodId", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "god_it_icon", name: name)
        case GoodNight:
            let name = NSLocalizedString("GoodNight", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "good_night_icon", name: name)
        case Location:
            let name = NSLocalizedString("Location", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "bow_icon", name: name)
        case Love:
            let name = NSLocalizedString("Love", tableName: "Localizable", bundle: NSBundle.mainBundle(), value: "", comment: "")
            return StatusType(iconImageName: "love_icon", name: name)
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
