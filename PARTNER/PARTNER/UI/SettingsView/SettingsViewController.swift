//
//  SettingsViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/06.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // ???: 電話かける機能を追加
    // ???: リセット or ログアウト and 再認証の仕組みを作る
    
    enum SettingsSection : Int {
        case First
        case Third
    }

    enum SettingsFirstSection : Int {
        case Username
        case AddPartner
    }

    enum SettingsSecondSection : Int {
        case pushNotification
    }

    enum SettingsThirdSection : Int {
        case ReviewOnAppStore
        case OpinionsRequest
        case About
    }

    @IBOutlet weak var profileBaseView: UIView!
    @IBOutlet weak var editProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!

    var usernameTextField: UITextField!
    var pushNotificationSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let myProfile = MyProfile.read()
        usernameTextField = UITextField(frame: CGRectZero)
        usernameTextField.placeholder = "Nickname"
        usernameTextField.text = myProfile.name
        pushNotificationSwitch = UISwitch();
        pushNotificationSwitch.on = true
        profileBaseView.layer.cornerRadius = profileBaseView.frame.width * 0.5
        editProfileImageButton.setImage(myProfile.image, forState: UIControlState.Normal)
        profileImageView.image = myProfile.image
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true){ }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        switch SettingsSection(rawValue: indexPath.section)! {
        case .First:
            switch SettingsFirstSection(rawValue: indexPath.row)! {
            case .Username:
                var frame = usernameTextField.frame
                frame.size = cell.frame.size
                usernameTextField.frame = CGRectInset(frame, 16, 0)
                usernameTextField.enabled = false
                cell.addSubview(usernameTextField)
                break
            case .AddPartner:
                break
            }
            break
        case .Third:
            break
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        switch SettingsSection(rawValue: indexPath.section)! {
            case .First:
                switch SettingsFirstSection(rawValue: indexPath.row)! {
                case .Username: break
                case .AddPartner: break
                }
                break
            case .Third:
                switch SettingsThirdSection(rawValue: indexPath.row)! {
                case .ReviewOnAppStore: UIApplication.sharedApplication().openURL(NSURL(string: "https://appsto.re/i6Lb57j")!)
                    break
                case .OpinionsRequest: UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/RyoAbe/")!)
                    break
                case .About: break
                }
                break
        }
    }
}
