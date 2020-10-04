//
//  Priority.swift
//  To-Do
//
//  Created by Amirthy Tejeshwar on 03/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

enum Priority: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    
    func getPriorityIndex() -> Int {
        return Priority.allCases.firstIndex(of: self)!
    }
    
    func getImageForPriority() -> UIImage? {
        switch self {
        case .low:
            return UIImage(systemName: "exclamationmark")
        case .medium:
            return UIImage(systemName: "exclamationmark.square")
        case .high:
            return UIImage(systemName: "exclamationmark.square.fill")
        }
    }
    
    static func getPriorityByIndex(index: Int) -> Priority {
        return index < Priority.allCases.count ? Priority.allCases[index] : .low
    }
}
