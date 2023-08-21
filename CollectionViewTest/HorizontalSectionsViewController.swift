//
//  HorizontalSectionsViewController.swift
//  CollectionViewTest
//
//  Created by hongssup on 2023/08/21.
//

import UIKit

class HorizontalSectionsViewController: UIViewController {

    enum Section: Hashable, CaseIterable {
        case main, second, third
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Book>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Book> { (cell, indexPath, book) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(book.title ?? "")\n\(book.author ?? "")"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView) { (collectionView, indexPath, book: Book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: book)
            return cell
        }
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections(sections)
        
        let books = [Book(title: "프로젝트 헤일메리\n\n", author: "앤디 위어\n\n"),
                     Book(title: "멋진 신세계\n\n", author: "올더스 헉슬리\n\n"),
                     Book(title: "아몬드\n\n", author: "장원평\n\n"),
                     Book(title: "스위트 히어애프터\n\n", author: "요시모토 바나나\n\n"),
                     Book(title: "일의 기쁨과 슬픔\n\n", author: "장류진\n\n"),
                     Book(title: "1984\n\n", author: "조지 오웰\n\n")]
        snapshot.appendItems(books, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

