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
    
    /// `DataSource` for todoTableview
    var todoList : [Task] = []
    var lastIndexTapped : Int = 0
    
    /// `Reuse Identifier` for TodoTableViewCell
    let todoCellReuseIdentifier = "todocell"
    
    /// `Segue Identifier` to go to TaskDetailsViewController
    let taskDetailsIdentifier = "gototask"
    
    //MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: IBActions
    @IBAction func addTasksTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: taskDetailsIdentifier, sender: Any?.self)
    }
    
    ///Edit task
    /// function called when `Delete Task` tapped
    func editTask(){
        
    }
    
    ///Delete task
    /// function called when `Delete Task` tapped
    func deleteTask(at index : Int){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskDetailVC = segue.destination as? TaskDetailsViewController{
            taskDetailVC.delegate = self
            taskDetailVC.task = sender as? Task
        }
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
        cell.detailTextLabel?.text = "due: " + task.dueDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexTapped = indexPath.row
        let task = todoList[indexPath.row]
        performSegue(withIdentifier: taskDetailsIdentifier, sender: task)
    }
    
    
    //MARK:  ----- Tableview Delagate methods  ------
    // Reference: https://developer.apple.com/documentation/uikit/uitableviewdelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            self.deleteTask(at: indexPath.row)
        }
        let star = UIContextualAction(style: .normal, title: "Star") {  (_, _, _) in
            // TODO write star logic
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

extension TodoViewController : TaskDelegate{
    func didTapSave(task: Task) {
        todoList.append(task)
        tableView.reloadData()
    }
    
    func didTapUpdate(task: Task) {
        print("update")
        print(task)
        todoList[lastIndexTapped] = task
        tableView.reloadData()
    }
}

//MARK:- Textview Delagate methods
extension TodoViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        todoList[textView.tag].title = textView.text
    }
}
