//
//  TaskDataPresenter.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import Foundation
import CoreData

class TaskDataPresenter: ObservableObject {
    @Published var todos: [Task] = []
    
    private let taskFetch = NSFetchRequest<Task>(entityName: Task.EntityName)
    
    private let sortByName = NSSortDescriptor(key: "title", ascending: true)
    
    func fetch(_ viewContext: NSManagedObjectContext) {
        print("taskDP🔵Fetch Data")
        do {
            taskFetch.sortDescriptors = [sortByName]
            
            self.todos = try viewContext.fetch(taskFetch)
            print("taskDP🟢RESULT: \(self.todos.count) task found")
        } catch {
            print("taskDP🔴Error: Fetch Data Task: \(String(describing: error))")
        }
    }
}
