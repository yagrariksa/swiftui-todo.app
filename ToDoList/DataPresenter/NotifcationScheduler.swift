//
//  NotifcationScheduler.swift
//  ToDoList
//
//  Created by Daffa Yagrariksa on 11/09/23.
//

import Foundation
import UserNotifications
import SwiftUI

struct NotificationScheduler {
    
    static func create(_ task: Task) {
        guard let deadline = task.deadline,
              let title = task.title
        else { return }
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.sound = .defaultRingtone
        
//        print("ID NOW: \(task.id.hashValue)")
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: String(task.id.hashValue),
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
                print("🔴Error scheduling notification: \(error)")
            } else {
                print("🟢Success ScheduleNotif: \(task.id.hashValue)")
            }
        }
    }
    
    static func cancel(_ task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(task.id.hashValue)])
        print("🟡🟢Success Cancel ScheduleNotif: \(task.id.hashValue)")
    }
    
    static func updateNotification(_ task: Task) {
        NotificationScheduler.cancel(task)
        NotificationScheduler.create(task)
    }
    
}
