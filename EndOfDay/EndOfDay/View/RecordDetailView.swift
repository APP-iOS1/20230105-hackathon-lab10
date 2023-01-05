//
//  RecodeDetailView.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/13.
//

import SwiftUI

struct RecordDetailView: View {
    @StateObject var commentStore: CommentStore = CommentStore()
    @StateObject var imageStore: ImageStore = ImageStore()
//    @State var photo: [UIImage] = []
//    @State var retrievedImages = [UIImage]()
    
    var record: Record
    var body: some View{
        VStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("\(record.userNickName) | ")
                            .frame(height: 43, alignment: .top)
                        Text(record.recordTitle)
                            .frame(height: 43, alignment: .top)
                        Spacer()
                        
                    }
                    .font(.subheadline)
                    .bold()
                    
                    HStack {
                        Spacer()
                        Text("\(record.createdDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    Text(record.recordContent)
                    Spacer()
                    ForEach(imageStore.images,id: \.self){ photo in
                        Image(uiImage: photo)
                            .resizable()
                            .frame(width: 300, height: 300)
                    }
                    Divider()
                }
                .padding()
                .padding(.bottom, -10)
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: 400, maxHeight: .infinity, alignment: .leading)
                .navigationTitle("일기")
                ForEach(commentStore.comments) { comment in
                    CommentListCell(comment: comment)
                    Divider()
                }
            }
        }
        .onAppear{
            commentStore.recordID = record.id
            commentStore.fetchComments()
            imageStore.retrievePhotos(record)
//            print(photo)
        }
        .refreshable {
            commentStore.recordID = record.id
            commentStore.fetchComments()
        }
        AddingCommentView(commentStore: commentStore, record: record)
    }
}

struct CommentListCell: View{
    var comment: Comment
    var body: some View {
        VStack {
            HStack{
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                Text("\(comment.userNickName)")
                Text(comment.createdDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                
            }
            HStack {
                Text(comment.commentContent)
                Spacer()
            }
            
            HStack {
                Spacer()
                
            }
        }.padding()
        
    }
}

//struct RecordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            RecordDetailView(record: Record(id: "123123", recordTitle: "프리뷰야 보여라", recordContent: "여기도 회색이 되어버렸네요", createdAt: 1.1, userID: "ted123123", userNickName: "Ned"))
//        }
//    }
//}
