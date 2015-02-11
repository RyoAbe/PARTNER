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
            return
        }
    
        if UIUtil.isSimulator() && !myProfile.hasPartner {
//            addPartnerForDebug("c7iNlweYhk")
            return
        }
    }
    
    func addPartnerForDebug(id: NSString) {
        MRProgressOverlayView.show()
        let op = GetUserOperation(objectId: id)
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

    func partnersStatus(statusTypeId: NSInteger, date: NSDate){
        let partner = Partner.read()
        partner.statusType = self.statusTypes[statusTypeId] as? StatusType
        partner.statusDate = date
        partner.save()
    }

    // ???: なんとかしたい
    var statusTypes : NSArray {
        return [
            StatusType(id: 1, iconImageName: "good_morning_icon", name: "Good morning."),
            StatusType(id: 2, iconImageName: "going_home_icon", name: "I’m going home."),
            StatusType(id: 3, iconImageName: "thank_you_icon", name: "Thank You!"),
            StatusType(id: 4, iconImageName: "have_dinner_icon", name: "I have dinner."),
            StatusType(id: 5, iconImageName: "there_icon", name: "I’m almost there."),
            StatusType(id: 6, iconImageName: "god_it_icon", name: "Got it."),
            StatusType(id: 7, iconImageName: "good_night_icon", name: "Good night."),
            StatusType(id: 8, iconImageName: "location_icon", name: "Location"),
            StatusType(id: 9, iconImageName: "love_icon", name: "I Love you.")
        ]
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MessageMenuCell

        // ???: 【CoreData】Menu項目はCoreDataから取得する
        // ???: 【保留】Menu項目のアイコンの再考
        // ???: 【次にやる！！！】ベタ書きになってるからDataSourceを作る
        let statusType = self.statusTypes[indexPath.row] as StatusType
        cell.menuLabel.text = statusType.name
        cell.menuIcon.image = UIImage(named: statusType.iconImageName)
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
        // ???: 一旦メニューの項目は定数で持つようにしている（将来的にはCoreDataから引っ張ってくるように）
        // ???: ここもOperationにする
        // ???: Locatioで現在地を遅れるように
        // ???: 着く時間を設定出来るように

        let myProfile = MyProfile.read()
        let partner = Partner.read()

        let userQuery = PFUser.query()
        userQuery.whereKey("objectId", equalTo: partner.id)

        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery:userQuery)

        let push = PFPush()
        push.setQuery(pushQuery)

        let date = NSDate()
        let data = ["alert"           : "\(myProfile.name):「\(cell.menuLabel.text!)」",
                    "notificationType": "Status",
                    "id"              : indexPath.row,
                    "date"            : "\(date.timeIntervalSince1970)"]
        push.setData(data)
        push.sendPushInBackground()

        myProfile.statusType = self.statusTypes[indexPath.row] as? StatusType
        myProfile.statusDate = date
        myProfile.save()
    }

    @IBAction func settings(sender: UIBarButtonItem) {
        performSegueWithIdentifier("AccountRegistrationSegue", sender: self)
    }
}

