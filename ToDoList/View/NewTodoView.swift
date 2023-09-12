//
//  NewTodoView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct NewTodoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)])
    private var categories: FetchedResults<Category>
    
    var dismiss: () -> Void
    var edit: Task? = nil
    
    @State private var title: String = ""
    @State private var haveDeadline: Bool = false
    @State private var deadline: Date = Date()
    @State private var selectedCategories: [Category] = []
    
    @State private var showAddCategory = false
    
    func toggleCategory(_ cat: Category) {
        if isActive(cat) {
            selectedCategories.removeAll(where: {$0 == cat})
        }else {
            selectedCategories.append(cat)
        }
    }
    
    func isActive(_ cat: Category) -> Bool {
        return selectedCategories.first(where: {$0 == cat}) != nil
    }
    
    func submit() {
        guard title != "" else { return }
        
        if let edit = edit {
            edit.title = title
            
            if edit.deadline != nil && !haveDeadline {
                NotificationScheduler.cancel(edit)
            }
            
            if haveDeadline {
                edit.deadline = deadline
                NotificationScheduler.updateNotification(edit)
            }
            
            edit.date_update = Date()
            for cat in edit.categoriesArray {
                edit.removeFromCategories(cat)
            }
            for cat in selectedCategories {
                edit.addToCategories(cat)
            }
            
            do {
                try viewContext.save()
                print("🟢Success Make Change")
                dismiss()
            } catch {
                print("🔴Fail Save Task: \(String(describing: error))")
            }
            
        } else {
            do {
                try Task.create(viewContext, title, haveDeadline ? deadline : nil, selectedCategories)
                print("🟢Success create task")
                dismiss()
            } catch {
                print("🔴Fail create Task: \(String(describing: error))")
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                List {
                    inputTitle
                    
                    inputDeadline
                    
                    Section  {
                        Button(action: {
                            showAddCategory.toggle()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                Text("Add Category")
                            }
                            .clipShape(Rectangle())
                        }
                        .buttonStyle(.borderless)
                        placeCategoryWithWrapper(proxy)
                    } header: {
                        Text("Categories")
                    } footer: {
                        Text("you can select none, one, or many")
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle((edit != nil ? "Edit" : "New") + " ToDo Item")
                .toolbar {
                    ToolbarItem(id: "Save", placement: .navigationBarTrailing) {
                        Button(action: submit) {
                            Text(edit != nil ? "Save" : "Add")
                        }
                    }
                    
                    ToolbarItem(id: "Save", placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }
                    }
                }
                .onChange(of: edit, perform: { _ in
                   isEdit()
                })
                .onAppear(perform: isEdit)
                .alert("New Category", isPresented: $showAddCategory, actions: {
                    AlertNewCategoryView(dismiss: {showAddCategory.toggle()})
                })
            }
        }
    }
    
    var inputTitle: some View {
        Section("Title") {
            TextField("Do Something", text: $title)
        }
    }
    
    var inputDeadline: some View {
        Section {
            Toggle("Enable", isOn: $haveDeadline)
            
            if haveDeadline {
                DatePicker("", selection: $deadline)
                    .padding(.top, 8)
            }
        } header: {
            Text("Deadline")
        } footer: {
            Text("it will set a reminder as notification")
        }
    }
    
    func isEdit() {
        print("⚪️EDIT: \(String(describing: edit))")
        guard let edit = edit, let title = edit.title else { return }
        self.title = title
        if let deadline = edit.deadline {
            self.deadline = deadline
            self.haveDeadline = true
        }
        self.selectedCategories = edit.categoriesArray
    }
    
    func btnStyle(_ cat: Category) -> any PrimitiveButtonStyle {
        if isActive(cat) {
            return .borderedProminent
        }else{
            return .bordered
        }
    }
    
    func placeCategoryWithWrapper(_ g: GeometryProxy) -> some View
    {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    toggleCategory(category)
                }) {
                    if let title = category.title {
                        Text(title)
                            .foregroundColor(isActive(category) ? .blue : .gray)
                    }
                }
                .padding(4)
                .buttonStyle(.bordered)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if category == self.categories.last! {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if category == self.categories.last! {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
        
    }
}

struct NewTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodoView(dismiss: {})
            .environment(\.managedObjectContext, PersistenceController.example.container.viewContext)
    }
}
