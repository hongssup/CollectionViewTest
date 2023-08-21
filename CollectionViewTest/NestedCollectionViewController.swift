//
//  NestedCollectionViewController.swift
//  CollectionViewTest
//
//  Created by hongssup on 2023/08/21.
//

import UIKit

// horizontal scroll 로 설정된 collection view 의 cell 내에 vertical scroll 방식의 collection view 를 넣은 nested 구조.
class NestedCollectionViewController: UIViewController {

    enum Section: Hashable, CaseIterable {
        case main, second, third
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
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
        let cellRegistration = UICollectionView.CellRegistration<NestedCollectionViewCell, Int> { (cell, indexPath, num) in
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, num: Int) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: num)
            return cell
        }
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(sections)
        
        snapshot.appendItems([1], toSection: .main)
        snapshot.appendItems([2], toSection: .second)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

class NestedCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    
    var nestedCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Page, Int>! = nil
    var items = Array(0...20)

    enum Page {
        case main
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupNestedCollectionView()
        configureNestedDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createNestedLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600))

            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    private func setupNestedCollectionView() {
        nestedCollectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createNestedLayout())
        nestedCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        contentView.addSubview(nestedCollectionView)
        nestedCollectionView.showsVerticalScrollIndicator = true
        nestedCollectionView.backgroundColor = .red
        nestedCollectionView.delegate = self
    }

    private func configureNestedDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, num) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(num)"
            cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource<Page, Int>(collectionView: nestedCollectionView, cellProvider: { (collectionView, indexPath, num) -> UICollectionViewCell? in
            var cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: num)
            return cell
        })

        var snapshot = NSDiffableDataSourceSnapshot<Page, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("~~~~~: 위아래 \(scrollView.contentOffset.y)")
    }
}

