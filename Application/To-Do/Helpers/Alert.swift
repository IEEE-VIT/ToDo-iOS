//
//  Alert.swift
//  To-Do
//
//  Created by Mikaela Caron on 10/3/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

/// Defines static functions for various alerts that can be used throughout the app
struct Alert {

    /// Creates a UIAlertController and presents it on the specific view controller
    /// - Parameters:
    ///     - vc: The UIViewController where the alert is presented
    ///     - title: The title of the UIAlertController
    ///     - message: The message of the UIAlertController
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }

    /// Run `showBasicAlert` with a specified title and message related to not having a title for the task
    /// - Parameters:
    ///     - vc: UIViewController to present this alert
    static func showNoTaskTitle(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "😧 Uh Oh", message: "Give your task a name!")
    }

    /// Run `showBasicAlert` with a specified title and message related to not having a due date for the task
    /// - Parameters:
    ///     - vc: UIViewController to present this alert
    static func showNoTaskDueDate(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "🙁 Uh Oh", message: "Due date is empty")
    }
}
