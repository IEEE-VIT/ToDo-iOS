//
//  ImageAttachmentCell.swift
//  To-Do
//
//  Created by Lucas Araujo on 06/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ImageAttachmentCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
