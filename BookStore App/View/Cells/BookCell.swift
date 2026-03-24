//
//  BookCell.swift
//  BookStore App
//
//  Created by Amit Kumar on 17/03/26.
//

import UIKit

final class BookCell: UICollectionViewCell {

    static let identifier = "BookCell"
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let authorLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let descLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let readMoreButton : UIButton = {
        let button = UIButton()
        button.setTitle("Read Less", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let wishlistButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    private var bookId: String?
    private var expanded = false
    var onExpandToggle: (() -> Void)?
    var onWishListToggle: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension BookCell {
    func setupUI() {
        contentView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 16
        
        let leftStack = UIStackView(arrangedSubviews: [
            imageView,
            tagsStack
        ])
        leftStack.axis = .vertical
        leftStack.spacing = 6
        leftStack.alignment = .center
        leftStack.distribution = .fill
        /*leftStack.widthAnchor.constraint(equalToConstant: 90).isActive = true*/
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        /*tagsStack.widthAnchor.constraint(equalToConstant: 86).isActive = true*/

        let descStack = UIStackView(arrangedSubviews: [
            descLabel,
            readMoreButton
        ])
        descStack.axis = .vertical
        descStack.spacing = 4
        
        descLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        descLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        readMoreButton.setContentHuggingPriority(.defaultHigh, for: .vertical)

        
        let spacer = UIView()
        let bottomRow = UIStackView(arrangedSubviews: [spacer, wishlistButton])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        wishlistButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        wishlistButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let rightStack = UIStackView(arrangedSubviews: [
            titleLabel,
            authorLabel,
            ratingLabel,
            descStack,
            bottomRow
        ])
        rightStack.axis = .vertical
        rightStack.spacing = 6
        rightStack.alignment = .fill
        rightStack.setContentHuggingPriority(.required, for: .vertical)
        rightStack.setContentCompressionResistancePriority(.required, for: .vertical)

        let rootStack = UIStackView(arrangedSubviews: [
            leftStack,
            rightStack
        ])
        rootStack.axis = .horizontal
        rootStack.spacing = 12
        rootStack.alignment = .top

        contentView.addSubview(rootStack)
        rootStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

        ])

        readMoreButton.addTarget(self, action: #selector(toggleDesc), for: .touchUpInside)
        wishlistButton.addTarget(self, action: #selector(toggleWishlist), for: .touchUpInside)
    }
    
    func makeChip(tag: Tag) -> UILabel {
        let label = UILabel()
        label.text = tag.rawValue
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.backgroundColor = .systemGray.withAlphaComponent(0.3)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
        
    }
    
    @objc func toggleDesc() {
        expanded.toggle()
        descLabel.numberOfLines = expanded ? 0 : 3
        readMoreButton.setTitle(expanded ? "Read Less": "Read More", for: .normal)
        onExpandToggle?()
    }
    
    @objc  func toggleWishlist() {
        guard let id = bookId else { return }
        let isWishlisted = WishListManager.wishlistManager.contains(id: id)
        if isWishlisted {
            WishListManager.wishlistManager.removeFromWishList(id: id)
        } else {
            WishListManager.wishlistManager.addToWishList(id: id)
        }
        wishlistButton.setImage(
            UIImage(systemName: !isWishlisted ? "heart.fill" : "heart"),
            for: .normal
        )
        onWishListToggle?()
    }
}

extension BookCell {
    func configure(book: Book) {
        bookId = book.id
        titleLabel.text = book.title
        authorLabel.text = book.author
        ratingLabel.text = "⭐️ \(book.rating)"
        descLabel.text = book.description
        
        let allTag = book.tag
        tagsStack.arrangedSubviews.forEach { $0.removeFromSuperview()}
        let displayTag = Array(allTag.prefix(2))
        displayTag.forEach({ tag in tagsStack.addArrangedSubview(makeChip(tag: tag))})
        
        
        ImageLoader.imageLoader.load(urlString: book.imageUrl) { [weak self] image in
            guard let self = self, self.bookId == book.id else { return }
            self.imageView.image = image
        }
            
        let isWishlisted = WishListManager.wishlistManager.contains(id: book.id)
        wishlistButton.setImage(
            UIImage(systemName: isWishlisted ? "heart.fill" : "heart"),
            for: .normal
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        expanded = false
        descLabel.numberOfLines = 3
        readMoreButton.setTitle("Read More", for: .normal)
        tagsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width,height: 0)
        let size = contentView.systemLayoutSizeFitting(targetSize,
                  withHorizontalFittingPriority: .required,
                  verticalFittingPriority: .fittingSizeLevel)
        let newAttributes = layoutAttributes
        newAttributes.frame.size = size
        return newAttributes
    }
    
}
