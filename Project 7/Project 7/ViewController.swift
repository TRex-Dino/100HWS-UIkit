//
//  ViewController.swift
//  Project 7
//
//  Created by Dmitry on 02.07.2021.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var savePetitions = [Petition]()
    var filtrPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filtredPetitions))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(canceledFilter))
        
        navigationItem.leftBarButtonItems = [filterButton, cancelButton]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //we're ok
                parse(json: data)
                return
            }
        }
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func canceledFilter() {
        petitions = savePetitions
        tableView.reloadData()
    }
    
    @objc private func showCredit() {
        let ac = UIAlertController(title: "This data comes from:", message: "We The People API of th Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc private func filtredPetitions() {
        let ac = UIAlertController(title: "Find petition", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let findAction = UIAlertAction(title: "Find", style: .default) { _ in
            guard let text = ac.textFields?.first?.text else { return }
            self.findPetitions(text)
        }
        ac.addAction(findAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    private func findPetitions(_ text: String) {
        filtrPetitions.removeAll()
        for petition in savePetitions {
            if petition.title.lowercased().contains(text.lowercased()) {
                filtrPetitions.append(petition)
            }
        }
        if filtrPetitions.isEmpty { return }
        petitions = filtrPetitions
        tableView.reloadData()
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading th feed; please check your conncetion and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            savePetitions = petitions
            tableView.reloadData()
        }
    }

}

