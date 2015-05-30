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
        dispatchAsyncMultiThread{ op.start() }
    }

    var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
    
    class var className : String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }

    func toastWithMessage(message: String) {
        UIApplication.sharedApplication().keyWindow!.makeToast(message)
    }

    func toastWithError(error: NSError) {
        if error.domain == PartnerDomain {
            toastWithMessage(PartnerErrorCode.Unknown.description)
            return
        }
        if let message = error.userInfo![NSLocalizedDescriptionKey] as? String {
            toastWithMessage(message)
            return
        }
        toastWithMessage(error.description)
    }
}

extension Reachability {
    // ???: こうじゃない感
    class func isReachable() -> Bool {
        return Reachability.reachabilityForInternetConnection().isReachable()
    }
}

extension UIViewController {
    func showAlert(message: String, okBlock: (() -> Void)!) {
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ action in
            okBlock()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    func showErrorAlert(error: NSError) {
        let alert = UIAlertController(title: "Confirm", message: error.userInfo![NSLocalizedDescriptionKey] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
