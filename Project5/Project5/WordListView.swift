//
//  WordListView.swift
//  Project5
//
//  Created by Dmitry on 16.06.2021.
//

import UIKit

protocol WordListView: UIViewController {
    func restartView(with title: String?, and words: [String])
    func showErrorMessage(errorTitle: String, errorMessage: String)
    func updateView(words: [String], indexPath: IndexPath)
}

final class WordListViewController: UIViewController {
    
    private let presenter: WordListPresenter
    private var usedWords = [String]()
   
    private lazy var tableView = UITableView()
    
    init(presenter: WordListPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupView()
        
        presenter.setupAllWords()
        presenter.startGame()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    @objc private func startGame() {
        presenter.startGame()
    }
    
    @objc func promtAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak presenter, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            presenter?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
  
}

extension WordListViewController: WordListView {
    
    // MARK: - WordListView
    
    func restartView(with title: String?, and words: [String]) {
        self.title = title
        self.usedWords = words
        tableView.reloadData()
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func updateView(words: [String], indexPath: IndexPath) {
        self.usedWords = words
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}


extension WordListViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
}
