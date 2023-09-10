//
//  NewTodoView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct NewTodoView: View {
    
    var dismiss: () -> Void
    var edit: String? = nil
    
    @State private var title: String = ""
    @State private var haveDeadline: Bool = false
    @State private var deadline: Date = Date()
    var body: some View {
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
                Spacer()
            }
            .padding()
            .navigationTitle("New ToDo Item")
            .toolbar {
                ToolbarItem(id: "Save", placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
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

struct NewTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodoView(dismiss: {})
    }
}
