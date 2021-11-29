//
//  PersistanceManager.swift
//  News
//
//  Created by Boris Bolshakov on 29.11.21.
//

import Foundation

final class PersistanceManager {
    
    // MARK: - Properties
    static let shared = PersistanceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
         static let onboardedKey = "hasOnboarded"
         static let watchlistKey = "watchlist"
     }
     
    // MARK: - Init
       private init() {}
    
    
    var watchList: [String] {
        return []
    }
    
    func addToWatchList() {
        
    }
    
    func removeFromWatchList() {
        
    }
    
    private var hasOnboard: Bool {
        return false
    }
}
