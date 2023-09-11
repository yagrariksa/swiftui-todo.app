//
//  FilterView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)])
    private var categories: FetchedResults<Category>
    
    @Binding var selected: [Category]
    var dismiss: () -> Void
    
    @State private var showNewCategory = false
    
    private func catIsSelected(_ cat: Category) -> Bool {
        return selected.contains(cat)
    }
    
    private func toggleSelect(_ cat: Category) {
        if catIsSelected(cat) {
            selected.removeAll(where: {$0 == cat})
        }else{
            selected.append(cat)
        }
    }
    
    private func performDelete(_ offset: IndexSet) {
        let data = offset.map { categories[$0] }
        
        for datum in data {
            viewContext.delete(datum)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("🔴Fail Delete Category")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if categories.isEmpty {
                    Text("You Have No Categories")
                }
                List {
                    ForEach(categories, id: \.id) { cat in
                        Button {
                            toggleSelect(cat)
                        } label: {
                            HStack {
                                Text(cat.title!)
                                Spacer()
                                if catIsSelected(cat) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    .onDelete(perform: performDelete)
                }
                .listStyle(.plain)
                .alert("New Category", isPresented: $showNewCategory) {
                    AlertNewCategoryView(dismiss: {showNewCategory.toggle()})
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Apply")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            selected = []
                            dismiss()
                        } label: {
                            Text("Reset")
                                .foregroundColor(.red)
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showNewCategory.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                                    .foregroundColor(.blue)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Select Categories")
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selected: .constant([]), dismiss: {})
    }
}
