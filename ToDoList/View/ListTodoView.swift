//
//  ListTodoView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct ListTodoView: View {
    var todos = ["a", "b", "c","a", "b", "c","a", "b", "c"]
    
    @State private var yes = false
    @State private var showAddItemSheet = false
    @State private var searchQuery = "abc"
    
    @State private var selected: String? = nil

    var body: some View {
        VStack {
            List {
                
                ForEach(todos, id: \.self) { todo in
                    ListItem(todo: todo, yes: $yes, onClick: {
                        selected = todo
                        showAddItemSheet = true
                    })
                }
                .padding(.leading, 16)
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .searchable(
                text: $searchQuery,
                placement: .navigationBarDrawer(displayMode: .automatic))
            Spacer()
        }
        .navigationTitle("ToDo")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(id: "add", placement: .bottomBar) {
                Button {
                    showAddItemSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Item")
                    }
                }
                
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            NewTodoView(dismiss: {
                showAddItemSheet.toggle()
                selected = nil
            }, edit: selected)
        }
        
        
    }
}

struct ListTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ListTodoView()
    }
}
