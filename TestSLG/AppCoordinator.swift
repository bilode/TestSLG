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
        let vc = OffersListViewController(with: OffersListViewModel(with: OffersService(remoteStorage: APIClient())),
                                          delegate: self)
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func didSelectOffer(_: Offer) {
        
    }
}

//extension AppCoordinator: OfferDetailsViewControllerDelegate {
//
//    private func presentOfferDetails(withModel model: OfferDetailsViewModel) {
//
//        let vc = OfferDetailsViewController(with: model)
//        vc.delegate = self
//
//        self.navigationController.pushViewController(vc, animated: true)
//    }
//
//
//    func didTapCloseButton() {
//        self.navigationController.popViewController(animated: true)
//    }
//}
