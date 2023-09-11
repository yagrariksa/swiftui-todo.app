//
//  AlertNewCategoryView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import SwiftUI

struct AlertNewCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var newCategory: String
    
    var dismiss: () -> Void
    
    var body: some View {
        TextField("Category name", text: $newCategory)
        
        Button("Add") {
            do {
                guard newCategory != "" else { return }
                try Category.create(viewContext, newCategory)
                newCategory = ""
                dismiss()
                print("🟢Success Add Category")
            } catch {
                print("🔴ERROR: fail create Category \(String(describing: error))")
            }
        }
        Button("Cancel", role: .cancel) {
            dismiss()
        }
    }
}

struct AlertNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AlertNewCategoryView(newCategory: .constant(""), dismiss: {})
    }
}
