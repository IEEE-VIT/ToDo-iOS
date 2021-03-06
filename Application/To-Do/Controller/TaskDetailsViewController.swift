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
    //    @IBOutlet private weak var taskTitleTextField: UITextField!
    //    @IBOutlet private weak var subTasksTextView: UITextView!
    //    @IBOutlet private weak var endDateTextField: UITextField!
    //    @IBOutlet private weak var saveButton: UIBarButtonItem!
    //    @IBOutlet private weak var attachmentCollection: UICollectionView!
    
    
    
    // UI Elements
    let taskLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Task"
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return l
    }()
    
    let taskTitleTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter task name"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.systemGray.cgColor
        tf.layer.cornerRadius = 5
        
        
        return tf
    }()
    
    
    let subtasksLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Sub Tasks"
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return l
    }()
    
    let subTasksTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .secondarySystemGroupedBackground
        tv.text = "Enter your subtask here"
        tv.layer.cornerRadius = 5
        tv.layer.borderColor = UIColor.systemGray.cgColor
        tv.layer.borderWidth = 0.5
        
        return tv
    }()
    
    let endDateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "End Date"
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        
        return l
    }()
    
    let endDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Select end date"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.systemGray.cgColor
        tf.layer.cornerRadius = 5
        
        
        return tf
    }()
    
    let imageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Image attachments"
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        
        return l
    }()
    
    let addImageButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Add image", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        b.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        
        return b
    }()
    
    
    let attachmentCollection: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageAttachmentCell.self, forCellWithReuseIdentifier: ImageAttachmentCell.identifier)
        
        
        
        return collectionView
    }()
    
    
    
    // VARIABLES
    var task : Task? = nil
    var endDate : String = .empty
    var endDatePicker: UIDatePicker!
    var dateFormatter: DateFormatter = DateFormatter()
    weak var delegate : TaskDelegate?
    var isUpdate: Bool = false
    var selectedDateTimeStamp: Double?
    var imagesAttached = [UIImage]()
    
    var cameraHelper = CameraHelper()
    
    var hapticGenerator: UINotificationFeedbackGenerator? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachmentCollection.dataSource = self
        attachmentCollection.delegate = self

        
        // programmatically add the savebutton to the right bar button item
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        setupUI()
        
        isUpdate = (task != nil)
//        endDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 150))
        endDatePicker.contentHorizontalAlignment = .fill

        endDatePicker.addTarget(self, action: #selector(didPickDate(_:)), for: .valueChanged)
        endDatePicker.minimumDate = Date()
        endDateTextField.inputView = endDatePicker
        dateFormatter.dateStyle = .medium
        subTasksTextView.addBorder()
        loadTaskForUpdate()
        taskTitleTextField.delegate = self
        // Tap outside to close the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        saveButton.title = isUpdate ? Constants.Action.update : Constants.Action.add
    }
    
    // adding and constraining UI elements
    func setupUI() {
        
        
        
        self.view.addSubview(taskLabel)
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -30),
            taskLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            taskLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width/2)
            
            
            
        ])
        
        self.view.addSubview(taskTitleTextField)
        NSLayoutConstraint.activate([
            taskTitleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            taskTitleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            taskTitleTextField.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 15),
            taskTitleTextField.heightAnchor.constraint(equalToConstant: self.view.frame.height*0.05),
            
        ])
        
        self.view.addSubview(subtasksLabel)
        NSLayoutConstraint.activate([
            subtasksLabel.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 30),
            subtasksLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            subtasksLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            
        ])
        
        self.view.addSubview(subTasksTextView)
        NSLayoutConstraint.activate([
            subTasksTextView.topAnchor.constraint(equalTo: subtasksLabel.bottomAnchor, constant: 8),
            subTasksTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1428),
            subTasksTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            subTasksTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.80 )
            
            
        ])
        
        self.view.addSubview(endDateLabel)
        NSLayoutConstraint.activate([
            endDateLabel.topAnchor.constraint(equalTo: subTasksTextView.bottomAnchor, constant: 20 ),
            endDateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            endDateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            
        ])
        
        self.view.addSubview(endDateTextField)
        NSLayoutConstraint.activate([
            endDateTextField.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 8),
            endDateTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            endDateTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            endDateTextField.heightAnchor.constraint(equalToConstant: self.view.frame.height*0.05)
            
            
        ])
        
        
        // This will be added back in future PR
        self.view.addSubview(imageLabel)
        NSLayoutConstraint.activate([
            imageLabel.topAnchor.constraint(equalTo: endDateTextField.bottomAnchor, constant: 20),
            imageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),


        ])
        self.view.addSubview(addImageButton)
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: endDateTextField.bottomAnchor, constant: 20),
            addImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            imageLabel.trailingAnchor.constraint(equalTo: addImageButton.leadingAnchor),
            addImageButton.leadingAnchor.constraint(equalTo: imageLabel.trailingAnchor)
        ])
        
        
        self.view.addSubview(attachmentCollection)
        attachmentCollection.backgroundColor = .black
        NSLayoutConstraint.activate([
            attachmentCollection.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 10),
            attachmentCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            attachmentCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            attachmentCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
//            attachmentCollection.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
        
        
        
        
    }
    
    @objc func addPhotoTapped(_ sender: Any) {
        
        cameraHelper.openCamera(in: self) { [weak self ] image in
            guard let image = image else { return }
            self?.imagesAttached.append(image)
            self?.attachmentCollection.reloadData()
            
        }
        
    }
    
    
