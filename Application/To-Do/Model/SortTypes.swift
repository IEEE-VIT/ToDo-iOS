//
//  SortTypes.swift
//  To-Do
//
//  Created by Aman Personal on 02/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

enum SortTypesAvailable: CaseIterable {
    case sortByNameAsc
    case sortByNameDesc
    case sortByDateAsc
    case sortByDateDesc
    
    func getTitleForSortType() -> String {
        var titleString = ""
        switch self {
        case .sortByNameAsc:
            titleString = "Sort By Name (A-Z)"
        case .sortByNameDesc:
            titleString = "Sort By Name (Z-A)"
        case .sortByDateAsc:
            titleString = "Sort By Date (Earliest first)"
        case .sortByDateDesc:
            titleString = "Sort By Date (Latest first)"
        }
        return titleString
    }
    
    func getSortDescriptor() -> [NSSortDescriptor] {
        switch self {
        case .sortByNameAsc:
            return [NSSortDescriptor(key: "title", ascending: true)]
        case .sortByNameDesc:
            return [NSSortDescriptor(key: "title", ascending: false)]
        case .sortByDateAsc:
            return [NSSortDescriptor(key: "dueDateTimeStamp", ascending: true)]
        case .sortByDateDesc:
            return [NSSortDescriptor(key: "dueDateTimeStamp", ascending: false)]
        }
    }
}
