//
//  Status.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class Status {
    let types: StatusTypes!
    let date: NSDate!
    init(types: StatusTypes, date: NSDate){
        self.types = types
        self.date = date
    }
}