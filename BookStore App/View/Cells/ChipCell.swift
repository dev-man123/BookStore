//
//  ChipCell.swift
//  BookStore App
//
//  Created by Amit Kumar on 16/03/26.
//

import UIKit

final class ChipCell: UICollectionViewCell {
    static let identifier: String = "ChipCell"
    private let label: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14,weight: .regular)
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension ChipCell {
    func setupUI() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
           label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 16
    }
}

extension ChipCell {
    func configure(text: String,isSelected: Bool) {
        label.text = text
        contentView.backgroundColor = isSelected ? .systemBlue : .systemGray6
        label.textColor = isSelected ? .white : .black
    }
}
