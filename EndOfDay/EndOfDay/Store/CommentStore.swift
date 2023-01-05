//
//  commentStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import Foundation
import FirebaseFirestore

@MainActor
class CommentStore: ObservableObject {
    @Published var comments: [Comment] = []
    
    var diaryID: String = ""
    var recordID: String = ""
    
    let database = Firestore.firestore().collection("Diaries")
    // MARK: 댓글 불러오기
    func fetchComments() async {
        do {
            if diaryID != "" && recordID != ""{
                let snapshot = try await database.document(diaryID).collection("Records").document(recordID).collection("Comments").getDocuments()
                self.comments.removeAll()
                for document in snapshot.documents{
                    let docData = document.data()
                    let id: String = document.documentID
                    let commentContent: String = docData["commentContent"] as? String ?? ""
                    let createdAt: Double = docData["createdAt"] as? Double ?? 0
                    let userID: String = docData["userID"] as? String ?? ""
                    let userNickName: String = docData["userNickName"] as? String ?? ""
                    
                    let comment: Comment = Comment(id: id, commentContent: commentContent, createdAt: createdAt, userID: userID, userNickName: userNickName)
                    
                    self.comments.append(comment)
                }
                self.comments = comments.sorted{ $0.createdAt > $1.createdAt }
            }
        }catch {
            fatalError()
        }
    }
    
    // MARK: 댓글 추가하기
    func addComment(_ comment: Comment) async{
        do{
            if diaryID != "" && recordID != ""{
                try await database.document(diaryID).collection("Records").document(recordID).collection("Comments").document(comment.id)
                    .setData([
                        "commentContent": comment.commentContent,
                        "userID": comment.userID,
                        "createdAt": comment.createdAt,
                        "userNickName": comment.userNickName])
                await fetchComments()
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: 댓글 삭제하기
    func removeComment(commentID: String) async {
        do {
            if diaryID != "" && recordID != ""{
                try await database.document(diaryID).collection("Records").document(recordID).collection("Comments").document(commentID).delete()
                await fetchComments()
            }
        } catch {
            fatalError()
        }
    }
}
