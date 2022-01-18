//
//  OfferDetailsViewController.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine
import UIKit

class OfferDetailsViewController: UIViewController {
    
    private let viewModel: OfferDetailsViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Subviews
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 5.0
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bedroomsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roomsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let areaLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let professionalLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let propertyTypeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
        
        self.view.backgroundColor = .white
        
        self.bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    // MARK: - Binding
    
    func bindToViewModel() {
        self.viewModel.dataSourceDidChange.sink { void in
            self.fillUI()
            self.installSubviews()
            self.setViewsLayout()
        }
        .store(in: &self.subscriptions)
        
        self.viewModel.$isLoading
            .removeDuplicates()
            .sink { [weak self] loading in
                self?.setViewLoadingState(loading)
            }
            .store(in: &self.subscriptions)
        
        self.viewModel.$imageData.sink { data in
            guard let data = data else {
                return
            }
            
            self.imageView.image = UIImage(data: data)
        }
        .store(in: &self.subscriptions)
    }
    
    // MARK: - View content
    
    private func setViewsLayout() {
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    private func installSubviews() {
        
        self.view.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "placeholder")
        
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.activityIndicator)
    }
    
    private func fillStackView() {
        
        if let _ = self.viewModel.roomsText {
            self.stackView.addArrangedSubview(self.roomsLabel)
        }
        if let _ = self.viewModel.bedroomsText {
            self.stackView.addArrangedSubview(self.bedroomsLabel)
        }
        self.stackView.addArrangedSubview(self.cityLabel)
        self.stackView.addArrangedSubview(self.areaLabel)
        self.stackView.addArrangedSubview(self.priceLabel)
        self.stackView.addArrangedSubview(self.professionalLabel)
        self.stackView.addArrangedSubview(self.propertyTypeLabel)
    }
    
    private func fillUI() {
        
        self.roomsLabel.text = self.viewModel.roomsText
        self.roomsLabel.isHidden = self.viewModel.roomsText == nil
        self.bedroomsLabel.text = self.viewModel.bedroomsText
        self.bedroomsLabel.isHidden = self.viewModel.bedroomsText == nil
        self.cityLabel.text = self.viewModel.cityText
        self.areaLabel.text = self.viewModel.areaText
        self.priceLabel.text = self.viewModel.priceText
        self.professionalLabel.text = self.viewModel.professionalText
        self.propertyTypeLabel.text = self.viewModel.propertyTypeText
    }
    
    private func emptyStackView() {
        self.stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
        }
        [self.cityLabel, self.areaLabel, self.priceLabel, self.professionalLabel, self.propertyTypeLabel, self.roomsLabel, self.bedroomsLabel].forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setViewLoadingState(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
            self.emptyStackView()
        } else {
            self.activityIndicator.stopAnimating()
            self.fillStackView()
        }
    }
}
