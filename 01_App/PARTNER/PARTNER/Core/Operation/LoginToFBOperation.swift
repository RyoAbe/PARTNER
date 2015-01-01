//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: BaseOperation {

    override func main() {
        PFFacebookUtils.logInWithPermissions(["public_profile"], {user , error in
            if (user == nil) {
                self.finished = true
                return
            }
            self.requestForMe(user)
        })
    }

    private func requestForMe(user: PFUser) {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if (error != nil) {
                self.finished = true
                return
            }

            // ???: ローカルに保存しつつ、fbIdをサーバーにも保存。
            let myProfile = MyProfile.read()
            let fbObject = result as FBGraphObject

            myProfile.id = user.objectId
            myProfile.image = self.fbProfileImageWithId(fbObject)
            myProfile.name = fbObject["name"] as NSString

            myProfile.save()

            self.finished = true
        })
    }
    
    private func fbProfileImageWithId(object: FBGraphObject) -> UIImage {
        let fbId = object["id"] as NSString
        let url = NSURL(string: "https://graph.facebook.com/\(fbId)/picture?width=398&height=398")!
        return UIImage(data:NSData(contentsOfURL:url)!)!
    }
}
