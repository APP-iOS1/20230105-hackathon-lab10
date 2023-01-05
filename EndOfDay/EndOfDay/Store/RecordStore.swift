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
            if !diaryID.isEmpty {
                let snapshot = try await database.document(diaryID).collection("Records").getDocuments()
                for document in snapshot.documents {
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
                        let fileRef = storageRef.child("images/\(photoID).jpg")
                        let imageData = try await fileRef.data(maxSize: 5*1024*1024)
                        photo = UIImage(data: imageData) ?? UIImage()
                    }
                    let record: Record = Record(id: id, recordTitle: recordTitle, recordContent: recordContent, createdAt: createdAt, userID: userID, userNickName: userNickName, photoID: photoID, photo: photo)
                    self.records.append(record)
                }
            }
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
}
