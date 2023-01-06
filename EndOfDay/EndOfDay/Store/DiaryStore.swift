//
//  DiaryStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class DiaryStore: ObservableObject {
    @Published var diaries: [Diary] = []
    @Published var privateDiary: Diary = Diary(id: "", dairyTitle: "", colorIndex: 0, createdAt: 0, membersID: [], membersNickname: [""])
    
    lazy var userID = Auth.auth().currentUser?.uid ?? ""
    lazy var userNickname = Auth.auth().currentUser?.displayName ?? ""
    
    let database = Firestore.firestore().collection("Diaries")
    
    // MARK: Diary 불러오기
    func fetchDiaries() async {
        do {
            print("fetch")
            diaries.removeAll()
            if userID != "" {
                let snapshot = try await database.whereField("membersID", arrayContains: userID).getDocuments()
                
                for document in snapshot.documents {
                    let docData = document.data()
                    let id: String = document.documentID
                    let diaryTitle: String = docData["diaryTitle"] as? String ?? ""
                    let colorIndex: Int = docData["colorIndex"] as? Int ?? 0
                    let createdAt: Double = docData["createdAt"] as? Double ?? 0
                    let membersID: [String] = docData["membersID"] as? [String] ?? []
                    let membersNickname: [String] = docData["membersNickname"] as? [String] ?? []
                    let diary: Diary = Diary(id: id,dairyTitle: diaryTitle, colorIndex: colorIndex, createdAt: createdAt, membersID: membersID, membersNickname: membersNickname)
                    if id == userID{
                     privateDiary = diary
                    } else {
                        self.diaries.append(diary)
                    }
                }
            }
            self.diaries = diaries.sorted{ $0.createdAt > $1.createdAt}
            print(privateDiary)
            print(diaries)
            
        } catch{
            fatalError()
        }
        
    }
    // MARK: 개인 Diary 만들기
    func addPrivateDiary(userID: String, nickName: String) async {
        do {
            let time = Date().timeIntervalSince1970
            try await database.document(userID)
                .setData([
                    "diaryTitle": "\(nickName)님의 일기장",
                    "colorIndex": 2,
                    "createdAt": time,
                    "membersID" : [userID],
                    "membersNickname" : [nickName]])
            
            await fetchDiaries()
        } catch {
            fatalError()
        }
    }
    
    // MARK: Diary 만들기
    func addDiary(diary: Diary) async {
        do {
            print("add")
            try await database.document(diary.id)
                .setData([
                    "diaryTitle": diary.dairyTitle,
                    "colorIndex": diary.colorIndex,
                    "createdAt": diary.createdAt,
                    "membersID" : diary.membersID,
                    "membersNickname" : diary.membersNickname])
            
            await fetchDiaries()
        } catch {
            fatalError()
        }
    }
    
    // MARK: Diary 초대 수락(그룹 들어가기) - 에러처리 필요
    // 초대코드를 입력하고 버튼을 눌렀을때 실행된다
    func joinDiary(diaryID: String) async {
        do {
            let document = try await database.document(diaryID).getDocument()
            guard let docData = document.data() else {return }
            
            // 기존 uid배열에 지금 입력받은 아이디를 추가해준다.
            var membersID: [String] = docData["membersID"] as? [String] ?? []
            membersID.append(userID)
            var membersNickname: [String] = docData["membersNickname"] as? [String] ?? []
            membersNickname.append(userNickname)
            
            try await database.document(diaryID)
                .updateData([
                    "membersID" : membersID,
                    "membersNickname": membersNickname])

            await fetchDiaries()
        } catch {
            fatalError()
        }
    }
    
    // MARK: Diary 수정하기
    func editDiary(diary: Diary) async {
        do {
            try await database.document(diary.id)
                .setData([
                    "diaryTitle": diary.dairyTitle,
                    "colorIndex": diary.colorIndex,
                    "createdAt": diary.createdAt,
                    "membersID" : diary.membersID])
            await fetchDiaries()
        } catch {
            fatalError()
        }
    }
    
    // MARK: Diary 나가기
    func outDiary(diaryID: String) async {
        do {
            let document = try await database.document(diaryID).getDocument()
            guard let docData = document.data() else {return }
            
            // 기존 uid배열에 지금 입력받은 아이디를 삭제해준다.
            var membersID: [String] = docData["membersID"] as? [String] ?? []
            var membersNickname: [String] = docData["membersNickname"] as? [String] ?? []
            guard let removeIndex = membersID.firstIndex(of: userID) else { return }
            membersID.remove(at: removeIndex)
            membersNickname.remove(at: removeIndex)
            
            if membersID.isEmpty { // 마지막 사람이 나간경우 일기장을 삭제
                await deleteDiary(diaryID)
            } else {
                try await database.document(diaryID)
                    .updateData([
                        "membersID" : membersID])
            }
            
            await fetchDiaries()
            
        } catch {
            fatalError()
        }
    }
    
    // MARK: Diary 삭제
    func deleteDiary(_ diaryID: String) async {
        do {
            try await database.document(diaryID).delete()
        } catch {
            fatalError()
        }
    }
}
