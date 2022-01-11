//
//  OfferDetailsViewController.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import UIKit

class OfferDetailsViewController: UIViewController {
    
    private let viewModel: OfferDetailsViewModel
    
    // MARK: - Initializers
    
    init(with viewModel: OfferDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindToViewModel()
    }
    
    // MARK: - Binding
    
    func bindToViewModel() {
        
    }
}
