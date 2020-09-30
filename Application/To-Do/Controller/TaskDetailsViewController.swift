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
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // VARIABLES
    var task : Task? = nil
    var endDate : String = ""
    var dateFormatter = DateFormatter()
    weak var delegate : TaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        subTasksTextView.addBorder()
        loadTaskForUpdate()
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let task = createTaskBody()
        let isUpdate = (self.task != nil)
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
    func createTaskBody()->Task{
        let title = taskTitleTextField.text ?? ""
        let subtask = subTasksTextView.text ?? ""
        let task = Task(dueDate: endDate,labels: [],subTasks: subtask, title: title)
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
    @IBAction func didPickDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        endDate = dateFormatter.string(from: selectedDate)
        endDateTextField.text = endDate
    }
    
}
