//
//  LoginToFBOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class LoginToFBOperation: BaseOperation {

    var pfMyProfile: PFMyProfile!
    var retry: Bool = false

    override init() {
        super.init()
        let myProfile = MyProfile.read()
        self.executeAsyncBlock = {
            assert(!myProfile.isAuthenticated, "既にログイン済み")
            self.logIn()
        }
    }

    private func logIn() {
        PFFacebookUtils.logInWithPermissions(["public_profile"]) {pfMyProfile, error in
            if let error = error {
                Logger.debug("error >>> \(error)")
                self.loginError(pfMyProfile, error: error)
                return
            }
            self.pfMyProfile = PFMyProfile(user: pfMyProfile!)
            self.dispatchAsyncMainThread { self.startForMe() }
        }
    }

    private func loginError(pfMyProfile: PFUser?, error: NSError) {
        if error.domain == FacebookSDKDomain {
            if error.code == 5 && !retry {
                logIn()
                retry = true
                return
            }
            if error.code == 2 {
                showCheckFacebookSettingAlert()
                finishWithError(nil)
                return
            }
        }
        finishWithError(error)
    }
    
    private func showCheckFacebookSettingAlert() {
        let alert = UIAlertController(title: "Could not login with Facebook", message: "Facebook login failed. Please check your Facebook settings on your phone.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { action in
            UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root")!)
        }
        alert.addAction(action)

        let vc = (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController!
        vc.presentViewController(alert, animated: true, completion: nil)
    }

    private func startForMe() {
        FBRequestConnection.startForMeWithCompletionHandler{connection, result, error in
            if error != nil {
                self.finishWithError(error)
                return
            }
            self.dispatchAsyncMultiThread{
                self.startForMeWithCompletion(result as? FBGraphObject, error: error)
            }
        }
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

        var error: NSError?
        let installation = PFInstallation.currentInstallation()
        installation.setObject(PFUser.currentUser()!, forKey: "user")
        installation.save(&error)
        if error != nil {
            finishWithError(error)
            return
        }
        
        let fbId = fbObject!["id"] as! String
        let username = fbObject!["name"] as! String
        let profileImageFile = PFFile(data: NSData(contentsOfURL:NSURL(string: "https://graph.facebook.com/\(fbId)/picture?width=398&height=398")!)!)
        if let pfMyProfile = pfMyProfile {
            pfMyProfile.username = username
            pfMyProfile.fbId = fbId
            pfMyProfile.profileImage = profileImageFile
            pfMyProfile.partner = nil
            pfMyProfile.removeAllStatuses()
            pfMyProfile.save(&error)
            if error != nil {
                finishWithError(error)
                return
            }
        }
        needHideHUD(false)
        dispatchAsyncMainThread {
            self.dispatchAsyncOperation(UpdateMyProfileOperation().needShowHUD(false))
        }
        addPartnerIfEixst()
    }

    func addPartnerIfEixst() {
        if !pfMyProfile!.hasPartner {
            finish()
            return
        }
        let op = AddPartnerOperation(candidatePartner: PFUser.currentPartner(pfMyProfile.partner!.objectId!)!)
        op.completionBlock = {
            let r: AnyObject? = op.error != nil ? op.error : op.result
            self.finishWithResult(r)
        }
    }
}
