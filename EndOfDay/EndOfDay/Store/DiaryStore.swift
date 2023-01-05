//
//  DiaryStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import Foundation
import FirebaseFirestore

class DiaryStore: ObservableObject {
    @Published var diaries: [Diary] = []
    var temp: [Diary] = []
    
    let database = Firestore.firestore().collection("Diaries")
    
    func fetchDiaries() {
        database.getDocuments { (snapshot, error) in
                self.diaries.removeAll()
                if let snapshot {
                    for document in snapshot.documents{
                        let docData = document.data()
                        let id: String = document.documentID
                        let diaryTitle: String = docData["diaryTitle"] as? String ?? ""
                        let colorIndex: Int = docData["colorIndex"] as? Int ?? 0
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        
                        let diary: Diary = Diary(id: id,dairyTitle: diaryTitle, colorIndex: colorIndex, createdAt: createdAt)
                        
                        self.diaries.append(diary)
                    }
                }
            }
    }
    
    func addDiary(_ diary: Diary){
        database.document(diary.id).collection("Records")
            .document(diary.id)
            .setData([
                      "diaryTitle": diary.dairyTitle,
                      "colorIndex": diary.colorIndex,
                      "createdAt": diary.createdAt])
        fetchDiaries()
    }
    
    func removeDiary(_ diary: Diary){
        database.document(diary.id).delete()
        fetchDiaries()
    }
}
