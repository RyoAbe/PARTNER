//
//  BaseOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: 名前変えたい
class BaseOperation: NSOperation {

    // MARK: - Enums
    enum BaseOperationResult {
        case Success(AnyObject?), Failure(NSError?)
    }

    enum BaseOperationState {
        case Ready, Executing, Finished
        var keyPath : NSString {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }

    // MARK: - Properties
    override var ready: Bool { return state == .Ready }
    override var executing: Bool { return state == .Executing }
    override var finished: Bool { return state == .Finished }
    var result: AnyObject?
    var error: NSError?
    var executeSerialBlock: (() -> BaseOperationResult)!
    var executeAsyncBlock: (() -> Void)!
    var state: BaseOperationState {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            switch newValue {
            case .Ready:
                break
            case .Executing:
                if needShowHUD { dispatchAsyncMainThread({ MRProgressOverlayView.show(); return }) }
                break
            case .Finished:
                if needShowHUD { dispatchAsyncMainThread({ MRProgressOverlayView.hide()}) }
                break
            }
        }
        didSet {
            didChangeValueForKey(state.keyPath)
        }
    }

    // ???: 追加出来るようにする
    override var completionBlock: (() -> Void)? {
        get { return super.completionBlock }
        set {
            if let block = newValue {
                super.completionBlock = { dispatch_async(dispatch_get_main_queue()) { block() } }
            }
        }
    }


    // MARK: - Initializers
    override init() {
        self.state = .Ready
        super.init()
    }

    // MARK: - NSOperation
    override func start() {
        if cancelled {
            state = .Finished
            return
        }
        state = .Executing
        main()
    }

    // ???: executeAsyncBlockとexecuteSerialBlockを分断
    override func main() {
        LoggerInfo("execute operation")

        assert(!NSThread.currentThread().isMainThread, "call from main thread")

        if !Reachability.isReachable() {
            finishWithError(NSError.code(.NetworkOffline))
            return
        }

        assert(executeAsyncBlock != nil || executeSerialBlock != nil, "executeBlock should be not nil")
        if let block = executeAsyncBlock {
            block()
            return
        }
        switch executeSerialBlock() {
            case .Success(let ret):
                finishWithResult(ret)
                return
            case .Failure(let err):
                finishWithError(err!)
                return
        }
    }

    // MARK: -
    func finishWithError(error: NSError?) {
        self.error = error
        LoggerInfo("\(error)")
        dispatchAsyncMainThread({ self.error!.toast() })
        finish()
    }

    func finishWithResult(result: AnyObject?) {
        self.result = result
        finish()
    }

    func finish() {
        LoggerInfo("finish")
        state = .Finished
    }

    private var needShowHUD = true
    func enableHUD(enable: Bool) -> BaseOperation {
        needShowHUD = enable
        return self
    }

    deinit {
        LoggerInfo("deinit")
    }
}
