//
//  Status.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class Status: NSObject, NSCoding {
    let types: StatusTypes!
    let date: NSDate!
    init(types: StatusTypes, date: NSDate){
        self.types = types
        self.date = date
    }

    required init(coder aDecoder: NSCoder) {
        let typesNumber = aDecoder.decodeObjectForKey("types") as! NSNumber
        types = StatusTypes(rawValue: typesNumber.integerValue)
        date = aDecoder.decodeObjectForKey("date") as! NSDate
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(NSNumber(integer: types.rawValue), forKey: "types")
        aCoder.encodeObject(date, forKey: "date")
    }
}