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
    

}

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

//Task
struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}


struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}


func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}


var tasks: [TaskMetaData] = [

    TaskMetaData(task: [
        Task(title: "Talk to iJustine"),
        Task(title: "iPhone 14 Great Design Change😀"),
        Task(title: "Nothing Much Workout !!!")
    ], taskDate:   getSampleDate(offset: 1)),
    
    TaskMetaData(task: [
    Task(title: "Task to Jen Wzarik")
    ], taskDate: getSampleDate(offset: -3)),
    
    TaskMetaData(task: [
    Task(title: "Metting with tim cook")
    ], taskDate: getSampleDate(offset: -8)),
    
    TaskMetaData(task: [
    Task(title: "Next Verion of SwiftUI")
    ], taskDate: getSampleDate(offset: 10)),
    
    
    TaskMetaData(task: [
    Task(title: "Task to Jen Wzarik 222")
    ], taskDate: getSampleDate(offset: -22)),
    
    TaskMetaData(task: [
    Task(title: "Metting with tim cook 222 ")
    ], taskDate: getSampleDate(offset: 15)),
    
    TaskMetaData(task: [
    Task(title: "Next Verion of SwiftUI222 ")
    ], taskDate: getSampleDate(offset: -20)),
    
    TaskMetaData(task: [
    Task(title: "Metting with tim cook 333 ")
    ], taskDate: getSampleDate(offset: 15)),
    
    TaskMetaData(task: [
    Task(title: "Next Verion of SwiftUI 333 ")
    ], taskDate: getSampleDate(offset: -20)),

]
