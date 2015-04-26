//
//  DummyStatuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/15.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class DummyStatuses: Statuses {
    var dummyStatuses: [Status]

    override var numberOfRows: NSInteger {
        return dummyStatuses.count
    }
    
    override init(){
        dummyStatuses = []
        super.init()
//        for i in 0...100 {
//            let date = NSDate()
//            let type = Int(arc4random_uniform(9))
//            let status = arc4random_uniform(2) == 0 ? MyStatus(types: StatusTypes(rawValue: type)!, date: date)
//                                                    : PartnersStatus(types: StatusTypes(rawValue: type)!, date: date)
//            dummyStatuses.append(status)
//        }

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        dummyStatuses.append(MyStatus(types: .GoodMoning, date: dateFormatter.dateFromString("2015-04-11 09:14:00")!))
        dummyStatuses.append(PartnersStatus(types: .GoodMoning, date: dateFormatter.dateFromString("2015-04-11 09:27:00")!))

        dummyStatuses.append(MyStatus(types: .There, date: dateFormatter.dateFromString("2015-04-11 12:10:00")!))
        dummyStatuses.append(PartnersStatus(types: .GodId, date: dateFormatter.dateFromString("2015-04-11 12:13:00")!))

        dummyStatuses.append(PartnersStatus(types: .HaveDinner, date: dateFormatter.dateFromString("2015-04-11 09:14:00")!))
        dummyStatuses.append(MyStatus(types: .GodId, date: dateFormatter.dateFromString("2015-04-11 09:27:00")!))

        dummyStatuses.append(MyStatus(types: .GoodNight, date: dateFormatter.dateFromString("2015-04-11 09:14:00")!))
        dummyStatuses.append(PartnersStatus(types: .Love, date: dateFormatter.dateFromString("2015-04-11 09:27:00")!))
    }

    override func objectAtRow(row: NSInteger) -> Status? {
        return dummyStatuses[row]
    }
}