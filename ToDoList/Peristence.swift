//
//  Peristence.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import Foundation
import CoreData

struct PeristenceController {
    static let shared = PeristenceController()
    
    static var example: PeristenceController = {
        let persistence = PeristenceController(inMemory: true)
        let viewContext = persistence.container.viewContext
        
        let fetch = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let todos = try viewContext.fetch(fetch)
            
            print("🔵found \(todos.count) data")
            if todos.count > 10 {
                
                for todo in todos {
                    viewContext.delete(todo)
                }
            }
            
            if todos.count == 0 {
                var categories: [Category] = []
                for i in 0..<10 {
                    if i < 5 {
                        let newCat = Category(context: viewContext)
                        newCat.title = "Cat - \(i)"
                        categories.append(newCat)
                    }
                    
                    let newTask = Task(context: viewContext)
                    newTask.title = "Task - \(i)"
                    
                    if i >= 5, let cat = categories.randomElement() {
                        newTask.addToCategories(cat)
                    }
                }
            }

        } catch {
            print("onAppaer🔴: fail execute \(String(describing: error))")
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return persistence
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
