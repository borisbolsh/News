//
//  NewsViewController.swift
//  News
//
//  Created by Boris Bolshakov on 29.11.21.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    // MARK: - Properties
    enum `Type` {
        case topStories
        case topNews
        
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .topNews:
                return "Top News"
            }
        }
    }
    
    private var stories = [Article]()
    
    private var type: Type?
    
    // MARK: - Init
    init(type: Type) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tv = UITableView()

        tv.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.reuseId)
        tv.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.reuseId)
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        fetchNews()
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
    
    private func fetchNews() {
        APICaller.shared.news(for: type ?? .topNews) { [weak self] result in
                switch result {
                case .success(let stories):
                    DispatchQueue.main.async {
                        self?.stories = stories.articles
                        self?.tableView.reloadData()
                    }
                case .failure: break
                }

            }
        }
    
    
    private func open(with url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.reuseId, for: indexPath) as! NewsStoryTableViewCell
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.reuseId) as? NewsHeaderView else { return nil }
        header.configure(with: .init(
            title: self.type?.title ?? "",
            shouldShowAddButton: false
        ))
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        HapticsManager.shared.vibrateForSelection()
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFailedToOpenAlert()
            return
        }
        open(with: url)
    }
    
    private func presentFailedToOpenAlert() {
        let alert = UIAlertController(
            title: "Unable to Open",
            message: "We were unable to open the article.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
