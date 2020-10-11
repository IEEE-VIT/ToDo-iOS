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
    }

    // MARK: - Logic

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
}

// MARK: - TableView DataSource and Delegate Methods
extension TaskHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
