//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: BaseOperation {

    var pfMyProfile: PFMyProfile?
    override init() {
        super.init()
        assert(!MyProfile.read().isAuthenticated, "既にログイン済み")

        self.executeAsyncBlock = {
            PFFacebookUtils.logInWithPermissions(["public_profile"], {pfMyProfile , error in
                if error != nil {
                    // TODO: 設定からonにしてくださいアラート表示
                    self.finishWithError(error)
                    return
                }
                self.pfMyProfile = PFMyProfile(user: pfMyProfile)
                self.dispatchAsyncMainThread { self.startForMe() }
            })
        }
    }

    private func startForMe() {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if error != nil {
                self.finishWithError(error)
                return
            }
            self.dispatchAsyncMultiThread({ self.startForMeWithCompletion(result as? FBGraphObject, error: error) })
        })
    }

    private func startForMeWithCompletion(fbObject: FBGraphObject?, error: NSError?) {
        if error != nil {
            finishWithError(error)
            return
        }

        if fbObject == nil {
            finishWithError(NSError.code(.NotFoundUser))
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
            finishWithError(error)
            return
        }

        pfMyProfile!.username = username
        pfMyProfile!.fbId = fbId
        pfMyProfile!.profileImage = profileImageFile
        // TODO: もともと存在していた場合、相手方のパートナー（自分）を消さないとpush送信出来てしまう
        pfMyProfile!.partner = nil
        pfMyProfile!.removeAllStatuses()
        pfMyProfile!.hasPartner = false

        // ???: ACLは仕様により変更出来ない模様
        // https://www.parse.com/questions/cant-update-user-acl-on-the-dashboard-cloud-code-w-master-key
//        let acl = PFACL()
//        acl.setPublicWriteAccess(true)
//        acl.setPublicReadAccess(true)
//        pfMyProfile!.pfUser.ACL = acl

        pfMyProfile!.save(&error)

        if error != nil {
            finishWithError(error)
            return
        }
        
        let profileImageData = profileImageFile.getData()
        self.dispatchAsyncMainThread({
            let myProfile = MyProfile.read()
            myProfile.id = self.pfMyProfile!.objectId
            myProfile.image = UIImage(data: profileImageData)!
            myProfile.name = username
            myProfile.isAuthenticated = true
            myProfile.save()
        })
        self.addPartnerIfEixst()
    }

    func addPartnerIfEixst() {
        if !pfMyProfile!.hasPartner {
            self.finish()
            return
        }
        let op = AddPartnerOperation(candidatePartner: pfMyProfile!.partner!)
        op.completionBlock = {
            let r: AnyObject? = op.error != nil ? op.error : op.result
            self.finishWithResult(r)
        }
    }
}
