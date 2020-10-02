//
//  TodoViewController.swift
//  To-Do
//
//  Created by Aaryan Kothari on 29/09/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    /// `Tableview` to display list of tasks
    @IBOutlet weak var todoTableView: UITableView!
    
    /// `SearchController` to include search bar
    var searchController: UISearchController!
    
    /// `ResultsController` to display results of specific search
    var resultsTableController: ResultsTableController!
       
    /// `DataSource` for todoTableview
    var todoList : [Task] = []
    var lastIndexTapped : Int = 0
    
    /// `Reuse Identifier` for TodoTableViewCell
    let todoCellReuseIdentifier = "todocell"
    
    /// `Segue Identifier` to go to TaskDetailsViewController
    let taskDetailsIdentifier = "gototask"
    
    //MARK: View lifecycle methods
    override func viewDidLoad() {
        setupSearchController()
        super.viewDidLoad()
        // TODO: initial setup if any
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.searchController = searchController
    }
    
    //MARK: IBActions
    /// perform segue to `TaskDetailsViewController` if `+` tapped
    @IBAction func addTasksTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: taskDetailsIdentifier, sender: Any?.self)
    }
    
    ///Star task
    /// function called when `Star Task` tapped
    func starTask(at index : Int){
        //TODO: write star login
    }
    
    ///Delete task
    /// function called when `Delete Task` tapped
    func deleteTask(at index : Int){
        todoList.remove(at: index) /// removes task at index
        tableView.reloadData() /// Reload tableview with remaining data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskDetailVC = segue.destination as? TaskDetailsViewController{
            taskDetailVC.delegate = self
            taskDetailVC.task = sender as? Task
        }
    }
    
    /// search controller setup
    fileprivate func setupSearchController() {
        resultsTableController =
            self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableController") as? ResultsTableController
        resultsTableController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
    }
    
    //MARK:  ------ Tableview Datasource methods ------
    // Reference: https://developer.apple.com/documentation/uikit/uitableviewdatasource
    
    /// function to determine `Number of rows` in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    /// function  to determine `tableview cell` at a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: todoCellReuseIdentifier)
        let task = todoList[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.dueDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexTapped = indexPath.row
        let task = todoList[indexPath.row]
        performSegue(withIdentifier: taskDetailsIdentifier, sender: task)
    }
    
    
    //MARK:  ----- Tableview Delagate methods  ------
    // Reference: https://developer.apple.com/documentation/uikit/uitableviewdelegate
    
    /// `UISwipeActionsConfiguration` for delete and star  buttons
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            self.deleteTask(at: indexPath.row)
        }
        let star = UIContextualAction(style: .normal, title: "Star") {  (_, _, _) in
            self.starTask(at: indexPath.row)
        }
        star.backgroundColor = .orange
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete,star])

        return swipeActions
    }
    
    /// function to determine `View for Footer` in tableview.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() /// Returns an empty view.
    }
}

//MARK: - TaskDelegate
/// protocol for `saving` or `updating` `Tasks`
extension TodoViewController : TaskDelegate{
    func didTapSave(task: Task) {
        todoList.append(task) /// add task
        tableView.reloadData() /// Reload tableview with new data
    }
    
    func didTapUpdate(task: Task) {
        todoList[lastIndexTapped] = task /// edit task
        tableView.reloadData() /// Reload tableview with new data
    }
}

// MARK: - Search Bar Delegate

extension TodoViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        /// perform search only when there is some text
        if var text: String = searchController.searchBar.text, text.count > 0 {
            var results: [Task] = []
            text = text.lowercased()
            todoList.forEach { (task) in
                if task.title.lowercased().contains(text) || task.subTasks.lowercased().contains(text) {
                    results.append(task)
                }
            }
            if let resultsController = searchController.searchResultsController as? ResultsTableController {
                resultsController.todoList = results
                resultsController.tableView.reloadData()
            }
        } else {
            /// default case when text not available or text length is zero
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}
