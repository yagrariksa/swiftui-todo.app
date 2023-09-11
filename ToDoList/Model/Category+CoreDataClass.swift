//
//  Category+CoreDataClass.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    public static var example: Category {
        return Category()
    }
    
    public static let EntityName = "Category"
    
    public static func create(
        _ viewContext: NSManagedObjectContext,
        _ title: String
    ) throws {
        let newCategory = Category(context: viewContext)
        newCategory.title = title
        
        do {
            try viewContext.save()
        } catch {
            print("🔴ERROR: fail create category")
            throw ModelError.FailCreateCategory
        }
    }
}