//    @objc func addImageAttachment(_sender: Any) {
//        // opening camera
//        cameraHelper.openCamera(in: self) { [weak self] image in
//            guard let image = image else { return }
//
//            // Adding attachment
//            //            self?.imagesAttached.append(image)
//            //            self?.attachmentCollection.reloadData()
//        }
//    }
    
    
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator?.prepare()

        guard isValidTask() else {
            hapticGenerator?.notificationOccurred(.warning)
            return
        }
        guard let task = createTaskBody() else {
            self.navigationController?.popViewController(animated: true)
            return
        }

        hapticGenerator?.notificationOccurred(.success)

        if isUpdate {
            self.delegate?.didTapUpdate(task: task)
        } else {
            self.delegate?.didTapSave(task: task)
        }
        self.navigationController?.popViewController(animated: true)

        hapticGenerator = nil
    }
    
    /// Function that determines if a task is valid or not. A valid task has both a title and due date.
    /// Title: String taken from `taskTitleTextField`
    /// endDate : String taken from `endDueDateTextField`
    /// - Returns: A bool whether or not the task is valid.
    func isValidTask() -> Bool {
        if taskTitleTextField.text?.trim().isEmpty ?? true {
            Alert.showNoTaskTitle(on: self)
            return false
        } else if endDateTextField.text?.trim().isEmpty ?? true {
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
    func createTaskBody()->Task? {
        let title = taskTitleTextField.text?.trim() ?? .empty
        let subtask = subTasksTextView.text?.trim() ?? .empty
        /// check if we are updating the task or creatiing the task
        if self.task == nil {
            let mainController = self.delegate as! TodoViewController
            self.task = Task(context: mainController.moc)
        }
        task?.title = title
        task?.subTasks = subtask
        task?.dueDate = endDate
        task?.dueDateTimeStamp = selectedDateTimeStamp ?? 0
        task?.attachments = try? NSKeyedArchiver.archivedData(withRootObject: imagesAttached, requiringSecureCoding: false)
        task?.isComplete = false
        
        return task
    }
    
        func loadTaskForUpdate() {
            guard let task = self.task else {
                subTasksTextView.textColor = .placeholderText
                return
            }
            taskTitleTextField.text = task.title
            subTasksTextView.text = task.subTasks
            endDateTextField.text = task.dueDate
    
            // Recover attachments
            if let attachments = task.attachments {
                imagesAttached = NSKeyedUnarchiver.unarchiveObject(with: attachments) as? [UIImage] ?? []
            }
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
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your subtasks here"
            textView.textColor = .placeholderText
        }
    }
}

extension TaskDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesAttached.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAttachmentCell.identifier, for: indexPath) as! ImageAttachmentCell
        let image = imagesAttached[indexPath.row]

        cell.setImage(image)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Click: \(indexPath.row) \(imagesAttached[indexPath.row])")
    }
}

