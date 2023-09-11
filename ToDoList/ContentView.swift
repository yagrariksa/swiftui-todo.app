//
//  ContentView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        NavigationView {
            ListTodoView()
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(
                \.managedObjectContext,
                 PersistenceController.example.container.viewContext)
    }
}
