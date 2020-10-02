//
//  ResultsTableController.swift
//  To-Do
//
//  Created by Amirthy Tejeshwar on 01/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ResultsTableController: UITableViewController {
    let todoCellReuseIdentifier = "todocell"
    
    var todoList = [Task]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: todoCellReuseIdentifier)
        let task = todoList[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.dueDate
        return cell
    }
}
