//
//  AlertNewCategoryView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import SwiftUI

struct AlertNewCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newCategory: String = ""
    
    var dismiss: () -> Void
    
    func submit() {
        guard newCategory != "" else { return }
        
        do {
            try Category.create(viewContext, newCategory)
            print("🟢Success Add Category")
            dismiss()
        } catch {
            print("🔴FAIL Create Category")
        }
    }
    
    var body: some View {
        TextField("Category name", text: $newCategory)
        
        Button("Add", action: submit)
        Button("Cancel", role: .cancel, action: dismiss)
    }
}

struct AlertNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AlertNewCategoryView(dismiss: {})
    }
}
