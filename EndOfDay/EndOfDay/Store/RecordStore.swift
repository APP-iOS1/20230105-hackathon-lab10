//
//  RecordStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import Foundation
import FirebaseFirestore

class RecordStore: ObservableObject {
    @Published var records: [Record] = []
    
//    var diaryID: String = ""
    
    let database = Firestore.firestore().collection("Records")
    
    
    func fetchRecords() {
        database
            .getDocuments { (snapshot, error) in
                self.records.removeAll()
                if let snapshot {
                    for document in snapshot.documents{
                        let docData = document.data()
                        let id: String = document.documentID
                        let recordTitle: String = docData["recordTitle"] as? String ?? ""
                        let recordContent: String = docData["recordContent"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        
//                        let createdAtTimeStamp: Timestamp = docData["createdAt"] as? Timestamp ?? Timestamp()
                        
                        // 그런데 Timestamp형식을 그대로 쓸 수는 없고,
                        // 우리의 Swift가 제공하는 기본 Date 형식으로 바꿔서 꺼야써야겠다
//                        let createdAt: Date = createdAtTimeStamp.dateValue()
                        
//                        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
                        
                        
                        let userID: String = docData["userID"] as? String ?? ""
                        let userNickName: String = docData["userNickName"] as? String ?? ""
                        let photos: String = docData["photos"] as? String ?? ""
                        let record: Record = Record(id: id, recordTitle: recordTitle, recordContent: recordContent, createdAt: createdAt, userID: userID, userNickName: userNickName, photos: photos)
                        
                        self.records.append(record)
                    }
                }
            }
    }
    
    func addRecord(_ record: Record){
        database
            .document(record.id)
            .setData([
                "recordTitle": record.recordTitle,
                "recordContent": record.recordContent,
                "userID": record.userID,
                "createdAt": record.createdAt,
                "userNickName": record.userNickName,
                "photos": record.photos ?? ""])
        fetchRecords()
    }
    
    func removeRecord(_ record: Record){
        database
            .document(record.id).delete()
        fetchRecords()
    }
    
    
    //MARK: Current week Days
    @Published var currentWeek: [Date] = []

    //MARK: Current Day
    @Published var currentDay: Date = Date()

    //MARK: Filtering Today Tasks
    @Published var filteredDiary: [Record]?

    //MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayDiaries()
    }

    func filterTodayDiaries() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.records.filter {
                //                Date()
    //            print($0.date)
                
                let dateCreatedAt = Date(timeIntervalSince1970: $0.createdAt)
                
                return calendar.isDate(dateCreatedAt, inSameDayAs: self.currentDay)
            }//taskDate의 타임인터벌 값만 잘 가져오면 비교도 알아서 됨!
            
            DispatchQueue.main.async {
//                withAnimation {
                    self.filteredDiary = filtered
//                }
            }
        }
        
    }

    func fetchCurrentWeek() {
        
        //604800
        
        let today = Date() - 604800
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekday, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0...6).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day + 1, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
            
        }
    }

    //MARK: Extracting Date

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
        
    }

    //MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        //self.currentDay
        return calendar.isDate(currentDay, inSameDayAs: date)
        
    }

}


