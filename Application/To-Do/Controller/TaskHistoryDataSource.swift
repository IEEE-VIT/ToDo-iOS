//
//  TaskHistoryDataSource.swift
//  To-Do
//
//  Created by Alexis Orellano on 10/16/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TaskHistoryDataSource: NSObject, UITableViewDataSource {
    static var completedList = [Task]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskHistoryDataSource.completedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.taskCell, for: indexPath) as! TaskCell
        let task = TaskHistoryDataSource.completedList[indexPath.row]
        cell.title.text = task.title
        cell.subtitle.text = task.dueDate
        cell.starImage.isHidden = true
        return cell
    }
}
