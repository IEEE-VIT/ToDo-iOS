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
    
    
    //MARK: UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.todoList.count == 0 ? self.showEmptyState() : self.hideEmptyState()
        
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: todoCellReuseIdentifier)
        let task = todoList[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.dueDate
        return cell
    }
    
    //MARK : Fetch Result State Handling
    
    private func showEmptyState() {
        
        let emptyResultLabel = UILabel()
        emptyResultLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyResultLabel.text = "No Search results!"
        emptyResultLabel.textColor = .black
        emptyResultLabel.textAlignment = .center
        self.tableView.backgroundView = emptyResultLabel
    }
    
    private func hideEmptyState() {
        self.tableView.backgroundView = nil
    }
}
