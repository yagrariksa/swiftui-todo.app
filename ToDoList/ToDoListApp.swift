//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PeristenceController.example
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext)
                
        }
    }
}
