//
//  To_DoTests.swift
//  To-DoTests
//
//  Created by Rizwan on 06/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import XCTest
import CoreData
@testable import To_Do

class TaskTests: XCTestCase {

    lazy var mockPersistantContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "To_Do")

      let description = NSPersistentStoreDescription()
      description.url = URL(fileURLWithPath: "/dev/null")
      container.persistentStoreDescriptions = [description]

      container.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
          fatalError("Failed to load stores: \(error), \(error.userInfo)")
        }
      })

      return container
    }()

    // MARK:- Setup

    override func setUpWithError() throws {
        try super.setUpWithError()
        try initStubs()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        flushData()
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK:- Helpers

    @discardableResult func createTask(
        title: String? = nil,
        subtasks: String? = nil,
        dueDate: String? = nil,
        dueDateTimeStamp: Double,
        isFavourite: Bool = false,
        isComplete: Bool = false
    ) -> Task? {
        let task = Task(context: mockPersistantContainer.viewContext)
        task.title = title
        task.subTasks = subtasks
        task.dueDate = dueDate
        task.isFavourite = isFavourite
        task.dueDateTimeStamp = dueDateTimeStamp
        task.isComplete = isComplete
        return task
    }

    func initStubs() throws {
        _ = createTask(title: "Task Title", subtasks: "Sub Tasks", dueDateTimeStamp: Date().timeIntervalSince1970)
        try mockPersistantContainer.viewContext.save()
    }

    func flushData() {
        let objs = try! mockPersistantContainer.viewContext.fetch(Task.fetchRequest())
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()

    }

    // MARK:- Task Tests

    func testFetchAllTasks() {
        let results = try? mockPersistantContainer.viewContext.fetch(Task.fetchRequest())
        XCTAssertEqual(results?.count, 1)
    }

    func testCreatTask() {
        let task = createTask(title: "Task Title", dueDateTimeStamp: Date().timeIntervalSince1970)
        XCTAssertNotNil(task)
    }
    
    func testMarkAsComplete() throws {
        let tasks = try mockPersistantContainer.viewContext.fetch(Task.fetchRequest()) as? [Task]
        let task = try XCTUnwrap(tasks?.first)
        
        let newIsCompleteValue = !task.isComplete
        
        task.isComplete = newIsCompleteValue
        try mockPersistantContainer.viewContext.save()
        
        XCTAssertEqual(task.isComplete, newIsCompleteValue)
    }
    
}
