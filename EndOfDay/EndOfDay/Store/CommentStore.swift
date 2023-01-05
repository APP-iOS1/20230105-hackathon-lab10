//
//  commentStore.swift
//  EndOfDay
//
//  Created by MIJU on 2022/12/13.
//

import Foundation
import FirebaseFirestore

class CommentStore: ObservableObject {
    @Published var comments: [Comment] = []
    
//    var diaryId: String = ""
    var recordID: String = ""
    
    let database = Firestore.firestore().collection("Records")
    
    func fetchComments() {
        database.document(recordID).collection("Comments")
            .getDocuments { (snapshot, error) in
                self.comments.removeAll()
                if let snapshot {
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
                }
            }
    }
    
    func addComment(_ comment: Comment){
        database.document(recordID).collection("Comments").document(comment.id)
            .setData([
                "commentContent": comment.commentContent,
                "userID": comment.userID,
                "createdAt": comment.createdAt,
                "userNickName": comment.userNickName])
                
        fetchComments()
    }
    
    func removeComment(_ comment: Comment){
        database.document(recordID).collection("Comments").document(comment.id).delete()
        fetchComments()
    }
}
