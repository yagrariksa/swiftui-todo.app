//
//  ListTodoView.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct ListTodoView: View {
    var todos = ["a", "b", "c"]
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                Rectangle()
                    .frame(height: 0.3)
                    .foregroundColor(.gray)
                ForEach(todos, id: \.self) { todo in
                    HStack(alignment: .top) {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                print("Done!")
                            }
                            .padding(.trailing, 4)
                            .padding(.top, 8)
                        Button {
                            print("Click!")
                        } label: {
                            
                            VStack(alignment: .leading) {
                                Text(todo)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer(minLength: 4)
                                HStack {
                                    Text("Deadline:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("\(Date().formatted(.dateTime))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer(minLength: 4)
                                Text("#A")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Spacer(minLength: 8)
                                Rectangle()
                                    .frame(height: 0.3)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.leading, 4)
                    }
                }
                .padding(.leading, 16)
                .padding(.vertical, 4)
            }
            Spacer()
        }
        .navigationTitle("ToDo")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(id: "add", placement: .bottomBar) {
                Button {
                    print("Add Task")
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Item")
                    }
                }
                
            }
        }
        
        
    }
}

struct ListTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ListTodoView()
    }
}
