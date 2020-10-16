//
//  TaskDetailsDataSource.swift
//  To-Do
//
//  Created by Alexis Orellano on 10/16/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TaskDetailsDataSource: NSObject, UICollectionViewDataSource {
    static var imagesAttached = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TaskDetailsDataSource.imagesAttached.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.photoCell, for: indexPath) as! ImageAttachmentCell
        let image = TaskDetailsDataSource.imagesAttached[indexPath.row]
        
        cell.imageView.image = image
        
        return cell
    }
}
