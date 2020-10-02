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
    
    func getSortClosure() -> ((Task, Task) -> Bool) {
        var sortClosure: (Task, Task) -> Bool
        switch self {
        case .sortByNameAsc:
            sortClosure = { (task1, task2) in
                if let firstTitle = task1.title, let secondTitle = task2.title {
                    return firstTitle < secondTitle
                }
                return false
            }
        case .sortByNameDesc:
            sortClosure = { (task1, task2) in
                if let firstTitle = task1.title, let secondTitle = task2.title {
                    return firstTitle > secondTitle
                }
                return false
            }
        case .sortByDateAsc:
            sortClosure = { (task1, task2) in
                return task1.dueDateTimeStamp < task2.dueDateTimeStamp
            }
        case .sortByDateDesc:
            sortClosure = { (task1, task2) in
                return task1.dueDateTimeStamp > task2.dueDateTimeStamp
            }
        }
        return sortClosure
    }
}
