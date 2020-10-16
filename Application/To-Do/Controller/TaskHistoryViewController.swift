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
    var dataSource = TaskHistoryDataSource()

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
        
        historyTableView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
        setupEmptyState()
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
            TaskHistoryDataSource.completedList = try moc.fetch(request)
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        } catch {
            print("can't fetch data")
        }
    }
}
<<<<<<< HEAD
=======

// MARK: - TableView DataSource and Delegate Methods
extension TaskHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if completedList.count == 0 {
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
}
>>>>>>> eac319f932a886889e9eef8cad9609862eeda437
