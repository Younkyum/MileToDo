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
    @State var isProjectDetailSheetAppear: Bool = false
    @State var isTodoDetailSheetAppear: Bool = false
    
    @Query(filter: #Predicate<ProjectModel> { project in
        project.isSelected == true
    }, sort: \ProjectModel.orderIndex)
    var projectList: [ProjectModel]
    
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
        .sheet(isPresented: $isProjectDetailSheetAppear, content: {
            ProjectDetail(isProjectDetailSheetAppear: $isProjectDetailSheetAppear)
        })
        .sheet(isPresented: $isTodoDetailSheetAppear) {
            TodoDetail(isTodoDetailSheetAppear: $isTodoDetailSheetAppear)
        }
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
            HStack(alignment: .center) {
                Text(currentDate.format("M"))
                    .font(.system(size: 34, weight: .bold))
                    .hSpacing(.leading)
                    .padding([.leading])
                    .padding([.bottom], 8)
                
                Button { // TodoDetailSheet
                    isTodoDetailSheetAppear = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundStyle(.textBlack)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 16)
                }
                
                Button { // ProjectDetailSheet
                    isProjectDetailSheetAppear = true
                } label: {
                    Image(systemName: "filemenu.and.selection")
                        .resizable()
                        .foregroundStyle(.textBlack)
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                }
                
            }
            
            VStack(spacing: 0, content: {
                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        WeekView(week)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: CGFloat(90 + 30 * projectList.count))
                
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
                        .foregroundStyle(.textBlack)
                    
                    Text(day.date.format("d"))
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .backgroundWhite : .textBlack)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.textBlack)
                                    .frame(width: 35, height: 35)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.textBlack)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.backgroundWhite)
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
            ForEach(projectList, id: \.id) { project in
                let dayString = day.date.format("YYYYMMdd")
                let firstProjectDayString = project.dateLists.first!
                let lastProjectDayString = project.dateLists.last!
                
                if lastProjectDayString < dayString || firstProjectDayString > dayString {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .none)
                } else if firstProjectDayString == lastProjectDayString && dayString == firstProjectDayString  {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .only)
                } else if firstProjectDayString == dayString {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .right)
                } else if lastProjectDayString == dayString {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .left)
                } else if project.dateLists.contains(dayString) {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .full)
                } else {
                    MileStoneComponent(color: Color(hex: project.projectColor), direction: .line)
                }
            }
        }
    }
}


/// TodoList View
extension Home {
    @ViewBuilder
    func TodoListView() -> some View {
        List{
            
            HStack {
                Text("\(currentDate.format("YYYY.M.d (E)"))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textBlack)
                
                Text("\(currentDate.lunarFormat())")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
            }
            
            
            
            ForEach(projectList, id: \.id) { project in
                ProjectTitle(projectData: project)
                ProjectTodoListView(project)
            }
            
            Rectangle()
                .fill(.backgroundWhite)
                .listRowSeparator(.hidden)
                .frame(height: 80)
            
        }
        .listStyle(.plain)
        .scrollIndicators(.never)
    }
    

    
    @ViewBuilder
    func ProjectTodoListView(_ project: ProjectModel) -> some View {
        ForEach(project.todoLists.sorted(by: ascendingTodo(_:_:)), id: \.id) { todo in
            if !todo.isKilled {
                if !todo.isFinished {
                    ProjectTodo(todoData: todo, selectedDate: $currentDate)
                } else if todo.finishedDate?.format("YYYYMMdd") == currentDate.format("YYYYMMdd") {
                    ProjectTodo(todoData: todo, selectedDate: $currentDate)
                }
            }
        }
    }
    
    func ascendingTodo(_ lhs: TodoModel, _ rhs: TodoModel) -> Bool {
        return lhs.deadLineDate < rhs.deadLineDate
    }
}


