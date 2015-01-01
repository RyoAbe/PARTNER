//
//  BaseOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseOperation: NSOperation {
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
