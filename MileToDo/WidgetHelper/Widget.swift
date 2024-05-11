//
//  Provider.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/29/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TodoItem {
    var id: UUID
    var text: String
    var deadLine: Date
    var isFinished: Bool
    var isKilled: Bool
    var projectColor: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetTodoList: [])
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetTodoList: [])
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        
        let context = sharedModelContainer.mainContext
        
        let items = (try? context.fetch(FetchDescriptor<TodoModel>())) ?? []
        
        let todoItems = items.map { TodoItem(id: $0.id,
                                             text: $0.todoName,
                                             deadLine: $0.deadLineDate,
                                             isFinished: $0.isFinished,
                                             isKilled: $0.isKilled,
                                             projectColor: $0.project.projectColor ) }
        
        let clearedTodoItems = todoItems.filter { todo in
            if todo.isFinished == false && todo.isKilled == false {
                return true
            } else {
                return false
            }
        }
        
        let incompleted = clearedTodoItems.sorted { $0.deadLine < $1.deadLine }
        
        entries.append(SimpleEntry(date: currentDate, widgetTodoList: incompleted))
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetTodoList: [TodoItem]
}


struct MileTodoWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // TODO: Change Todo Counts For Types
                switch family {
                case .systemLarge:
                    ForEach(entry.widgetTodoList, id: \.id) { todo in
                        TodoRow(todo)
                    }
                case .systemMedium:
                    ForEach(entry.widgetTodoList, id: \.id) { todo in
                        TodoRow(todo)
                    }
                case .systemSmall:
                    ForEach(entry.widgetTodoList, id: \.id) { todo in
                        TodoRow(todo)
                    }
                    
                @unknown default:
                    Text("error")
                }
                
                
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func TodoRow(_ todo: TodoItem) -> some View {
        HStack {
            Image(systemName: "square.fill")
                .resizable()
                .frame(width: 4)
                .foregroundStyle(Color(hex: todo.projectColor))
                .padding(.trailing, 1)
            
            Text(todo.text)
                .font(.system(size: 14))
                .lineLimit(1)
            
        }
    }
}



extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}


extension View {
    /// Custom Spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
