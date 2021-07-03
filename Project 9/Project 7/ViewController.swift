//
//  ViewController.swift
//  Project 7
//
//  Created by Dmitry on 02.07.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var allPetitions = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(filterPetitions))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        }
    
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
       
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
                }
            } else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            }
        }

    
    
   
    
    
    @objc func showCredits() {
//        instantiate our alert controller
        let petitionCredit = "Data pulled from We The People API of the Whitehouse"
        
        let alert = UIAlertController(title: "Credit", message: petitionCredit, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the data.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        }
        
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            allPetitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let Petition = petitions[indexPath.row]
        cell.textLabel?.text = Petition.title
        cell.detailTextLabel?.text = Petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterPetitions() {

        
        let ac = UIAlertController(title: "Filter Petitions", message: "Search by keyword", preferredStyle: .alert)
        ac.addTextField()
        
        let submitFilter = UIAlertAction(title: "Filter", style: .default) {
            [weak self, weak ac] _ in
            guard let filterQuery = ac?.textFields?[0].text else { return }
            self?.submit(filterQuery)
            
        }
        
        ac.addAction(UIAlertAction(title: "Clear", style: .cancel, handler: clearFilter))
        ac.addAction(submitFilter)
        
        present(ac, animated: true)
        
        
        
    }
    
    func submit(_ filterQuery: String) {
        
        
        petitions = filteredPetitions.filter {
            $0.title.lowercased().contains(filterQuery) || $0.body.lowercased().contains(filterQuery)
        }
        
        tableView.reloadData()
    }
    
    func clearFilter(clear: UIAlertAction!) {
        
        petitions = allPetitions
        tableView.reloadData()
    }
}


