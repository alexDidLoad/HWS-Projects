//
//  TableViewController.swift
//  Project4
//
//  Created by Alexander Ha on 9/22/20.
//  Copyright © 2020 Alexander Ha. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Website Table"
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Web") as? ViewController {
            vc.selectedWebsites = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
