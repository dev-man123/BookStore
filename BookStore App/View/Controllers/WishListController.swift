//
//  WishListController.swift
//  BookStore App
//
//  Created by Amit Kumar on 23/03/26.
//

import UIKit

final class WishlistViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wishlist"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCell.self,forCellWithReuseIdentifier: BookCell.identifier)
        cv.backgroundColor = .clear
        layout.minimumLineSpacing = 16
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    private var wishlistBooks: [Book] = []
    private let viewModel = BookViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        loadWishList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWishList()
    }
    
}

private extension WishlistViewController {
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadWishList() {
        let wishListIds = WishListManager.wishlistManager.getWishList()
        let allBooks = viewModel.books
        wishlistBooks = allBooks.filter { wishListIds.contains($0.id) }
        collectionView.reloadData()
    }
    
}

extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCell.identifier,
            for: indexPath
        ) as? BookCell else {
            return UICollectionViewCell()
        }
        
        guard wishlistBooks.indices.contains(indexPath.item) else {return UICollectionViewCell()}
        
        cell.configure(book: wishlistBooks[indexPath.item])
        cell.onWishListToggle = {[weak self] in
            guard let self = self else { return }
            self.loadWishList()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width - 32, height: 250)
    }
}
