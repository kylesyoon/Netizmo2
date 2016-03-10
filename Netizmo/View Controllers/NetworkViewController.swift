//
//  NetworkViewController.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 3/10/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
}

extension NetworkViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension NetworkViewController: UITableViewDelegate {
    
}