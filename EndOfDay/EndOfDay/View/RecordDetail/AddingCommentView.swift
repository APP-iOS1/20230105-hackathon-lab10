
import SwiftUI

struct AddingCommentView: View {//
    @StateObject var commentStore : CommentStore
    @State var commentText: String = ""
    let record: Record
    
    var trimCommet: String {
        commentText.trimmingCharacters(in: .whitespaces)
    }
    var body: some View {
        HStack {
            TextField("댓글을 입력해주세요", text: $commentText, axis: .vertical)
            
            if trimCommet.count > 0 {
                Button {
                    let comment: Comment = Comment(id: UUID().uuidString, commentContent: commentText, createdAt: Date().timeIntervalSince1970, writerID: "", userNickName: "")
                    commentStore.recordID = record.id
                    Task{
                        await commentStore.addComment(comment)
                    }
                    commentText = ""
                } label: {
                    Text("저장")
                }
            }
        }
        .padding()
    }
}

struct AddingCommentView_Previews: PreviewProvider {
    static var previews: some View {
        AddingCommentView(commentStore: CommentStore(), record: Record(id: "123123", recordTitle: "프리뷰야 보여라", recordContent: "여기도 회색이 되어버렸네요", createdAt: 1.1, writerID: "ted123123", userNickName: "Ned"))
    }
}

