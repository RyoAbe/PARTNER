//
//  BaseOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseOperation: NSOperation {
    // MARK: - Enums
    enum BaseOperationResult {
        case Success(AnyObject?), Failure(NSError?)
    }

    enum BaseOperationState {
        case Ready, Executing, Finished
        var keyPath : String {
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
                if needShowHUD {
                    dispatchAsyncMainThread{
                        MRProgressOverlayView.show()
                    }
                }
                break
            case .Finished:
                if needHideHUD {
                    dispatchAsyncMainThread{
                        MRProgressOverlayView.hide()
                    }
                }
                break
            }
        }
        didSet {
            didChangeValueForKey(state.keyPath)
        }
    }

    // ???: Filter出来るようにする
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

    // ???: executeAsyncBlockとexecuteSerialBlockを意識しないようにしたい
    override func main() {
        Logger.info("execute operation")

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
        if error == nil {
            finish()
            return
        }
        self.error = error
        Logger.info("\(error)")
        dispatchAsyncMainThread{ self.error!.toast() }
        finish()
    }

    func finishWithResult(result: AnyObject?) {
        self.result = result
        finish()
    }

    func finish() {
        Logger.info("finish")
        state = .Finished
    }

    private var needShowHUD = true
    private var needHideHUD = true
    func enableHUD(enable: Bool) -> BaseOperation {
        needShowHUD = enable
        needHideHUD = enable
        return self
    }
    func needShowHUD(need: Bool) -> BaseOperation {
        needShowHUD = need
        return self
    }
    func needHideHUD(need: Bool) -> BaseOperation {
        needHideHUD = need
        return self
    }
    deinit {
        Logger.info("deinit")
    }
}
