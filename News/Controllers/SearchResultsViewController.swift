//
//  SearchResultsViewController.swift
//  News
//
//  Created by Boris Bolshakov on 29.11.21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsControllerDidSelect(searchResult: Article)
}

class SearchResultsViewController: UIViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    private var results = [Article]()
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseId)
//        tv.delegate = self
//        tv.dataSource = self
//        tv.isHidden = true
        return tv
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(with results: [Article]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchResultsViewController:  UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseId,
            for: indexPath
        )

        let item = results[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
        
        let item = results[indexPath.row]
        
        delegate?.searchResultsControllerDidSelect(searchResult: item)
   }
    
}
