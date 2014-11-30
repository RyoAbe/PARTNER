//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: NSOperation {
    
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

    override func main() {
        PFFacebookUtils.logInWithPermissions(["public_profile"], {user, error in
            if (user == nil) {
                self.finished = true
                return
            }
            self.requestForMe()
        })
    }

    private func requestForMe() {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if (error != nil) {
                self.finished = true
                return
            }
            let userData = result as FBGraphObject
            let name = userData["name"] as NSString
            let id = userData["id"] as NSString
            let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=398&height=398")!
            let image = UIImage(data:NSData(contentsOfURL:url)!)!
            MyProfile.save(name, image: image)
            self.finished = true
        })
    }
}
