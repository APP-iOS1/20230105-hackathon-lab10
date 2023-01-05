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
