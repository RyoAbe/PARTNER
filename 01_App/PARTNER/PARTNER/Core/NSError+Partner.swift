//
//  NSError+Partner.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/09.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

enum PartnerErrorCode: NSInteger {
    // ???: なんかもっとないかな。。
    case Unknown = 0
    case NetworkOffline = 1009
    case NotFoundUser = 4040
    var description : NSString {
        switch self {
        case .Unknown: return "Cccurrence of an unexplained error.";
        case .NetworkOffline: return "Can't connect to Internet.";
        case .NotFoundUser: return "Not found user.";
        }
    }
}

extension NSError {
    class func code(code: PartnerErrorCode) -> NSError {
        return NSError(domain: "com.ryoabe.partner", code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : code.description])
    }
    func toast(){
        toastWithError(self)
    }
}

