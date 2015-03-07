//
//  BaseOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseOperation: NSOperation {

    // TODO: 必要ならHUDを表示するように修正する
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
            filterCompletionBlock()
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }

    // ???: あまりカッコよくはない
    func filterCompletionBlock () {
        let block = self.completionBlock
        self.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                MRProgressOverlayView.hide()
                block?()
            })
        }
    }

    override func main() {
        super.main()
        dispatch_async(dispatch_get_main_queue(), {
            MRProgressOverlayView.show()
            return
        })
    }
}
