//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: NSOperation {
    override func main() {
        PFFacebookUtils.logInWithPermissions(["public_profile"], {user, error in
            if (user == nil) {
                // ???: キャンセル時、UI側でエラートースト
                return
            }
            self.requestForMe()
        })
    }

    private func requestForMe() {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if (error != nil) {
                // ???: UI側でエラートーストを表示
                return
            }
            let userData = result as FBGraphObject
            let name = userData["name"] as NSString
            let id = userData["id"] as NSString
            let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=398&height=398")!
            let image = UIImage(data:NSData(contentsOfURL:url)!)!
            MyProfile.save(name, image: image)
            // ???: UI側でログイン出来たことをトースト
        })
    }
}
