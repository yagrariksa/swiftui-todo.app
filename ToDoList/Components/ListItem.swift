//
//  ListItem.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

struct ListItem: View {
    var todo: String
    @Binding var yes: Bool
    var onClick: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: yes ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    withAnimation {
                        yes.toggle()
                    }
                }
                .padding(.trailing, 8)
                .padding(.top, 8)
            
            Button {
                onClick()
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(todo)
                            .font(.headline)
                            .foregroundColor(.black)
                        HStack {
                            Text("Deadline:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(Date().formatted(.dateTime))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text("#A")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ListItem(todo: "a", yes: .constant(false), onClick: {})
            ListItem(todo: "b", yes: .constant(true), onClick: {})
        }
        .padding(.leading, 16)
    }
}
