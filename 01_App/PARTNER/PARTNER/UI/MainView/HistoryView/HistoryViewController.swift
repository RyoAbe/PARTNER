//
//  HistoryViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var closeButtonImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var historyViewDataSource: HistoryViewDataSource?
    var historyViewDelegate: HistoryViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)

        historyViewDataSource = HistoryViewDataSource()
        historyViewDelegate = HistoryViewDelegate()

        tableView.registerNib(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = historyViewDataSource
        tableView.delegate = historyViewDelegate

        tableView.separatorColor = UIColor.blackColor()
        closeButtonImageView.tintColor = UIColor.blackColor()
    }

    @IBAction func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}