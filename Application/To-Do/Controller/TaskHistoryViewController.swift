//
//  TaskHistoryViewController.swift
//  To-Do
//
//  Created by Mikaela Caron on 10/9/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData

class TaskHistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var historyTableView: UITableView!

    /// `DataSource` for historyTableView
    var completedList : [Task] = []

    /// CoreData managed object
    var moc: NSManagedObjectContext!
    
    /// Default fetch request for tasks
    lazy var defaultFetchRequest: NSFetchRequest<Task> = {
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        return fetchRequest
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
        if completedList.isEmpty {
            setupEmptyState()
        }
    }

    // MARK: - Logic

    fileprivate func setupEmptyState() {
        DispatchQueue.main.async {
            let emptyBackgroundView = EmptyState(.emptyHistory)
            self.historyTableView.backgroundView = emptyBackgroundView
            self.historyTableView.setNeedsLayout()
            self.historyTableView.layoutIfNeeded()
        }
        
    }
    
    /// Initialize ManagedObjectContext
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let persistenceContainer = appDelegate.persistentContainer
        moc = persistenceContainer.viewContext
        do {
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            let filter = NSPredicate(format: "isComplete = %d", true)
            request.predicate = filter
            completedList = try moc.fetch(request)
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        } catch {
            print("can't fetch data")
        }
    }
    /// Deletes task from CoreData and removes from `completedList` and `historyTableView`
    /// - Parameter indexPath: Which task to  delete
    func deleteTask(indexPath: IndexPath){

        let confirmation = UIAlertController(title: nil, message: "Delete this task?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.historyTableView.beginUpdates()

            let task = self.completedList.remove(at: indexPath.row)
            self.historyTableView.deleteRows(at: [indexPath], with: .automatic)
            self.moc.delete(task)
            do {
                try self.moc.save()
            } catch {
                self.completedList.insert(task, at: indexPath.row)
                print(error.localizedDescription)
            }
            self.historyTableView.endUpdates()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (_) in
            print("not going to delete")
            return
        }
        confirmation.addAction(deleteAction)
        confirmation.addAction(noAction)
        present(confirmation, animated: true, completion: nil)
    }
    
    // I wasn't sure if you want the user to be able to update completed tasks so I set isUserInteractionEnabled to false for all subviews of taskDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskDetailVC = segue.destination as? TaskDetailsViewController {
            // Hide the tab bar when new controller is pushed onto the screen
            taskDetailVC.hidesBottomBarWhenPushed = true
//            taskDetailVC.delegate = self
            taskDetailVC.task = sender as? Task
            taskDetailVC.view.subviews.forEach {
                $0.isUserInteractionEnabled = false
            }
            if let button = taskDetailVC.navigationItem.rightBarButtonItem {
                button.isEnabled = false
                button.tintColor = .clear
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate Methods
extension TaskHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if completedList.isEmpty {
             self.historyTableView.backgroundView?.isHidden = false
             self.historyTableView.separatorStyle = .none
         } else {
             self.historyTableView.backgroundView?.isHidden = true
             self.historyTableView.separatorStyle = .singleLine
         }
        
        return completedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.taskCell, for: indexPath) as! TaskCell
        let task = completedList[indexPath.row]
        cell.title.text = task.title
        cell.subtitle.text = task.dueDate
        cell.starImage.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(indexPath: indexPath)
        }
    }
    
    // pushes taskDetailsVC with completed task details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = completedList[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.taskToTaskDetail, sender: task)
    }
}
