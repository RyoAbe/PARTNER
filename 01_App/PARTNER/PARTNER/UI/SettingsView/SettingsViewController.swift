//
//  SettingsViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/06.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // ???: 【まだいい】他に設定項目がないか検討
    // ???: 【まだいい】設定項目がすべての項目が一緒くたんになってるかわそれぞれ分裂する
    
    enum SettingsSection : Int {
        case First
        case Second
        case Third
    }

    enum SettingsFirstSection : Int {
        case username
        case addPartner
    }

    enum SettingsSecondSection : Int {
        case pushNotification
    }

    enum SettingsThirdSection : Int {
        case ReviewOnAppStore
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
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            // ???: 【保留】自分の名前をUserDefault or CoreDataに保存 http://somtd.hatenablog.com/entry/2013/12/07/230851
//            UpdateUserOperation(username: self.usernameTextField.text).save()
        })
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        switch SettingsSection(rawValue: indexPath.section)! {
        case .First:
            switch SettingsFirstSection(rawValue: indexPath.row)! {
            case .username:
                var frame = self.usernameTextField.frame
                frame.size = cell.frame.size
                self.usernameTextField.frame = CGRectInset(frame, 16, 0)
                cell.addSubview(self.usernameTextField)
                break
            case .addPartner:
                break
            }
            break
        case .Second:
            switch SettingsSecondSection(rawValue: indexPath.row)! {
            case .pushNotification:
                cell.accessoryView = self.pushNotificationSwitch
                break
            }
            break
        case .Third:
            break
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if (SettingsSection(rawValue: indexPath.section) == SettingsSection.Third &&
            SettingsThirdSection(rawValue: indexPath.row) == SettingsThirdSection.ReviewOnAppStore) {
            // ???: App StoreのURL
        }
    }
}
