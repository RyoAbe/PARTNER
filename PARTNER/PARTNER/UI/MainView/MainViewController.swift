//
//  MainViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/08/10.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// TODO: Analytics入れる（tracker）
class MainViewController: BaseViewController, UICollectionViewDelegate {

    enum Menus : Int {
        case First
        case Second
        case Third
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myStatusView: StatusBaseView!
    @IBOutlet weak var partnersStatusView: StatusBaseView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "MessageMenuCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        setupStatusView()
        setupNavigationItem()
        showSignInFacebookAlertIfNeeded()
    }
    
    func setupStatusView() {
        let myProfile = MyProfile.read()
        let partner = Partner.read()
        let currentUser = PFUser.currentUser()
        Logger.debug("\(currentUser),\n\(myProfile),\n\(partner)")
        partnersStatusView.profile = partner
        partnersStatusView.statusViewType = .PartnersStatus
        myStatusView.profile = myProfile
        myStatusView.statusViewType = .MyStatus
    }

    func setupNavigationItem() {
        let addBarButtonItem = UIBarButtonItem(image: UIImage(named:"add_button"), style: .Plain, target: self, action: "didSelectAddPartnerButton:")
        let reloadBarButtonItem = UIBarButtonItem(image: UIImage(named:"reload_button"), style: .Plain, target: self, action: "didSelectReloadButton:")
        let insets = reloadBarButtonItem.imageInsets
        reloadBarButtonItem.imageInsets = UIEdgeInsetsMake(insets.top, insets.left - 15, insets.bottom, insets.right)
        navigationItem.leftBarButtonItems = [addBarButtonItem, reloadBarButtonItem]
    }

    func showSignInFacebookAlertIfNeeded() -> Bool {
        if MyProfile.read().isAuthenticated {
            return false
        }

        let alert = UIAlertController(title: "Login With Facebook?", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.dispatchAsyncOperation(LoginToFBOperation())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        return true
    }
    
    func showMyQRCodeViewIfNeeded() -> Bool {
        if MyProfile.read().hasPartner {
           return false
        }
        performSegueWithIdentifier("MyQRCodeViewSegue", sender: self)
        return true
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MessageMenuCell
        let type = StatusTypes(rawValue: indexPath.row)!.statusType
        cell.menuLabel.text = type.name
        cell.menuIcon.image = UIImage(named: type.iconImageName)
        return cell;
    }

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MessageMenuCell
        cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MessageMenuCell
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.backgroundColor = UIColor.whiteColor()
        })
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !isReady {
            return
        }

        // ???: Locatioで現在地を送れる
        // ???: 着く時間を設定出来るように
        let myProfile = MyProfile.read()
        if !myProfile.hasPartner {
            return
        }
        let types = StatusTypes(rawValue: indexPath.row)!
        FBAppEvents.logEvent("DidTapSendMyStatus - types \(types.statusType.name)")
        dispatchAsyncOperation(SendMyStatusOperation(partnerId: Partner.read().id!, statusTypes: types))
    }

    // MARK: -
    var isReady: Bool {
        if showSignInFacebookAlertIfNeeded() {
            toastWithMessage("Please sign in with Fasebook.")
            return false
        }
        if showMyQRCodeViewIfNeeded() {
            toastWithMessage("You have no partner.")
            return false
        }
        return true
    }
    
    var isAuthenticated: Bool {
        if showSignInFacebookAlertIfNeeded() {
            toastWithMessage("Please sign in with Fasebook.")
            return false
        }
        return true
    }
    
    var canSeeHistory: Bool {
        if MyProfile.read().statuses?.count == 0 && Partner.read().statuses?.count == 0 {
            toastWithMessage("No message.")
            return false
        }
        return true
    }
    
    func performSegueForSendStatus(identifier: String) {
        if !isReady {
            return
        }
        if !canSeeHistory {
            return
        }
        performSegueWithIdentifier(identifier, sender: self)
    }
    
    func performSegueForNoPartner(identifier: String) {
        if !isAuthenticated {
            return
        }
        performSegueWithIdentifier(identifier, sender: self)
    }
    
    // MARK: - IBAction
    @IBAction func didSelectReloadButton(sender: AnyObject) {
        let myProfile = MyProfile.read()
        if myProfile.hasPartner {
            dispatchAsyncOperation(UpdatePartnerOperation(partnerId: Partner.read().id!).needHideHUD(!myProfile.isAuthenticated))
        }
        if myProfile.isAuthenticated {
            dispatchAsyncOperation(UpdateMyProfileOperation().needShowHUD(!myProfile.hasPartner))
        }
    }
    @IBAction func didSelectSettingsButton(sender: AnyObject) {
        performSegueForNoPartner("SettingViewSegue")
    }

    @IBAction func didSelectAddPartnerButton(sender: AnyObject) {
        performSegueForNoPartner("MyQRCodeViewSegue")
    }

    @IBAction func didSelectMyStatusView(sender: AnyObject) {
        performSegueForSendStatus("HistoryViewSegue")
    }

    @IBAction func didSelectParterStatusView(sender: AnyObject) {
        #if DEBUG
        let myProfile = MyProfile.read()
        if myProfile.isAuthenticated && !myProfile.hasPartner && UIUtil.isSimulator() {
            let userQuery = PFUser.query()!.whereKey("username", equalTo: "Ryo Abe")
            if let user = userQuery.getFirstObject() as? PFUser {
                dispatchAsyncOperation(AddPartnerOperation(candidatePartnerId:user.objectId!))
            }
            return
        }
        #endif
        performSegueForSendStatus("HistoryViewSegue")
    }
}

