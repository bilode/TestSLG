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
    
    private struct Const {
        static let visibleCellsRegular = (col: 3.0, lines: 2.7)
        static let visibleCellsNonRegular = (col: 2.0, lines: 2.2)
    }
    
    private let viewModel: OffersListViewModel
    weak var delegate: OffersListViewControllerDelegate?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Subviews
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(OfferCell.self, forCellWithReuseIdentifier: "OfferCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
                                                    #selector(handleRefreshControl),
                                                 for: .valueChanged)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initializers
    
    init(with viewModel: OffersListViewModel, delegate: OffersListViewControllerDelegate) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.bindToViewModel()
        self.setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor),
        ])
    }
    
    // MARK: - Binding
    
    private func bindToViewModel() {
        
        self.viewModel.dataSourceDidChange.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &self.subscriptions)
        
        
        self.viewModel.$isLoading.sink { isLoading in
            
            self.setUIFrozenState(isLoading)
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
        .store(in: &self.subscriptions)
        
        
        self.viewModel.$offerToDetail.sink { [weak self] offer in
            if let offer = offer {
                self?.delegate?.didSelectOffer(offer)
            }
        }
        .store(in: &self.subscriptions)
    }
    
    // MARK: - Actions
    
    @objc func handleRefreshControl() {
        
        self.viewModel.refreshControlDidTrigger()
    }
    
    // MARK: - Misc
    
    private func setUIFrozenState(_ frozen: Bool) {
        self.collectionView.isUserInteractionEnabled = !frozen
    }
}


// MARK: - UICollectionViewDelegateFlowLayout / UICollectionViewDataSource

extension OffersListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellViewModel = viewModel.viewModelForCell(atIndex: indexPath.row)
        
        if let offerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCell", for: indexPath) as? OfferCell {
            
            offerCell.viewModel = cellViewModel
            
            return offerCell
        }
        
        return OfferCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let visibleColumns = self.traitCollection.horizontalSizeClass == .regular ?
        Const.visibleCellsRegular.col :
        Const.visibleCellsNonRegular.col
        
        let width = (collectionView.bounds.width - (10 * (floor(visibleColumns) + 1))) / floor(visibleColumns)
        
        let visibleLines = self.traitCollection.horizontalSizeClass == .regular ?
        Const.visibleCellsRegular.lines :
        Const.visibleCellsNonRegular.lines
        
        let height = (self.collectionView.bounds.height - (10 * (floor(visibleLines) + 1))) / visibleLines
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectItem(atIndex: indexPath.row)
    }
}
