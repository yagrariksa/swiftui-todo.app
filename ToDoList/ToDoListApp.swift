//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 10/09/23.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared
    let center = UNUserNotificationCenter.current()
    
    fileprivate func registerNotificatino() {
        UIApplication.shared.registerForRemoteNotifications()
        
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
    
    init() {
        registerNotificatino()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext)
                
        }
    }
}
