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
        NSLog("currentUser: \(currentUser), myProfile: \(myProfile), partner: \(partner)")

        partnersStatusView.profile = partner
        myStatusView.profile = myProfile
        
        if showSignInFacebookAlertIfNeeded() {
            return
        }

        if myProfile.isAuthenticated && UIUtil.isSimulator() && !myProfile.hasPartner {
            dispatchAsyncOperation(AddPartnerOperation(candidatePartnerId:"1nqjqaIqwW"))
            return
        }
    }

    func showSignInFacebookAlertIfNeeded() -> Bool {
        if MyProfile.read().isAuthenticated {
            return false
        }

        let alert = UIAlertController(title: "Sign in With Facebook?", message: "", preferredStyle: UIAlertControllerStyle.Alert)

        // TODO: キャンセルしたら画面上のどこかで改めて Sign in 出来るようにする（そもそもログイン画面を作る？）
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.dispatchAsyncOperation(LoginToFBOperation())
        }))
        presentViewController(alert, animated: true, completion: nil)
        return true
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MessageMenuCell

        // ???: 【CoreData】Menu項目はCoreDataから取得する
        let type = StatusTypes(rawValue: indexPath.row)!.statusType
        cell.menuLabel.text = type.name
        cell.menuIcon.image = UIImage(named: type.iconImageName)
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
        // ???: 【CoreData】pushが成功したらCoreDataに保存。
        // ???: 一旦メニューの項目は定数で持つようにしている（将来的にはCoreDataから引っ張ってくるように）
        // TODO: Locatioで現在地を遅れるように
        // ???: 着く時間を設定出来るように

        let myProfile = MyProfile.read()
        if !myProfile.hasPartner {
            // TODO: まだパートナーがいないことをalertで表示
            return
        }
        let type = StatusTypes(rawValue: indexPath.row)!.statusType
        dispatchAsyncOperation(SendMyStatusOperation(statusType: type))
    }

    @IBAction func didSelectMyStatusView(sender: AnyObject) {
        performSegueWithIdentifier("HistoryViewSegue", sender: self)
    }

    @IBAction func didSelectParterStatusView(sender: AnyObject) {
        performSegueWithIdentifier("HistoryViewSegue", sender: self)
    }
}

