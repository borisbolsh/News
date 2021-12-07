//
//  SearchResultTableViewCell.swift
//  News
//
//  Created by Boris Bolshakov on 30.11.21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseId = "SearchResultTableViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
