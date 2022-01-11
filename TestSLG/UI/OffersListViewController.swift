//
//  OffersListViewController.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine
import UIKit

protocol OffersListViewControllerDelegate: AnyObject {
    func didSelectOffer(_: Offer)
}

class OffersListViewController: UIViewController {
    
    private let viewModel: OffersListViewModel
    weak var delegate: OffersListViewControllerDelegate?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(with viewModel: OffersListViewModel, delegate: OffersListViewControllerDelegate) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Views
    
    private lazy var offersCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
//        collectionView.register(OfferCell.self, forCellWithReuseIdentifier: "OfferCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
//        collectionView.refreshControl = UIRefreshControl()
//        collectionView.refreshControl?.addTarget(self, action:
//                                                    #selector(handleRefreshControl),
//                                                 for: .valueChanged)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindToViewModel()
        
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Binding
    
    private func bindToViewModel() {
        
        self.viewModel.dataSourceDidChange.sink { [weak self] _ in
            self?.offersCollectionView.reloadData()
        }.store(in: &self.subscriptions)
    }
}
