//
//  MainViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/08/10.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate {

    enum Menus : Int {
        case First
        case Second
        case Third
    }
    
    // ???: 【保留】初回のパートナーがいない状態のとき、即座にモーダルかかんかでパートナーの追加画面を表示する

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myStatusView: StatusBaseView!
    @IBOutlet weak var partnersStatusView: StatusBaseView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "MessageMenuCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        let myProfile = MyProfile.read()
        let partner = Partner.read()
        let currentUser = PFUser.currentUser()
        NSLog("currentUser: \(currentUser)")
        NSLog("myProfile: \(myProfile)")
        NSLog("partner: \(partner)")
        NSLog("~~~~~~~~~")

        partnersStatusView.profile = partner
        myStatusView.profile = myProfile
        if(!myProfile.isAuthenticated){
            showSignInFacebookAlert()
        }
    
        if !UIUtil.isSimulator() || myProfile.hasPartner {
            return
        }

        MRProgressOverlayView.show()
        let op = GetUserOperation(objectId: "QZzLuebvHZ")
        op.start()
        op.completionBlock = {
            if let user = op.result {
                let op = AddPartnerOperation(user: user)
                op.start()
                op.completionBlock = {
                    dispatch_async(dispatch_get_main_queue(), {
                        MRProgressOverlayView.hide()
                    })
                }
            }
        }
    }

    func showSignInFacebookAlert(){
        let alert = UIAlertController(title: "Sign in With Facebook?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        // ???: キャンセルしたら画面上のどこかで改めて Sign in 出来るようにする
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.Default, handler: { alertAction in
            MRProgressOverlayView.show()
            let op = LoginToFBOperation()
            op.start()
            op.completionBlock = {
                dispatch_async(dispatch_get_main_queue(), {
                    MRProgressOverlayView.hide()
                })
            }
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MessageMenuCell

        // ???: 【CoreData】Menu項目はCoreDataから取得する
        // ???: 【保留】Menu項目のアイコンの再考
        // ???: 【次にやる！！！】ベタ書きになってるからDataSourceを作る
        var labelText:NSString? = nil
        var imageName:NSString? = nil
        if(indexPath.row == 0){
            labelText = "Good morning."
            imageName = "good_morning"
        }else if(indexPath.row == 1){
            labelText = "I’m going home."
            imageName = "going_home"
        }else if(indexPath.row == 2){
            labelText = "I left home."
            imageName = "left_home"
        }else if(indexPath.row == 3){
            labelText = "I have dinner."
            imageName = "have_dinner"
        }else if(indexPath.row == 4){
            labelText = "I’m almost there."
            imageName = "there"
        }else if(indexPath.row == 5){
            labelText = "Got it."
            imageName = "god_it"
        }else if(indexPath.row == 6){
            labelText = "Good night."
            imageName = "good_night"
        }else if(indexPath.row == 7){
            labelText = "Location"
            imageName = "location"
        }else if(indexPath.row == 8){
            labelText = "I Love you."
            imageName = "love"
        }
        cell.menuLabel.text = labelText
        cell.menuIcon.image = UIImage(named: imageName!)

        return cell;
    }

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as MessageMenuCell
        cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as MessageMenuCell
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.backgroundColor = UIColor.whiteColor()
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as MessageMenuCell

        // ???: 【CoreData】pushが成功したらCoreDataに保存。
        // ???: 【次にやる！！！】一旦メニューの項目は定数で持つようにしよう（将来的にはCoreDataから引っ張ってくるように）
        // ???: ここもOperationにする
        // ???: Locatioで現在地を遅れるように
        // ???: 着く時間を設定出来るように
        // TODO: 時間も送る
        let myProfile = MyProfile.read()
        let partner = Partner.read()

        let userQuery = PFUser.query()
        userQuery.whereKey("objectId", equalTo: partner.id)

        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery:userQuery)

        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(["alert": "\(myProfile.name):「" + cell.menuLabel.text! + "」", "notificationType": "Message"])
        push.sendPushInBackground()
    }

    @IBAction func settings(sender: UIBarButtonItem) {
        performSegueWithIdentifier("AccountRegistrationSegue", sender: self)
    }
}

