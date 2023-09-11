//
//  Task+CoreDataClass.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    public static var example: Task =  {
        let task = Task()
        task.title = "task example"
        task.deadline = Date()
        task.finish = Int.random(in: 0...10) > 7 ? true : false
        
        return task
    }()
    
    public static let EntityName = "Task"
    
    public static func create (
        _ viewContext: NSManagedObjectContext,
        _ title: String,
        _ deadline: Date?,
        _ categories: [Category]?
    ) throws {
        let newTask = Task(context: viewContext)
        newTask.title = title
        newTask.deadline = deadline
        newTask.date_update = Date()
        
        if let dl = deadline {
            NotificationScheduler.create(newTask)
        }
        
        if let categories = categories {
            for category in categories {
                newTask.addToCategories(category)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("🔴ERROR: fail create new data: \(String(describing: error))")
            throw ModelError.FailCreateTask
        }
    }
    
    var categoriesArray: [Category]  {
        let set = categories as? Set<Category> ?? []
        return set.sorted(by: {$0.title! < $1.title!})
    }
}
