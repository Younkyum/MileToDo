//
//  NotificationManager.swift
//  MileToDo
//
//  Created by YounkyumJin on 5/28/24.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    let targetModel: TodoModel
    
    init(targetModel: TodoModel) {
        self.targetModel = targetModel
    }
}

extension NotificationManager {
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [targetModel.id.uuidString])
    }
    
    func registerNotification() {
        let notificationIdentifier = targetModel.id.uuidString
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: getContents(), trigger: getTrigger())
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func getTrigger() -> UNCalendarNotificationTrigger {
        let trigger = UNCalendarNotificationTrigger(dateMatching: getTargetComponent(), repeats: false)
        return trigger
    }
    
    func getContents() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = self.targetModel.todoName
        let notificationPlan = NotificationPlan(rawValue: targetModel.notificationPlan)
        content.body = notificationPlan?.getNotificationString() ?? "Fatal Error"
        content.sound = .default
        return content
    }
    
    func getTargetComponent() -> DateComponents {
        let calendar = Calendar.current
        var component = DateComponents()
        
        let notificationPlan = NotificationPlan(rawValue: targetModel.notificationPlan)
        
        switch notificationPlan {
        case .rightTime:
            break
        case .fiveMinutes:
            component.minute = -5
        case .fifteenMinutes:
            component.minute = -15
        case .halfHours:
            component.minute = -30
        case .oneHour:
            component.hour = -1
        case .twoHours:
            component.hour = -2
        case .oneDay:
            component.day = -1
        case .twoDays:
            component.day = -2
        case .oneWeek:
            component.day = -7
        case .none?:
            break
        default:
            break
        }
        
        guard let targetDate = calendar.date(byAdding: component, to: targetModel.deadLineDate) else {
            fatalError()
        }
        
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate)
    }
}

