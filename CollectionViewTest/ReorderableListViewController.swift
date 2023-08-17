//
//  ReorderableListViewController.swift
//  CollectionViewTest
//
//  Created by SeoYeon Hong on 2023/08/13.
//

import UIKit

struct Book: Hashable, Codable {
    let title: String?
    let author: String?
    init(title: String? = nil, author: String? = nil) {
        self.title = title
        self.author = author
    }
}

class ReorderableListViewController: UIViewController {

    enum Section: Hashable, CaseIterable {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Book>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Book> { (cell, indexPath, book) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(book.title ?? "")\n\(book.author ?? "")"
            cell.contentConfiguration = content
            cell.accessories = [.reorder(displayed: .always), .delete(displayed: .whenEditing)]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView) { (collectionView, indexPath, book: Book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: book)
            return cell
        }
        
        dataSource.reorderingHandlers.canReorderItem = { book in return true }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.main])
        
        let books = [Book(title: "프로젝트 헤일메리", author: "앤디 위어"),
                     Book(title: "멋진 신세계", author: "올더스 헉슬리"),
                     Book(title: "아몬드", author: "장원평"),
                     Book(title: "스위트 히어애프터", author: "요시모토 바나나"),
                     Book(title: "일의 기쁨과 슬픔", author: "장류진")]
        snapshot.appendItems(books, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
