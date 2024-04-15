//
//  Home.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/11/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) var context
    
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State var isProjectAppendSheetAppear: Bool = false
    
    @Query(sort: \ProjectModel.createdAt) var projectList: [ProjectModel]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0, content: {
                WeekSlider()
                
                TodoListView()
                
            })
            .onAppear(perform: {
                if weekSlider.isEmpty {
                    let currentWeek = Date().fetchWeek()
                                    
                    if let firstDate = currentWeek.first?.date {
                        weekSlider.append(firstDate.createPrieviousWeek())
                    }
                    
                    weekSlider.append(currentWeek)

                    if let lastDate = currentWeek.last?.date {
                        weekSlider.append(lastDate.createNextWeek())
                    }
                }
            })
            .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
            }
            
            ProjectAppendButton(isProjectAppendSheetAppear: $isProjectAppendSheetAppear)
        }
        .sheet(isPresented: $isProjectAppendSheetAppear, content: {
            ProjectAppend(isProjectAppendSheetAppear: $isProjectAppendSheetAppear)
        })
    }
}

#Preview {
    ContentView()
}


/// Vertical Calendar - WeekSlider
extension Home {
    @ViewBuilder
    func WeekSlider() -> some View {
        VStack {
            Text(currentDate.format("M월"))
                .font(.system(size: 34, weight: .bold))
                .hSpacing(.leading)
                .padding([.leading])
                .padding([.bottom], 8)
            VStack(spacing: 0, content: {
                Text("\(currentDate.format("YYYY년 M월 d일"))")
                    .font(.system(size: 17))
                    .hSpacing(.leading)
                    .padding(.leading)

                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        WeekView(week)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: CGFloat(100 + 30 * projectList.count))
            })
            
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.system(size: 13))
                        .fontWeight(.regular)
                        .foregroundStyle(.black)
                    
                    Text(day.date.format("d"))
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .black)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 35, height: 35)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.white)
                        .frame(width: 35, height: 35)
                    
                    MileStoneView(day)
                }
                .hSpacing(.center)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                        print(currentDate)
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 0 && createWeek {
                            print("Generate")
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date,
               currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPrieviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date,
               currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}


/// MileStone View - Connected To Vertical Calendar
extension Home {
    @ViewBuilder
    func MileStoneView(_ day: Date.WeekDay) -> some View {
        VStack {
            ForEach(projectList, id: \.id) { pd in
                MileStoneComponent(color: Color(hex: pd.projectColor),direction: .line)
                    .padding(.top, 10)
            }
        }
    }
}


/// TodoList View
extension Home {
    @ViewBuilder
    func TodoListView() -> some View {
        List{
            ForEach(projectList, id: \.id) { project in
                ProjectTitle(projectData: project)
                ProjectTodoListView(project)
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    func ProjectTodoListView(_ project: ProjectModel) -> some View {
        ForEach(project.todoLists, id: \.id) { todo in
            if !todo.isKilled {
                if !todo.isFinished {
                    ProjectTodo(todoData: todo)
                } else if todo.finishedDate?.format("YYYYMMdd") == currentDate.format("YYYYMMdd") {
                    ProjectTodo(todoData: todo)
                }
            }
        }
    }
}
