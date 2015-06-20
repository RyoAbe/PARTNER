//
//  NSError+Partner.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/09.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

enum PartnerErrorCode: NSInteger {
    // ???: ErrorCodeについて、もう少し一般的な付け方はないか調べる
    case Unknown = 0
    case NetworkOffline = 1009
    case NotFoundUser = 4040
    var description: String {
        switch self {
        case .Unknown: return "Occurrence of an unexplained error.";
        case .NetworkOffline: return "Can't connect to Internet.";
        case .NotFoundUser: return "Not found user.";
        }
    }
}
var PartnerDomain: String {
    return "com.ryoabe.PARTNER"
}
extension NSError {
    class func code(code: PartnerErrorCode) -> NSError {
        return NSError(domain: PartnerDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : code.description])
    }
    func toast() {
        toastWithError(self)
    }
}