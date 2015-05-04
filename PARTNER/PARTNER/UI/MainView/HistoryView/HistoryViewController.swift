//
//  HistoryViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController, HistoryViewDataSourceDelegate {

    @IBOutlet weak var closeButtonImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var historyViewDataSource: HistoryViewDataSource!
    var historyViewDelegate: HistoryViewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)

        historyViewDataSource = HistoryViewDataSource(delegate: self)
        historyViewDelegate = HistoryViewDelegate()

        tableView.registerNib(UINib(nibName: "MyHistoryCell", bundle: nil), forCellReuseIdentifier: "MyHistoryCell")
        tableView.registerNib(UINib(nibName: "PartnersHistoryCell", bundle: nil), forCellReuseIdentifier: "PartnersHistoryCell")

        tableView.dataSource = historyViewDataSource
        tableView.delegate = historyViewDelegate

        tableView.separatorStyle = .None
        closeButtonImageView.tintColor = UIColor.blackColor()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let size = tableView.contentSize
        let f = tableView.frame
        if f.height > size.height {
            return
        }
        let p = CGPointMake(0, size.height - f.height)
        tableView.setContentOffset(p, animated: true)
    }

    // MARK: - IBAction

    @IBAction func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - HistoryViewDataSourceDelegate

    func didChangeDataSource(dataSource: HistoryViewDataSource) {
        tableView.reloadData()
        scrollToBottom()
    }
}