//
//  CameraHelper.swift
//  To-Do
//
//  Created by Lucas Araujo on 06/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class CameraHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let cameraController = UIImagePickerController()
    private var didFinish: ((UIImage?) -> Void)?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            didFinish?(pickedImage)
        }
        didFinish = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didFinish?(nil)
        didFinish = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openCamera(in controller: UIViewController, completion: @escaping (UIImage?) -> Void) {
        didFinish = completion
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraController.sourceType = .camera
        } else {
            cameraController.sourceType = .photoLibrary
        }
        cameraController.delegate = self
        cameraController.allowsEditing = true
        controller.present(cameraController, animated: true, completion: nil)
    }
    
}
