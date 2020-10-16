//
//  TodoDataSouce.swift
//  To-Do
//
//  Created by Alexis Orellano on 10/16/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TodoDataSource: NSObject, UITableViewDataSource {
    static var todoList = [Task]()
    /// function to determine `Number of rows` in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        if TodoDataSource.todoList.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
            
        }
        
        return TodoDataSource.todoList.count
    }
    
    /// function  to determine `tableview cell` at a given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.taskCell, for: indexPath) as! TaskCell
        let task = TodoDataSource.todoList[indexPath.row]
        cell.title.text = task.title
        cell.subtitle.text = task.dueDate
        cell.starImage.isHidden = TodoDataSource.todoList[indexPath.row].isFavourite ? false : true
        return cell
    }
}
