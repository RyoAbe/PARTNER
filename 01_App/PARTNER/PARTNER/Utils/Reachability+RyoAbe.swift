//
//  Reachability+RyoAbe.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/08.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

extension Reachability {

    // ???: こうじゃない感じ
    class func isReachable() -> Bool {
        return Reachability.reachabilityForInternetConnection().isReachable()
    }
}