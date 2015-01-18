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
            let query = PFUser.query()
            query.getObjectInBackgroundWithId(user.objectId, block: { object, error in
                let fbObject = result as FBGraphObject
                let fbId = fbObject["id"] as NSString
                let username = fbObject["name"] as NSString
                let url = NSURL(string: "https://graph.facebook.com/\(fbId)/picture?width=398&height=398")!
                let profileImageData = PFFile(data: NSData(contentsOfURL:url)!)

                let user = object as PFUser
                user.username = username
                user["fbId"] = fbId
                user["profileImage"] = profileImageData
                user["hasPartner"] = false
                object.saveInBackgroundWithBlock{ succeeded, error in
                    let myProfile = MyProfile.read()
                    myProfile.id = user.objectId
                    myProfile.image = UIImage(data: profileImageData.getData())!
                    myProfile.name = username
                    myProfile.isAuthenticated = true
                    myProfile.save()
                    self.finished = true
                }
            })
        })
    }
}
