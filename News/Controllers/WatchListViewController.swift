//
//  WatchListViewController.swift
//  News
//
//  Created by Boris Bolshakov on 29.11.21.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    
    private var searchTimer: Timer?
    
    // MARK: - Views
    private var panel: FloatingPanelController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTitleView()
        setupFloatingPanel()
    }
    
    // MARK: - Helpers
    private func setupTitleView() {
        
        let titleView = UIView(
            frame: .init(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100
            )
        )
        
        let label = UILabel(
            frame: .init(
                x: 10,
                y: 0,
                width: titleView.width,
                height: titleView.height
            )
        )
        
        label.text = "DailyNews"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
    
    private func setupFloatingPanel() {
        let panel = FloatingPanelController(delegate: self)
//        let customAppearace = SurfaceAppearance()
//        customAppearace.cornerRadius = 15
//        customAppearace.backgroundColor = .secondarySystemBackground
//        panel.surfaceView.appearance = customAppearace
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.addPanel(toParent: self)
        
        let vc = NewsViewController(type: .topStories)
        panel.set(contentViewController: vc)
        panel.track(scrollView: vc.tableView)
    }
    
    
}

// MARK: - UISearchResultsUpdating
extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        // Reset timer
        searchTimer?.invalidate()
        
        // New timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.articles)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
        
    }
}

// MARK: - SearchResultsViewControllerDelegate
extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsControllerDidSelect(searchResult: Article) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let vc = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.title
        present(navVC, animated: true)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
        
        var bottomInset: CGFloat = 0
        
        if fpc.state == .tip {
            bottomInset = 70
        } else if fpc.state == .half {
            bottomInset = 360
        }
        
//        tableView.contentInset = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
//        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}
