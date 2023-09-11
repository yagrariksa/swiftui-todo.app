//
//  TodoDataPresenter.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import Foundation

class TodoDataPresenter: ObservableObject {
    private var origin_todos: [Task] = []
    @Published var todos: [Task] = []
    
    func updateAll(_ todos: [Task], _ filter: [Category], _ query: String?) {
        self.origin_todos = todos
        self.filter(filter)
        self.search(query)
    }
    
    private func filter(_ cats: [Category]) {
        guard !cats.isEmpty else {
            self.todos = origin_todos
            return
        }
        self.todos = origin_todos.filter { task in
            task.categoriesArray.contains(cats)
        }
    }
    
    func search(_ query: String?) {
        guard let query = query, query != "" else { return }
        self.todos = self.todos.filter {
            $0.title!
                .lowercased()
                .localizedStandardContains(query.lowercased())
        }
        
    }
    
    
}
