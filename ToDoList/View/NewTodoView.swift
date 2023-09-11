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
    var edit: String? = nil
    
    @State private var title: String = ""
    @State private var haveDeadline: Bool = false
    @State private var deadline: Date = Date()
    @State private var selectedCategories: [Category] = []
    
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
        
        do {
            try Task.create(viewContext, title, haveDeadline ? deadline : nil, selectedCategories)
            print("🟢Success create task")
            dismiss()
        } catch {
            print("🔴Fail create Task: \(String(describing: error))")
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    Toggle("Deadline", isOn: $haveDeadline)
                        .padding(.top, 16)
                    if haveDeadline {
                        DatePicker("", selection: $deadline)
                            .padding(.top, 8)
                    }
                    
                    placeCategoryWithWrapper(proxy)
//                        .frame(width: proxy.size.width)
//                        .border(.red)
                        
                    Spacer()
                }
                .padding()
                .navigationTitle("New ToDo Item")
                .toolbar {
                    ToolbarItem(id: "Save", placement: .navigationBarTrailing) {
                        Button(action: submit) {
                            Text("Add")
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
                .onAppear {
                    guard let edit = edit else { return }
                    title = edit
                }
            }
        }
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
