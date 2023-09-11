//
//  ListTodoView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI
import CoreData

struct ListTodoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var todoDP = TodoDataPresenter()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date_update", ascending: true)])
    private var todos: FetchedResults<Task>
    
    @State private var yes = false
    @State private var showAddItemSheet = false
    @State private var searchQuery = ""
    
    @State private var selected: Task? = nil
    @State private var showAddCategory = false
    
    @State private var filterActive: [Category] = []
    @State private var showFilterSheet = false
    
    func updateData() {
        todoDP.updateAll(Array(todos), filterActive, searchQuery)
    }
    
    var unfinished: [Task] {
        return todoDP.todos.filter({ todo in
            return !todo.finish
        })
    }
    
    var finished: [Task] {
        return todoDP.todos.filter({ todo in
            return todo.finish
        })
    }
    
    func performDelete(_ offset: IndexSet, _ array: [Task] ) {
        let datas = offset.map { array[$0] }
        for data in datas {
            viewContext.delete(data)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("🔴FAIL performDelete")
        }
    }
    
    var emptyInfo: String {
        if todos.isEmpty {
            return "Let's Start !"
        }else if todoDP.todos.isEmpty {
            var txt = ""
            txt += "Empty ToDo Data"
            if searchQuery != "" {
                txt += "\n\nWith Search: \(searchQuery)"
            }
            if !filterActive.isEmpty {
                txt += "\n\nWith Category\n"
                for active in filterActive {
                    txt += "\(active.title ?? "")"
                    if active != filterActive.last {
                        txt += ", "
                    }
                }
                return txt
            }
            return txt
        }
        return ""
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if emptyInfo != "" {
                Text(emptyInfo)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            List {
                ForEach(unfinished, id: \.self) { todo in
                    TodoItem(todo: todo, onClick: {
                        selected = todo
                    })
                }
                .onDelete(perform: { offset in
                    performDelete(offset, unfinished)
                })
                .padding(.leading, 16)
                .padding(.vertical, 4)
                
                if !finished.isEmpty {
                    taskFinishedSection
                }
            }
            .listStyle(.plain)
            .searchable(
                text: $searchQuery,
                placement: .navigationBarDrawer(displayMode: .automatic))
            Spacer()
        }
        .onAppear(perform: updateData)
        .onChange(of: todos.count, perform: { _ in
            updateData()
        })
        .onChange(of: filterActive, perform: { _ in
            updateData()
        })
        .onChange(of: selected, perform: { _ in
            if selected != nil {
                showAddItemSheet.toggle()
            }
        })
        .onChange(of: searchQuery, perform: { _ in
            if searchQuery == "" {
                updateData()
            } else {
                todoDP.search(searchQuery)
            }
        })
        .alert("New Category", isPresented: $showAddCategory, actions: {
            AlertNewCategoryView(dismiss: {showAddCategory.toggle()})
        })
        .navigationTitle("ToDo")
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
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
            
            ToolbarItem(id: "addCat", placement: .bottomBar) {
                Button {
                    showAddCategory.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Category")
                    }
                }
            }
            
            ToolbarItem(id: "filter", placement: .navigationBarTrailing) {
                Button {
                    showFilterSheet.toggle()
                } label : {
                    HStack {
                        Image(systemName: "line.3.horizontal")
                        Text("Filter")
                    }
                }
            }
            
            if !self.todoDP.todos.isEmpty {
                ToolbarItem(id: "edit", placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            NewTodoView(dismiss: {
                showAddItemSheet.toggle()
                selected = nil
            }, edit: selected)
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterView(selected: $filterActive, dismiss: {
                showFilterSheet.toggle()
            })
        }
    }
    
    
    
    var taskFinishedSection: some View {
    
        Section("Finished") {
            ForEach(finished, id: \.self) { todo in
                TodoItem(todo: todo, onClick: {
                    selected = todo
                })
            }
            .onDelete(perform: { offset in
                performDelete(offset, finished)
            })
            .padding(.leading, 16)
            .padding(.vertical, 4)
        }
    
    }
}



struct ListTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ListTodoView()
    }
}
