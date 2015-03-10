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

    func toastWithMessage(message: NSString) {
        UIApplication.sharedApplication().keyWindow!.makeToast(message)
    }

    func toastWithError(error: NSError) {
        if let message = error.userInfo![NSLocalizedDescriptionKey] as? NSString {
            toastWithMessage(message)
            return
        }
        toastWithMessage(PartnerErrorCode.Unknown.description)
    }
}

extension Reachability {
    // ???: こうじゃない感
    class func isReachable() -> Bool {
        return Reachability.reachabilityForInternetConnection().isReachable()
    }
}

extension UIViewController {
    func showAlert(message: NSString, okBlock: (() -> Void)!) {
        let alert = UIAlertController(title: "Confirm", message: message as NSString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ action in
            okBlock()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    func showErrorAlert(error: NSError) {
        let alert = UIAlertController(title: "Confirm", message: error.userInfo![NSLocalizedDescriptionKey] as NSString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
