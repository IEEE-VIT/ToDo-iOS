//
//  TaskCell.swift
//  To-Do
//
//  Created by Adriana González Martínez on 10/2/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//  This is not for copying and if you want, then you have get its license agrrement

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.starImage.image = UIImage(systemName: "star.fill")
    }
}
