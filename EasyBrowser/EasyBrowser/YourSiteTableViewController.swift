//
//  YourSiteTableViewController.swift
//  EasyBrowser
//
//  Created by Dmitry on 16.06.2021.
//

import UIKit

class YourSiteTableViewController: UITableViewController {
    
    let websites = ["apple.com", "hackingwithswift.com"]


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VC") as? ViewController {
            let index = indexPath.row
            vc.webIndex = index
            vc.websites = websites
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
