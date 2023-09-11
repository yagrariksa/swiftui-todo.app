//
//  ListItem.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct TodoItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) var editMode
    
    var todo: Task
    var onClick: () -> Void
    
    func finishToggle() {
        withAnimation {
            todo.finish.toggle()
            if todo.deadline != nil {
                if todo.finish {
                    NotificationScheduler.cancel(todo)
                }else{
                    NotificationScheduler.create(todo)
                }
            }
            do {
                try viewContext.save()
            } catch {
                print("🔴Fail Toggle Finish")
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if let em = editMode {
                if em.wrappedValue == .inactive  {
                    Image(systemName: todo.finish ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .onTapGesture(perform: finishToggle)
                        .padding(.trailing, 8)
                        .padding(.top, 8)
                }
            }
            
            Button {
                onClick()
            } label: {
                HStack {
                    information
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, -12)
        .onAppear {
        }
//        .border(.blue)
    }
    
    var information: some View {
        VStack(alignment: .leading) {
            Text(todo.title ?? "")
                .font(.headline)
                .foregroundColor(.black)
                .strikethrough(todo.finish)
            HStack {
                if let deadline = todo.deadline {
                    Text("Deadline:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(deadline.formatted(.dateTime))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            HStack {
                ForEach(todo.categoriesArray, id: \.self) { cat in
                    if let title = cat.title {
                        Text("#\(title)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                   
                }
            }
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TodoItem(todo: Task.example, onClick: {})
            TodoItem(todo: Task.example, onClick: {})
        }
        .padding(.leading, 16)
    }
}
