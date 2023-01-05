//
//  RecordStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class RecordStore: ObservableObject {
    @Published var records: [Record] = []
    
    
    var diaryID: String = ""
    let database = Firestore.firestore().collection("Diaries")
    
    // MARK: Record 불러오기
    func fetchRecords() async {
        do {
            self.records.removeAll()
//            if !diaryID.isEmpty {
                let snapshot = try await database.document("0A16CC1D-FBDC-4509-822F-64B42B999235").collection("Records").getDocuments()
                for document in snapshot.documents {
                    
//                    print("for문 시작")
//                    print(document)
                    
                    let docData = document.data()
                    let id: String = document.documentID
                    let recordTitle: String = docData["recordTitle"] as? String ?? ""
                    let recordContent: String = docData["recordContent"] as? String ?? ""
                    let createdAt: Double = docData["createdAt"] as? Double ?? 0
                    let userID: String = docData["userID"] as? String ?? ""
                    let userNickName: String = docData["userNickName"] as? String ?? ""
                    let photoID: String = docData["photoID"] as? String ?? ""
                    var photo: UIImage = UIImage()
                    let storageRef = Storage.storage().reference()
                    if !photoID.isEmpty {
                        
//                        print("image")
//                        print(recordTitle)
                        
//                        let fileRef = storageRef.child("images/\(photoID).jpg")
//                        let imageData = try await fileRef.data(maxSize: 5*1024*1024)
//                        photo = UIImage(data: imageData) ?? UIImage()
                    }
                    let record: Record = Record(id: id, recordTitle: recordTitle, recordContent: recordContent, createdAt: createdAt, userID: userID, userNickName: userNickName, photoID: photoID, photo: photo)
                    self.records.append(record)
                }
//            }
                self.records = records.sorted{ $0.createdAt > $1.createdAt}
            } catch{
        }
    }
    
    // MARK: Record 추가하기
    func addRecord(record: Record, diariesID: [String]) async {
        do {
            for diaryID in diariesID{
                if !diaryID.isEmpty {
                    try await database.document(diaryID).collection("Records").document(record.id)
                        .setData([
                            "recordTitle": record.recordTitle,
                            "recordContent": record.recordContent,
                            "userID": record.userID,
                            "createdAt": record.createdAt,
                            "userNickName": record.userNickName,
                            "photoID": record.photoID ?? ""])
                }
            }
            await fetchRecords()
        } catch{
            fatalError()
        }
    }

    // MARK: Record 수정하기
    func updateRecord(_ record: Record) async {
        do {
            let snapshot = try await database.getDocuments()
            var diariesID: [String] = []
            for document in snapshot.documents {
                diariesID.append(document.documentID)
            }
            
            for diaryID in diariesID {
                if !diaryID.isEmpty {
                    try await database.document(diaryID).collection("Records").document(record.id)
                        .updateData([
                            "recordTitle": record.recordTitle,
                            "recordContent": record.recordContent,
                            "userID": record.userID,
                            "createdAt": record.createdAt,
                            "userNickName": record.userNickName,
                            "photoID": record.photoID ?? ""])
                }
            }
            
            await fetchRecords()
        } catch{
            fatalError()
        }
    }


    // MARK: Record 삭제하기 - 수정필요 사용금지
    func removeRecord(recordID: String) async {
        do{
            let snapshot = try await database.getDocuments()
            var diariesID: [String] = []
            for document in snapshot.documents {
                diariesID.append(document.documentID)
            }
            
            //for diaryID in diariesID {
                if !diaryID.isEmpty {
                    try await database.document(diaryID).collection("Record").document(recordID).delete()
                    await fetchRecords()
                }
            //}
        } catch{
            fatalError()
        }
    }
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()

    //MARK: Filtering Today Records
    @Published var filteredRecord: [Record]?
    
    //MARK: Initializing
    init() {
        filterTodayRecords()
    }
    
    func filterTodayRecords() {
        
//        DispatchQueue.global(qos: .userInteractive).async {
        Task {
            
            let calendar = Calendar.current
            
            //            Task {
            //               await recordStore.fetchRecords()
            //            }
            
            let filtered = self.records.filter {
                //                Date()
                //                print($0.date)
                let dateCreatedAt = Date(timeIntervalSince1970: $0.createdAt)
                
                return calendar.isDate(dateCreatedAt, inSameDayAs: self.currentDay)
            }//taskDate의 타임인터벌 값만 잘 가져오면 비교도 알아서 됨!
            
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredRecord = filtered
                }
            }
        }
//        }
        
    }
}


struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

//Task
struct Work: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}


struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Work]
    var taskDate: Date
}


func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}


var tasks: [TaskMetaData] = [

    TaskMetaData(task: [
        Work(title: "Talk to iJustine"),
        Work(title: "iPhone 14 Great Design Change😀"),
        Work(title: "Nothing Much Workout !!!")
    ], taskDate:   getSampleDate(offset: 1)),
    
    TaskMetaData(task: [
        Work(title: "Task to Jen Wzarik")
    ], taskDate: getSampleDate(offset: -3)),
    
    TaskMetaData(task: [
        Work(title: "Metting with tim cook")
    ], taskDate: getSampleDate(offset: -8)),
    
    TaskMetaData(task: [
        Work(title: "Next Verion of SwiftUI")
    ], taskDate: getSampleDate(offset: 10)),
    
    
    TaskMetaData(task: [
        Work(title: "Task to Jen Wzarik 222")
    ], taskDate: getSampleDate(offset: -22)),
    
    TaskMetaData(task: [
        Work(title: "Metting with tim cook 222 ")
    ], taskDate: getSampleDate(offset: 15)),
    
    TaskMetaData(task: [
        Work(title: "Next Verion of SwiftUI222 ")
    ], taskDate: getSampleDate(offset: -20)),
    
    TaskMetaData(task: [
        Work(title: "Metting with tim cook 333 ")
    ], taskDate: getSampleDate(offset: 15)),
    
    TaskMetaData(task: [
        Work(title: "Next Verion of SwiftUI 333 ")
    ], taskDate: getSampleDate(offset: -20)),

]
