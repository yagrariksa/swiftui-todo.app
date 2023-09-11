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
                }
                .listStyle(.plain)
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
