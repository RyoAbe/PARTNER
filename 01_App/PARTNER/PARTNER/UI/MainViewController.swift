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
    
    // TODO: 【まだいい】初回のパートナーがいない状態のとき、即座にモーダルかかんかでパートナーの追加画面を表示する

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var partnersStatusView: StatusBaseView!
    @IBOutlet weak var myStatusView: StatusBaseView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "MessageMenuCell", bundle: nil), forCellWithReuseIdentifier: "Cell");
        self.partnersStatusView.profile = Profile.createWithName("Sophia", imageName:"women");
        self.myStatusView.profile = Profile.createWithName("Ethan", imageName:"men");
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MessageMenuCell

        // TODO: 【保留】Menu項目はCoreDataから取得する
        // TODO: 【まだいい】Menu項目のアイコンの再考
        
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
        let push = PFPush()
        // TODO: TestChanelを削除して指定したユーザにpushされるように
        // TODO: pushが成功したらCoreDataに保存。
        push.setChannel("TestChanel")
        push.setMessage("Sophia:「" + cell.menuLabel.text! + "」")
        push .sendPushInBackground()
    }

    @IBAction func settings(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("AccountRegistrationSegue", sender: self)
    }
}

