//
//  HomeViewController.swift
//  BookStore App
//
//  Created by Amit Kumar on 17/03/26.
//

import UIKit

final class HomeViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bookstore"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search books..."
        return sb
    }()
    
    private var chipCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ChipCell.self,forCellWithReuseIdentifier: ChipCell.identifier)
        cv.backgroundColor = .clear
        cv.alwaysBounceHorizontal = true
        layout.minimumInteritemSpacing = 8
        return cv
    }()
    
    private var bookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCell.self,forCellWithReuseIdentifier: BookCell.identifier)
        cv.backgroundColor = .clear
        layout.minimumLineSpacing = 16
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    private let chips: [String] = ["All","bestSeller","trending"]
    private let viewModel = BookViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTopBar()
        setupConstraints()
    }
}

private extension HomeViewController {
    func setupTopBar() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    func setupConstraints() {
        chipCollectionView.delegate = self
        chipCollectionView.dataSource = self
        
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        
        view.addSubview(chipCollectionView)
        view.addSubview(bookCollectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        chipCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bookCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            chipCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            chipCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chipCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chipCollectionView.heightAnchor.constraint(equalToConstant: 50),

            bookCollectionView.topAnchor.constraint(equalTo: chipCollectionView.bottomAnchor, constant: 8),
            bookCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
}

extension HomeViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,BookViewModelDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if collectionView == chipCollectionView {
            return chips.count
        }
        else {
            return viewModel.filteredBooks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chipCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCell.identifier, for: indexPath) as? ChipCell else {
                return UICollectionViewCell()
            }
            
            guard chips.indices.contains(indexPath.item) else {
                return UICollectionViewCell()
            }
            let chip = chips[indexPath.item]
            let isSelected: Bool
            
            switch chip {
            case "trending":
                isSelected = viewModel.isSelectedTag(tag: .trending)
            case "bestSeller":
                isSelected =  viewModel.isSelectedTag(tag: .bestSeller)
            case "All":
                isSelected = viewModel.isAllSelected()
            default:
                isSelected = false
            }
            cell.configure(text: chip, isSelected: isSelected)
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
                return UICollectionViewCell()
            }
            
            guard viewModel.filteredBooks.indices.contains(indexPath.item) else {
                return UICollectionViewCell()
            }
            cell.onExpandToggle = {[weak self] in
                guard let self = self else {return}
                UIView.animate(withDuration: 0.4) {
                    self.bookCollectionView.performBatchUpdates(nil)
                }
            }
            cell.configure(book: viewModel.filteredBooks[indexPath.item])
            return cell
        }
    }
    
    func didUpdateBooks() {
        bookCollectionView.reloadData()
        chipCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == chipCollectionView else {return}
        guard chips.indices.contains(indexPath.item) else {return}
        
        let chip = chips[indexPath.item]
        switch chip {
        case "bestSeller":
            viewModel.toggleTag(tag: .bestSeller)
        case "trending":
            viewModel.toggleTag(tag: .trending)
        default:
            viewModel.clearFilters()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == chipCollectionView {
            return CGSize(width: 120, height: 80)
        }
        else {
            return CGSize(width: collectionView.bounds.width - 32, height: 280)
        }
    }
}
