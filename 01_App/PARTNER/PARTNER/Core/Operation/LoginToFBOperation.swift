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
        login()
    }
    
    func login() {
        // パーミッションを指定してログイン
        PFFacebookUtils.logInWithPermissions(["user_about_me", "user_birthday"], {(user: PFUser!, error: NSError!) -> Void in
            // キャンセルしたとき
            if (user == nil) {
                return
            }
            // 初めてのログイン
            if (user.isNew) {
                self.requestForMe()
                return
            }
            // ログイン済み
            self.requestForProfileImage()
        })
    }
    
    func requestForMe() {
        // 自分についての情報を入手
        FBRequestConnection.startForMeWithCompletionHandler({ (connection, result:AnyObject!, error:NSError!) -> Void in
            if (error != nil) {
                return
            }
            // TODO: 受け取ったProfile情報をcoreDataもしくはuserDefaultsに保存。
            let userData:FBGraphObject = result as FBGraphObject
            let username:NSString = userData["name"] as NSString
            self.requestForProfileImage()
        })
    }
    
    func requestForProfileImage() {
        // プロフィール画像を取得
        FBRequestConnection.startWithGraphPath("me?fields=picture.width(398).height(398)", completionHandler: { (connection, result:AnyObject!, error:NSError!) -> Void in
            let userData:FBGraphObject = result as FBGraphObject
            NSLog("userData:%@",userData)
            // TODO: 受け取ったProfile情報をcoreDataもしくはuserDefaultsに保存。kvo経由でstatusViewのimageや氏名が書き換わり、Succeedとアラートがでる
        })
    }
}
