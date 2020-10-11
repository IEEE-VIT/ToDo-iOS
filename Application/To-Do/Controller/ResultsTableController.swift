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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmptyState()
    }
    
    fileprivate func setupEmptyState() {
        
        let image = UIImage(systemName: "magnifyingglass")!
        let heading = "No tasks found :("
        let subheading = """
        The task you search is not found.
        Create new one!
        """
        
        let emptyView = EmptyState(image: image, heading: heading, subheading: subheading)
        self.tableView.backgroundView = emptyView
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    
    
    //MARK: UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       if todoList.count == 0 {
            self.tableView.backgroundView?.isHidden = false
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView?.isHidden = true
            self.tableView.separatorStyle = .singleLine
        }
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
