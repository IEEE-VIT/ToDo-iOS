//
//  TaskDetailsViewController.swift
//  To-Do
//
//  Created by Aaryan Kothari on 30/09/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

protocol TaskDelegate: class {
    func didTapSave(task : Task)
    func didTapUpdate(task : Task)
}

class TaskDetailsViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var subTasksTextView: UITextView!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // VARIABLES
    var task : Task? = nil
    var endDate : String = ""
    var endDatePicker: UIDatePicker!
    var dateFormatter: DateFormatter = DateFormatter()
    weak var delegate : TaskDelegate?
    var isUpdate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isUpdate = (task != nil)
        endDatePicker = UIDatePicker()
        endDatePicker.addTarget(self, action: #selector(didPickDate(_:)), for: .valueChanged)
        endDatePicker.minimumDate = Date()
        endDateTextField.inputView = endDatePicker
        dateFormatter.dateStyle = .medium
        subTasksTextView.addBorder()
        loadTaskForUpdate()
        saveButton.title = isUpdate ? "Update" : "Add"
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let task = createTaskBody() else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if isUpdate {
            self.delegate?.didTapUpdate(task: task)
        } else {
            self.delegate?.didTapSave(task: task)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // function that `Creates Task body`
    /// Title: String taken from `taskTitleTextField`
    /// Subtask: String taken from `subTasksTextView`
    /// endDate : String taken from `didPickDate method`
    func createTaskBody()->Task?{
        let title = taskTitleTextField.text ?? ""
        let subtask = subTasksTextView.text ?? ""
        /// check if we are updating the task or creatiing the task
        if self.task == nil {
            let mainController = self.delegate as! TodoViewController
            self.task = Task(context: mainController.moc)
        }
        task?.title = title
        task?.subTasks = subtask
        task?.dueDate = endDate
        return task
    }
    
    
    func loadTaskForUpdate(){
        guard let task = self.task else { return }
        taskTitleTextField.text = task.title
        subTasksTextView.text = task.subTasks
        endDateTextField.text = task.dueDate
    }
    
    // IBOUTLET for datepicker
    /// function is called when `Date is changed`
    /// `Dateformatter` is used to convert `Date` to `String`
    @objc func didPickDate(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate = sender.date
        endDate = dateFormatter.string(from: selectedDate)
        endDateTextField.text = endDate

    }
    
}
