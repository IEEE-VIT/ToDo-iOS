//
//  TodoViewController.swift
//  To-Do
//
//  Created by Aaryan Kothari on 29/09/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    /// `Tableview` to display list of tasks
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    /// `SearchController` to include search bar
    var searchController: UISearchController!
    
    /// `ResultsController` to display results of specific search
    var resultsTableController: ResultsTableController!
    
    /// `DataSource` for todoTableview
    var todoList : [Task] = []
    var lastIndexTapped : Int = 0
    
    /// Coredata managed object
    var moc: NSManagedObjectContext!
    /// Controller to fetch tasks from core-data
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    /// default fetch request for tasks
    lazy var defaultFetchRequest: NSFetchRequest<Task> = {
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        return fetchRequest
    }()
    
    /// `Reuse Identifier` for TodoTableViewCell
    let todoCellReuseIdentifier = "todocell"
    
    /// `Segue Identifier` to go to TaskDetailsViewController
    let taskDetailsIdentifier = "gototask"
    
    var currentSelectedSortType: SortTypesAvailable = .sortByNameAsc
    
    //MARK: View lifecycle methods
    override func viewDidLoad() {
        setupSearchController()
        super.viewDidLoad()
        
        showOnboardingIfNeeded()
        setupEmptyState()
        /// Core data setup and population
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.searchController = searchController
    }
    
    /// initialize ManagedObjectContext
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let persistenceContainer = appDelegate.persistentContainer
        moc = persistenceContainer.viewContext
        defaultFetchRequest.sortDescriptors = currentSelectedSortType.getSortDescriptor()
        setupFetchedResultsController(fetchRequest: defaultFetchRequest)
        /// reloading the table view with the fetched objects
        if let objects = fetchedResultsController.fetchedObjects {
            self.todoList = objects
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /// initialize FetchedResultsController
    func setupFetchedResultsController(fetchRequest: NSFetchRequest<Task>) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    //MARK: IBActions
    /// perform segue to `TaskDetailsViewController` if `+` tapped
    @IBAction func addTasksTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: taskDetailsIdentifier, sender: Any?.self)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        showSortAlertController()
    }
    
    
    ///Star task
    /// function called when `Star Task` tapped
    func starTask(at index : Int){
        //TODO: write star login
        todoList[index].isFavourite = todoList[index].isFavourite ? false : true
        updateTask()
    }
    
    ///Delete task
    /// function called when `Delete Task` tapped
    func deleteTask(at index : Int){
        let element = todoList.remove(at: index) /// removes task at index
        /// deleting the object from core data
        moc.delete(element)
        do {
            try moc.save()
        } catch {
            todoList.insert(element, at: index)
            print(error.localizedDescription)
        }
        tableView.reloadData() /// Reload tableview with remaining data
    }
    
    /// Update task
    /// function called whenever updating a task is required
    func updateTask(){
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskDetailVC = segue.destination as? TaskDetailsViewController{
            taskDetailVC.delegate = self
            taskDetailVC.task = sender as? Task
        }
    }
    
    /// onboarding setup
    fileprivate func showOnboardingIfNeeded() {
        guard let onboardingController =
                self.storyboard?.instantiateViewController(identifier: "OnboardingViewController") as? OnboardingViewController else {
            return
        }

        if !onboardingController.alreadyShown() {
            DispatchQueue.main.async {
                self.present(onboardingController, animated: true)
            }
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
        searchController.view.backgroundColor = .white
    }
    
    fileprivate func setupEmptyState() {
        
        let image = UIImage(systemName: "note.text")!
        let heading = "No tasks added"
        let subheading = """
         You can create a new task with ease.
         Tap the '+' button on top!
         """
        let emptyBackgroundView = EmptyState(image: image, heading: heading, subheading: subheading)
        tableView.backgroundView = emptyBackgroundView
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    //MARK:  ------ Tableview Datasource methods ------
    // Reference: https://developer.apple.com/documentation/uikit/uitableviewdatasource
    
    /// function to determine `Number of rows` in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sortButton.isEnabled = self.todoList.count > 0
        
        if todoList.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        
        }
        
        return todoList.count
    }
    
    /// function  to determine `tableview cell` at a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCellReuseIdentifier, for: indexPath) as! TaskCell
        let task = todoList[indexPath.row]
        cell.title.text = task.title
        cell.subtitle.text = task.dueDate
        cell.starImage.isHidden = todoList[indexPath.row].isFavourite ? false : true
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
        let star = UIContextualAction(style: .normal, title: todoList[indexPath.row].isFavourite ? "Unstar" : "Star"){  (_, _, _) in
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

extension TodoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            break
        @unknown default:
            break
        }
    }
}

//MARK: - TaskDelegate
/// protocol for `saving` or `updating` `Tasks`
extension TodoViewController : TaskDelegate{
    func didTapSave(task: Task) {
        todoList.append(task)
        do {
            try moc.save()
        } catch {
            todoList.removeLast()
            print(error.localizedDescription)
        }
        loadData()
    }
    
    func didTapUpdate(task: Task) {
        /// Reload tableview with new data
        updateTask()
    }
    
    
}

// MARK: - Search Bar Delegate

extension TodoViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        /// perform search only when there is some text
        if let text: String = searchController.searchBar.text?.lowercased(), text.count > 0, let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.todoList = todoList.filter({ (task) -> Bool in
                if task.title?.lowercased().contains(text) == true || task.subTasks?.lowercased().contains(text) == true {
                    return true
                }
                return false
            })
            let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", text)
            setupFetchedResultsController(fetchRequest: fetchRequest)
            resultsController.tableView.reloadData()
        } else {
            /// default case when text not available or text length is zero
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

// MARK:- Sort functionality
extension TodoViewController {
    
    func showSortAlertController() {
        let alertController = UIAlertController(title: nil, message: "Choose sort type", preferredStyle: .actionSheet)
        
        SortTypesAvailable.allCases.forEach { (sortType) in
            let action = UIAlertAction(title: sortType.getTitleForSortType(), style: .default) { (_) in
                self.currentSelectedSortType = sortType
                self.loadData()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}
