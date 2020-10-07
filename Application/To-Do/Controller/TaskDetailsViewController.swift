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

class TaskDetailsViewController: UIViewController{
    
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
    var selectedDateTimeStamp: Double?
    
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
        taskTitleTextField.delegate = self
        // Tap outside to close the keybord
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        saveButton.title = isUpdate ? "Update" : "Add"
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if !isValidTask() { return }
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

    /// Function that determines if a task is valid or not. A valid task has both a title and due date.
    /// Title: String taken from `taskTitleTextField`
    /// endDate : String taken from `endDueDateTextField`
    /// - Returns: A bool whether or not the task is valid.
    func isValidTask() -> Bool {
        if taskTitleTextField.text!.isEmpty {
            Alert.showNoTaskTitle(on: self)
            return false
        }else if endDateTextField.text!.isEmpty {
            Alert.showNoTaskDueDate(on: self)
            return false
        } else {
            return true
        }
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
        task?.dueDateTimeStamp = selectedDateTimeStamp ?? 0
        return task
    }
    
    
    func loadTaskForUpdate(){
        guard let task = self.task else {
            // Set placeholder texts when adding new task
            subTasksTextView.textColor = .lightGray
            subTasksTextView.delegate = self
            subTasksTextView.text = "Enter your subtasks here"
            taskTitleTextField.placeholder = "Enter task name"
            endDateTextField.placeholder = "Select end date"
            return
        }
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
        self.selectedDateTimeStamp = sender.date.timeIntervalSince1970
        endDate = dateFormatter.string(from: selectedDate)
        endDateTextField.text = endDate

    }
    
}
extension TaskDetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskTitleTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your subtasks here"
            textView.textColor = .lightGray
        }
    }
}
