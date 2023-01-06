//
//  DiaryListView.swift
//  EndOfDay
//
//  Created by 조운상 on 2023/01/05.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct RecordListView: View {
    @StateObject private var recordStore: RecordStore = RecordStore()
    @State var currentDate: Date = Date()
    var diary: Diary
    private let duration = 0.5
    @State var isShowingCalendar: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Text(diary.dairyTitle)
                        .font(.largeTitle)
                    Spacer()
                    Button {
                        withAnimation(.easeIn(duration: duration)) {
                            isShowingCalendar.toggle()
                        }
                    } label: {
                        Image(systemName: "calendar")
                        Text("\(currentDate.formatted(.dateTime.day().month()))")
                
                    }
                    .padding(.horizontal, 3)
                    .foregroundColor(.white)
                    .frame(width: 110, height: 35)
                    .background(Color.myLightGreen)
                    .cornerRadius(10)

                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Custom Date Picker
                        CustomDatePicker(isShowingCalendar: $isShowingCalendar, currentDate: $currentDate, diaryID: diary.id)
                    }
                    .padding(.vertical)
                }
                .padding(.top, -20)
                

//                ScrollView {
//                    ForEach(recordStore.records) { record in
//                        NavigationLink {
//                            DiaryCellView(record: record)
//                        } label: {
//                            DiaryCellView(record: record)
//                        }
//                    }
//                }
            }
           
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        WriteDetailView()
                    } label: {
                        Image(systemName: "square.and.pencil")
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingView(diary: diary)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            Task {
                recordStore.diaryID = diary.id
               await recordStore.fetchRecords()
            }
        }
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(diary: Diary(id: "dd", dairyTitle: "타이틀", colorIndex: 1, createdAt: 1, membersID: [], membersNickname: []))
    }
}
