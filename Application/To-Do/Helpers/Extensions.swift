//
//  Extensions.swift
//  To-Do
//
//  Created by ELezov on 15.10.2020.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

extension String {
    
    static let empty = ""
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
