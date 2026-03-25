//
//  AddViewController.swift
//  BookStore App
//
//  Created by Amit Kumar on 18/03/26.
//

import UIKit

final class AddViewController: UIViewController {
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleField = CustomTextField(placeholder: "Book Name")
    private let authorField = CustomTextField(placeholder: "Author Name")
    private let priceField = CustomTextField(placeholder: "Price",keyboardType: .numberPad)
    private let imageUrlField = CustomTextField(placeholder: "ImageUrl")
    private let descriptionField = CustomTextField(placeholder: "Description")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
}

private extension AddViewController {
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    func setupUI() {
        view.addSubview(stackView)
        [titleField, authorField, priceField, imageUrlField, descriptionField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func handleCancel() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func handleSave() {
        print("Save button is clicked")
        guard let title = titleField.text, !title.isEmpty,
              let author = authorField.text, !author.isEmpty,
              let priceString = priceField.text, let price = Int(priceString) else { return }
        
        let newBook = Book(id: UUID().uuidString, title: title, author: author, description: descriptionField.text ?? "", rating: 4.5, price: price, tag: [.trending], imageUrl: imageUrlField.text ?? "",isExpanded: false)
        
        saveBookToPersistence(book: newBook)
    }
    
    func saveBookToPersistence(book: Book) {
        var customBooks = getCustomBooks()
        customBooks.append(book)
        
        if let data = try? JSONEncoder().encode(customBooks) {
            UserDefaults.standard.set(data,forKey: "custom_books")
            let alert = UIAlertController(title: "Success!", message: "Your book has been added to the library.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.titleField.text = ""
                self.authorField.text = ""
                self.priceField.text = ""
                self.imageUrlField.text = ""
                self.descriptionField.text = ""
                self.tabBarController?.selectedIndex = 0
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    func getCustomBooks() -> [Book] {
        guard let data = UserDefaults.standard.data(forKey: "custom_books"),
              let books = try? JSONDecoder().decode([Book].self, from: data) else { return [] }
        return books
    }
}

final class CustomTextField: UITextField {
    init(placeholder: String,keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
