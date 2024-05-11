//
//  MileTodoWidget.swift
//  MileTodoWidget
//
//  Created by YounkyumJin on 4/29/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct MileTodoWidget: Widget {
    let kind: String = "MileTodoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MileTodoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MileTodoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("MileTodo Widget")
        .description("Show Todos which is near deadline")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

//#Preview(as: .systemSmall) {
//    MileTodoWidget()
//} timeline: {
//    SimpleEntry(date: Date(), listData: ["안녕", "아안녕"])
//}
