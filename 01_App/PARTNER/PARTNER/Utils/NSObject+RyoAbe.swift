//
//  NSObject+RyoAbe.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/09.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

extension NSObject {

    func dispatchAsyncMainThread(block: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), block)
    }

    func dispatchAsyncMultiThread(block: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }

    // ???: これじゃない感
    func dispatchAsyncOperation(op: BaseOperation) {
        dispatchAsyncMultiThread({op.start()})
    }

    var className: NSString {
        var className = NSStringFromClass(self.dynamicType)
        var range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
}
