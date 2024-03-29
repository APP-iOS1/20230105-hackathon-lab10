//
//  RecordModifyView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/06.
//

import SwiftUI

struct RecordModifyView: View {
    @EnvironmentObject private var recordStore: RecordStore
    @EnvironmentObject private var userStore: UserStore
    @StateObject private var imageStore: ImageStore = ImageStore()
    @Environment(\.dismiss) private var dismiss
    var record: Record
    @State private var recordTitle: String = ""
    @State private var recordContent: String = ""
    @State var isPickerShowing: Bool = false
    @State var selectedImage: UIImage?
//    @State var retrievedImages = [UIImage]()
//    @State var showingCategory: Bool = false

    @State private var test: String = ""

//    var imageStore: ImageStore = ImageStore()
    
    var trimTitle: String {
        recordTitle.trimmingCharacters(in: .whitespaces)
    }
    var trimContent: String {
        recordContent.trimmingCharacters(in: .whitespaces)
    }
    var body: some View {
        VStack {
            ScrollView {
                TextField("\(record.recordTitle)", text: $recordTitle)
                    .multilineTextAlignment(TextAlignment.center)
//                        .frame(width: 250)
//                        .border(.black)
                Divider()
                    .padding(.horizontal, 80)
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .cornerRadius(5)
                    //                    .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.width - 120)
                        .padding(.vertical, 10)
                }
                
                TextField("\(record.recordContent)", text: $recordContent, axis: .vertical)
                    .padding(10)
                Spacer()
            }
        }.padding()
            .navigationTitle("일기 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        isPickerShowing = true
                    } label: {
                        Image(systemName: "photo")
                            .foregroundColor(.black)
                    }
                })
                

                
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
//                        showingCategory.toggle()
                        let photoID = imageStore.uploadPhoto(selectedImage)
                        
                        let updateRecord: Record = Record(id: record.id, recordTitle: recordTitle, recordContent: recordContent, createdAt: record.createdAt, writerID: record.writerID, userNickName: record.userNickName, photoID: photoID, photo: selectedImage)

                        Task {
//                            recordStore.diaryID = 
                            await recordStore.updateRecord(updateRecord)
                            dismiss()
                        }
                        
                    } label: {
                        Text("완료")
                    }
                    .foregroundColor(trimTitle.isEmpty || trimContent.isEmpty ? .gray : .black)
                    .disabled(trimTitle.isEmpty || trimContent.isEmpty)
                })

            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil){
                ImagePicker(image: $selectedImage)
            }
//            .sheet(isPresented: $showingCategory) {
//                let createdAt = Date().timeIntervalSince1970
//                let imageId = imageStore.uploadPhoto(selectedImage)
//                //TODO: userID, userNickName user정보에서 가져오기
//                let record = Record(
//                    id: UUID().uuidString,
//                    recordTitle: recordTitle,
//                    recordContent: recordContent,
//                    createdAt: createdAt,
//                    writerID: userStore.user?.uid ?? "",
//                    userNickName: userStore.user?.displayName ?? "",
//                    photoID: imageId)
//
//                CategorySelectView(showingSheet: $showingCategory, test: $test, record: record)
//                    .presentationDetents([.medium])
//            }
            .onChange(of: test) { _ in
                dismiss()
            }
    }
}

//struct RecordModifyView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordModifyView()
//    }
//}
