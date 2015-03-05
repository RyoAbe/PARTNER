//
//  BaseOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseOperation: NSOperation {
    
    // TODO: くるくる表示できるように
    // TODO: completionに dispatch_async(dispatch_get_main_queue(), { }) を入れましょう
    private var _executing = false
    override var executing : Bool {
        get { return _executing }
        set(newValue) {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    private var _finished = false
    override var finished : Bool {
        get { return _finished }
        set(newValue) {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
}
