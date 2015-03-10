//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: BaseOperation {

    override init() {
        super.init()
        self.executeAsyncBlock = {
            assert(!MyProfile.read().isAuthenticated, "既にログイン済み")
            PFFacebookUtils.logInWithPermissions(["public_profile"], {pfMyProfile , error in
                self.dispatchAsyncMultiThread({ self.loginCompletion(pfMyProfile, error: error) })
            })
        }
    }
    
    private func loginCompletion(pfMyProfile: PFUser?, error: NSError?) {
        if error != nil {
            self.finish(error)
            return
        }
        if let myProfile = pfMyProfile {
            self.dispatchAsyncMainThread({ self.startForMe(myProfile) })
            return
        }
        self.finish(NSError.code(.NotFoundUser))
    }

    private func startForMe(pfMyProfile: PFUser) {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if error != nil {
                self.finish(NSError.code(.NetworkOffline))
                return
            }
            self.dispatchAsyncMultiThread({ self.startForMeWithCompletion(pfMyProfile, fbObject: result as? FBGraphObject, error: error) })
        })
    }

    private func startForMeWithCompletion(pfMyProfile: PFUser, fbObject: FBGraphObject?, error: NSError?) {
        if error != nil {
            finish(NSError.code(.NetworkOffline))
            return
        }

        if fbObject == nil {
            finish(NSError.code(.NotFoundUser))
            return
        }

        let fbId = fbObject!["id"] as NSString
        let username = fbObject!["name"] as NSString
        let profileImageFile = PFFile(data: NSData(contentsOfURL:NSURL(string: "https://graph.facebook.com/\(fbId)/picture?width=398&height=398")!)!)
        
        var error: NSError?
        let installation = PFInstallation.currentInstallation()
        installation.setObject(PFUser.currentUser(), forKey: "user")
        installation.save(&error)
        if error != nil {
            finish(NSError.code(.NetworkOffline))
            return
        }

        pfMyProfile.username = username
        pfMyProfile["fbId"] = fbId
        pfMyProfile["profileImage"] = profileImageFile
        pfMyProfile["hasPartner"] = false
        pfMyProfile.save(&error)

        if error != nil {
            finish(NSError.code(.NetworkOffline))
            return
        }
        
        let profileImageData = profileImageFile.getData()
        self.dispatchAsyncMainThread({
            let myProfile = MyProfile.read()
            myProfile.id = pfMyProfile.objectId
            myProfile.image = UIImage(data: profileImageData)!
            myProfile.name = username
            myProfile.isAuthenticated = true
            myProfile.save()
        })
        self.finish()
    }
}
