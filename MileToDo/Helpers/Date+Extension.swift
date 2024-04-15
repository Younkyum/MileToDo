//
//  Date+Extension.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/11/24.
//

import SwiftUI

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko-KR")
        
        return formatter.string(from: self)
    }
    
    func lunarFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.calendar = Calendar(identifier: .chinese)
        
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        
        (0..<7).forEach{ index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    func createPrieviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        
        guard let previouseDate = calendar.date(byAdding: .day, value: -1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(previouseDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
