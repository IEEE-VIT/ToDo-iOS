//
//  ResultsTableController.swift
//  To-Do
//
//  Created by Amirthy Tejeshwar on 01/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ResultsTableController: UITableViewController {
    var todoList = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmptyState()
    }
    
    fileprivate func setupEmptyState() {
        let emptyView = EmptyState(.emptySearch)
        self.tableView.backgroundView = emptyView
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    
    
    //MARK: UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if todoList.isEmpty {
            self.tableView.backgroundView?.isHidden = false
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView?.isHidden = true
            self.tableView.separatorStyle = .singleLine
        }
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.Cell.taskCell)
        let task = todoList[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.dueDate
        return cell
    }
    
}
