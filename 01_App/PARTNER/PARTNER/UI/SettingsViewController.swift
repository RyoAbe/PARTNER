//
//  SettingsViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/06.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    enum Section : Int {
        case First
        case Second
        case Third
    }

    enum FirstSection : Int {
        case username
    }

    enum SecondSection : Int {
        case pushNotification
    }

    @IBOutlet weak var profileBaseView: UIView!
    var usernameTextField: UITextField!
    var pushNotificationSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView .registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.usernameTextField = UITextField(frame: CGRectZero)
        self.usernameTextField.placeholder = "Nickname"
        self.pushNotificationSwitch = UISwitch();
        self.pushNotificationSwitch.on = true
        self.profileBaseView.layer.cornerRadius = self.profileBaseView.frame.width * 0.5
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let op = UpdateUserOperation(username: self.usernameTextField.text)
            op.save()
        })
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        switch Section.fromRaw(indexPath.section)! {
        case .First:
            switch FirstSection.fromRaw(indexPath.row)! {
            case .username:
                var frame = self.usernameTextField.frame
                frame.size = cell.frame.size
                self.usernameTextField.frame = CGRectInset(frame, 16, 0)
                cell.addSubview(self.usernameTextField)
                break
            }
            break
        case .Second:
            switch SecondSection.fromRaw(indexPath.row)! {
            case .pushNotification:
                cell.accessoryView = self.pushNotificationSwitch
                break
            }
            break
        case .Third:
            break
        }
    }
}
