//
//  AppCoordinator.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import UIKit

class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.presentOffersViewController()
    }
    
}

extension AppCoordinator: OffersListViewControllerDelegate {

    private func presentOffersViewController() {
        
        let client = APIClient()
        
        let offersRemoteDataSourceAdapter = OffersRemoteDataSourceAdapter(client: client)
        let offersRepository = OffersRepositoryAdapter(remoteDataSource: offersRemoteDataSourceAdapter, localDataSource: OffersLocalDataSourceAdapter())
        let offersGetter = GetOffers(offersRepository: offersRepository)
        
        let imagesRemoteDataSourceAdapter = ImagesRemoteDataSourceAdapter(client: client)
        let imagesRepositoryAdapter = ImagesRepositoryAdapter(withRemoteDataSource: imagesRemoteDataSourceAdapter)
        let imageGetter = GetImage(imageRepository: imagesRepositoryAdapter)
        
        let viewModel = OffersListViewModel(with: offersGetter, imageGetter: imageGetter)
        
        let vc = OffersListViewController(with: viewModel, delegate: self)
        vc.delegate = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func didSelectOffer(_ offer: Offer) {
        
        self.presentOfferDetails(offer)
    }
}

extension AppCoordinator {

    private func presentOfferDetails(_ offer: Offer) {

        let client = APIClient()
        
        let offersRemoteDataSourceAdapter = OffersRemoteDataSourceAdapter(client: client)
        let offersRepository = OffersRepositoryAdapter(remoteDataSource: offersRemoteDataSourceAdapter, localDataSource: OffersLocalDataSourceAdapter())
        let offerDetailsGetter = GetOfferDetails(offersRepository: offersRepository)
        
        let imagesRemoteDataSourceAdapter = ImagesRemoteDataSourceAdapter(client: client)
        let imagesRepositoryAdapter = ImagesRepositoryAdapter(withRemoteDataSource: imagesRemoteDataSourceAdapter)
        let imageGetter = GetImage(imageRepository: imagesRepositoryAdapter)
        
        let viewModel = OfferDetailsViewModel(with: offer.id, offerDetailsGetter: offerDetailsGetter, imageGetter: imageGetter)
        
        let vc = OfferDetailsViewController(with: viewModel)

        self.navigationController.pushViewController(vc, animated: true)
    }
}
