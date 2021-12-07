//
//  NewsHeaderView.swift
//  News
//
//  Created by Boris Bolshakov on 6.12.21.
//

import UIKit

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

class NewsHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    static let reuseId = "NewsHeaderView"
    static let preferredHeight: CGFloat = 48
    
    weak var delegate: NewsHeaderViewDelegate?
    
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ WatchList", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        contentView.addSubviews(label, button)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        contentView.backgroundColor = .secondarySystemBackground
//        label.addBorder(side: .bottom, color: .separator, thickness: 0.5)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(
            x: 14,
            y: 0,
            width: contentView.width-28,
            height: contentView.height
        )

        button.sizeToFit()
        button.frame = CGRect(
            x: contentView.width-button.width-16,
            y: (contentView.height - button.height)/2,
            width: button.width+8,
            height: button.height
        )
//        label.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTrailing: 14, padLeading: 16)
//        button.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padTop: 16, padTrailing: 16, padBottom: 16)
//        button.setDimension(width: widthAnchor, wMult: 0.28)
    }


    func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
    
    // MARK: - Selectors
      @objc private func didTapButton() {
          delegate?.newsHeaderViewDidTapAddButton(self)
      }
}
