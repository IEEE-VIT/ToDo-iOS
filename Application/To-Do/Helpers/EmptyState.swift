//
//  EmptyState.swift
//  To-Do
//
//  Created by Bayu Kurniawan on 10/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class EmptyState: UIView {
    
    /// Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var subheadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        
        label.numberOfLines = 2
        
        return label
    }()
    
    init(image: UIImage, heading: String, subheading: String) {
        super.init(frame: .zero)
        
        self.imageView.image = image
        self.headingLabel.text = heading
        self.subheadingLabel.text = subheading
        
        let stackViews = UIStackView(arrangedSubviews: [imageView, headingLabel, subheadingLabel])
        stackViews.axis = .vertical
        stackViews.spacing = 10.0
        
        addSubview(stackViews)
        stackViews.translatesAutoresizingMaskIntoConstraints = false
        stackViews.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.30).isActive = true
        stackViews.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        stackViews.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackViews.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
