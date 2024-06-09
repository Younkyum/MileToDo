//
//  NotificationPlan.swift
//  MileToDo
//
//  Created by YounkyumJin on 5/28/24.
//

import Foundation

enum NotificationPlan: String, Codable, CaseIterable {
    case none
    case rightTime
    case fiveMinutes
    case fifteenMinutes
    case halfHours
    case oneHour
    case twoHours
    case oneDay
    case twoDays
    case oneWeek
}

extension NotificationPlan {
    func getSting() -> String {
        switch self {
        case .rightTime:
            return "마감 당시"
        case .fiveMinutes:
            return "5분 전"
        case .fifteenMinutes:
            return "15분 전"
        case .halfHours:
            return "30분 전"
        case .oneHour:
            return "1시간 전"
        case .twoHours:
            return "2시간 전"
        case .oneDay:
            return "1일 전"
        case .twoDays:
            return "2일 전"
        case .oneWeek:
            return "1주 전"
        case .none:
            return "없음"
        }
    }
    
    func getNotificationString() -> String {
        switch self {
        case .rightTime:
            return "지금 마감"
        case .fiveMinutes:
            return "마감 5분 전"
        case .fifteenMinutes:
            return "마감 15분 전"
        case .halfHours:
            return "마감 30분 전"
        case .oneHour:
            return "마감 1시간 전"
        case .twoHours:
            return "마감 2시간 전"
        case .oneDay:
            return "마감 1일 전"
        case .twoDays:
            return "마감 2일 전"
        case .oneWeek:
            return "마감 1주 전"
        case .none:
            return "None"
        }

    }
}
