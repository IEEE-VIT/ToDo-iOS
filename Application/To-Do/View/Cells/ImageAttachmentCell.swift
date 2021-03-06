//
//  ImageAttachmentCell.swift
//  To-Do
//
//  Created by Lucas Araujo on 06/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ImageAttachmentCell: UICollectionViewCell {
//    @IBOutlet private weak var imageView: UIImageView!
    static let identifier: String = "ImageAttachmentCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
