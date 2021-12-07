//
//  NewsStoryTableViewCell.swift
//  News
//
//  Created by Boris Bolshakov on 7.12.21.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseId = "NewsStoryTableViewCell"
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: Source?
        let headline: String?
        let dateString: String
        let imageURL: URL?
        
        init(model: Article) {
            self.source = model.source
            self.headline = model.title
            self.dateString = model.publishedAt ?? "no date"
            self.imageURL = URL(string: model.urlToImage ?? "")
        }
    }
    
    // MARK: - Views
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 3
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sourceLabel, headlineLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 3
        return stack
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
        //        configureUI()
        //        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.4
        storyImageView.frame = CGRect(
            x: contentView.width-imageSize-10,
            y: 3,
            width: imageSize,
            height: imageSize
        )
        
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 10
        dateLabel.frame = CGRect (
            x: separatorInset.left,
            y: contentView.height-40,
            width: availableWidth,
            height: 40
        )
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availableWidth,
            height: sourceLabel.height
        )
        
        headlineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.bottom + 5,
            width: availableWidth ,
            height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        imageView?.image = nil
    }
    
    
    func configure(with viewModel: ViewModel) {
        sourceLabel.text = viewModel.source?.name ?? "unknown"
        headlineLabel.text = viewModel.headline
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
//        storyImageView.setImage(with: viewModel.imageURL)
    }
}
