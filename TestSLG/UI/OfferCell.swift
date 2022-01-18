//
//  OfferCell.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import UIKit
import Combine


class OfferCell: UICollectionViewCell {

    var viewModel: OfferCellViewModel? {
        didSet {
            self.setup(from: self.viewModel)
        }
    }
    
    var subscriptions: Set<AnyCancellable> = []
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Subviews
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
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
    
    let roomsLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .natural
        
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let areaLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .natural
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .natural
        
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Layout
    
    private func setSubviewsLayout() {
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    
    private func bindTo(_ viewModel: OfferCellViewModel) {
        
        viewModel.$imageData.sink { [weak self] data in
            
            guard let data = data else {
                return
            }
            
            self?.imageView.image = UIImage(data: data)
        }
        .store(in: &self.subscriptions)
    }
    
    // MARK: - Public
    
    // Might be necessary to also call it from collectionViewDelegate "didEndDisplaying cell"
    private func cancelDownload() {
        self.subscriptions.forEach { $0.cancel() }
    }
    
    // MARK: - Private
    
    private func setup(from viewModel: OfferCellViewModel?) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.bindTo(viewModel)
        
        self.setSubviewsContent(from: viewModel)
        self.setSubviewsLayout()
        
        viewModel.viewDidFinishSetingUp()
    }
    
    private func setSubviewsContent(from viewModel: OfferCellViewModel) {
        
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "placeholder")
        
        self.addSubview(self.stackView)
        
        if let roomsText = viewModel.roomsText {
            self.stackView.addArrangedSubview(self.roomsLabel)
            self.roomsLabel.text = roomsText
            self.roomsLabel.isHidden = false
        }
        
        self.stackView.addArrangedSubview(self.areaLabel)
        self.areaLabel.text = viewModel.areaText
        
        self.stackView.addArrangedSubview(self.priceLabel)
        self.priceLabel.text = viewModel.priceText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // This should prevent reused cells from stacking up multiple datatasks from unrelated offers
        self.cancelDownload()
        
        // We can't optimize that part by inspecting the viewModel as it isn't assigned here yet
        self.roomsLabel.isHidden = true
    }
}

