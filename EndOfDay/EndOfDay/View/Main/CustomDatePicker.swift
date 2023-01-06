//
//  CustomDatePicker.swift
//  EndOfDay
//
//  Created by 조운상 on 2023/01/05.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var isShowingCalendar: Bool
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    @StateObject var recordStore: RecordStore = RecordStore()
    var diaryID: String
    
    var body: some View {
        VStack{
            if isShowingCalendar {
                VStack(spacing: 35) {
                    // Days
                    let days = ["일", "월", "화", "수", "목", "금", "토"]
                    
                    HStack(spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(extraDate()[0])
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text(extraDate()[1])
                                .font(.title.bold())
                        }
                        
                        Spacer()
                        
                        Button {
                                currentMonth -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2 )
                        }
                        
                        Button {
                                currentMonth += 1
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Day View...
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    //Date
                    // Lazy Grid..
                    //MARK: 현재 달력의 날짜들
                    let columns = Array(repeating: GridItem(.flexible()), count: 7)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(extractDate()) { value in
                            CardView(value: value)
                                .background(
                                    Capsule()
                                        .fill(Color.orange)
                                        .padding(.horizontal, 8)
                                        .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                        .offset(y: -18)
                                )
                                .onTapGesture {
                                    currentDate = value.date
                                }
                        }
                    }
                } ///
                .onChange(of: currentMonth) { newValue in
                    // update month
                    currentDate = getCurrentMonth()
                }
            }
            else {
               
            }
            
            //MARK: 특정날짜에 작성된 일기리스트, 여기서 DiaryCellView보여주기
            // TODO: - 일기 기록이 없는 경우의 텍스트 보여주기
            VStack(spacing: 15) {
                Text("Diaries")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                let filteredRecords = recordStore.records.filter { record in
                                    return isSameDay(date1: Date(timeIntervalSince1970: record.createdAt), date2: currentDate)
                                }
                

                if !filteredRecords.isEmpty {
                    ForEach(recordStore.records.filter { record in
                        return isSameDay(date1: Date(timeIntervalSince1970: record.createdAt), date2: currentDate)
                    }) { record in
                        NavigationLink {
                            DiaryDetailView()
                        } label: {
                            DiaryCellView(record: record)
                        }
                    }
                }
                else {
                    Text("작성한 일기가 없습니다.")
                }
            }.onAppear {
                Task {
                    recordStore.diaryID = diaryID
                    await recordStore.fetchRecords()
                }
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                
                if let diaries = recordStore.records.first(where: { diary in
                    return isSameDay(date1: Date(timeIntervalSince1970: diary.createdAt), date2: value.date)
                }) {
                    
                    //MARK: 일기가 있는 날짜와, 사용자가 클릭한 날짜가 같으면 해당 날짜의 텍스트 색깔을 바꿔준다
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: Date(timeIntervalSince1970: diaries.createdAt), date2: currentDate) ? .blue : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    //MARK: 일기가 있는 날짜와, 사용자가 클릭한 날짜가 같으면 일정이 있음을 표시해주는 Circle()색이 바뀐다
                    //if 해당 날자에 레코트 데이터가 있으면 이걸 보여주고
                    Circle()
                        .fill(isSameDay(date1: Date(timeIntervalSince1970: diaries.createdAt), date2: currentDate) ? .white : Color.red )
                        .frame(width: 8, height: 8)
                        .offset(y: -20)
                    
                    //없으면 보여주지 마라
                } else {
                    //MARK: 사용자가 클릭한 날짜의 색상을 바꿔준다
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date , date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, -10)
        .frame(height: 40, alignment: .top)
        
    }
    // Checking dates
    //MARK: DATE타입 인자 두 개를 받아서 오늘날짜인지 Bool타입으로 리턴해주는 함수
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    // Extraing year and month for display
    // MARK: 현재의 년도와, 월을 뷰에 표시하기위한 함수
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    // MARK: 현재날짜를 기준으로 해당 날짜가 속한 월을 반환하는 함수
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting Current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    //MARK: 정확한 날짜값을 추출하기위한 함수
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // Getting Current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(isShowingCalendar: .constant(true), currentDate: .constant(Date()), diaryID: "0A16CC1D-FBDC-4509-822F-64B42B999235")
    }
}

extension Date {
    //MARK: 달력(한달)의 모든 날짜들을 반환하는 함수
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // geting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
    }
}
