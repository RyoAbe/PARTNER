//
//  MyStatuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class MyStatuses: Statuses {
    override init(){
        super.init()
        statuses = MyProfile.read().statuses!
    }
}