//
//  DiaryListView.swift
//  EndOfDay
//
//  Created by 이재희 on 2023/01/05.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct DiaryListView: View {
    @StateObject private var recordStore: RecordStore = RecordStore()
    @Namespace var animation
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Text("그룹명")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    // MARK: Lazy Stack with Pinned Header
                    LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                        Section {
                            
                            // MARK: Current Week View
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 10) {
                                    
                                    ForEach(recordStore.currentWeek, id: \.self) { day in
                                        
                                        VStack(spacing: 10) {
                                            
                                            Text(recordStore.extractDate(date: day, format: "EEE"))
                                                .font(.system(size: 14))
                                            
                                            Text(recordStore.extractDate(date: day, format: "dd"))
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                            
                                            
                                            //MARK: Foreground Style
                                            //                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                                .foregroundColor(recordStore.isToday(date: day) ? .white : .black)
                                            //MARK: Circle Shape
                                                .frame(width: 50, height: 50)
                                                .background(
                                                    
                                                    ZStack {
                                                        //MARK: Matched Geometry Effect
                                                        if recordStore.isToday(date: day) {
                                                            Circle()
                                                                .fill(.black)
                                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                                        }
                                                    }
                                                
                                                )
                                            
//                                            VStack {
//                                                ForEach(checkDate(seminars: seminarStore), id: \.self) { date in
//                                                    if date == seminarStore.extractDate(date: day, format: "dd") {
//                                                        Circle()
//                                                            .fill(.red)
//                                                    }
//                                                }
//                                            }
//                                            .frame(width: 5, height: 5)
                                        }
                                        .contentShape(Capsule()) //??
                                        .onTapGesture {
                                            //Updating Current Day
                                            withAnimation {
                                                recordStore.currentDay = day
                                            }
                                        }
                                    }
                                    
                                }//HStack
                                .padding()
                            }//ScrollView
                            
//                            TaskView()
//                                .padding(.bottom, 20)
                            
                        } header: {
                            //  HeaderView()
                        }
                    }
                }
                .onAppear {
                    recordStore.fetchRecords()
                }
                
                
                ScrollView {
                    ForEach(recordStore.records) { record in
                        NavigationLink {
                            DiaryCellView(record: record)
                        } label: {
                            DiaryCellView(record: record)
                            //                            .frame(height: 600)
                        }
                    }
                }
                //            .navigationBarTitle("타이틀")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        //                    WriteDetailView(recordeStore: recordStore)
                    } label: {
                        Image(systemName: "square.and.pencil")
               
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        //                    WriteDetailView(recordeStore: recordStore)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            recordStore.fetchRecords()
        }
    }
    
    // MARK: Task View
    // 해당날짜에 해당하는 일기들을 보여주는 view
//    func TaskView() -> some View {
//
//        LazyVStack(spacing: 18) {
//
//            if let tasks = seminarStore.filteredSeminar {
//
//                if tasks.isEmpty {
//                    Text("오늘 세미나 없음")
//                        .font(.system(size: 16))
//                        .fontWeight(.light)
//                } else if tasks.count == 1 {
//
//                    HStack {
//                        Text(tasks[0].createdDate)
//                            .padding(.leading, 15)
//
//                        Spacer()
//                    }
//
//                    PagingView(config: .init(margin: 20, spacing: 10)) {
//                        ForEach(tasks) { task in
//                            SeminarRowView(seminar: task, userStore: userStore, selectedTab: $selectedTab)
//                        }
//                    }
//                    .mask(RoundedRectangle(cornerRadius: 10))
//                    .aspectRatio(1.35, contentMode: .fit)
//
//                } else {
//
//                        HStack {
//                            Text(tasks[0].createdDate)
//                                .padding(.leading, 15)
//
//                            Spacer()
//                        }
//
//                    PagingView(config: .init(margin: 20, spacing: 20)) {
//                        ForEach(tasks) { task in
//                            SeminarRowView(seminar: task, userStore: userStore, selectedTab: $selectedTab)
//                        }
//                    }
//                    .mask(RoundedRectangle(cornerRadius: 10))
//                    .aspectRatio(1.35, contentMode: .fit)
//                }
//
//            } else {
//                //MARK: Progress View
//                ProgressView()
//                    .offset(y: 100)
//            }
//
//        }
//        //MARK: Updating Tasks
//        .onChange(of: seminarStore.currentDay) { newValue in
//            seminarStore.filterTodayTasks()
//        }
//    }
}


struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
}
