//
//  TableViewController.swift
//  Challange2
//
//  Created by Dmitry on 02.07.2021.
//

import UIKit

class TableViewController: UITableViewController {

    private var shopItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shopItems[indexPath.row]
        return cell
    }
    
    private func setUpTableView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAllItems))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareItems))
        
        navigationItem.rightBarButtonItems = [shareButton, addButton]
    }
    
    private func add(_ item: String){
        if !item.isEmpty {
            shopItems.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "What do you need to do?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addItem = UIAlertAction(title: "OK", style: .default) { _ in
            guard let newItem = ac.textFields?.first?.text else { return }
            self.add(newItem)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(addItem)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func clearAllItems() {
        shopItems.removeAll()
        tableView.reloadData()
    }
    
    @objc func shareItems() {
        let text = "List to do:"
        let list = shopItems.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [text, list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems![0]
        present(vc, animated: true)
    }
}
