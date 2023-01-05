

import SwiftUI

struct WriteDetailView: View {//
    @EnvironmentObject private var userStore: UserStore
    
    @State private var recordTitle: String = ""
    @State private var recordContent: String = ""
    
    @State var isPickerShowing: Bool = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    
    var recordeStore: RecordStore
    var imageStore: ImageStore = ImageStore()
    
    var trimTitle: String {
        recordTitle.trimmingCharacters(in: .whitespaces)
    }
    var trimContent: String {
        recordContent.trimmingCharacters(in: .whitespaces)
    }
    var body: some View {
        VStack {
            TextField("일기 제목을 입력해주세요", text: $recordTitle, axis: .vertical)
            Divider()
            TextField("오늘은 어떤 하루 였나요? \n 친구들에게 하고 싶은 말을 마음껏 적어주세요", text: $recordContent, axis: .vertical)
            Spacer()
        }.padding()
            .navigationTitle("일기 쓰기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        isPickerShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                })
                if trimTitle.count > 0 && trimContent.count > 0 {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button {
                            //TODO: userID, userNickName user정보에서 가져오기
                            let createdAt = Date().timeIntervalSince1970
                            let imageId = imageStore.uploadPhoto(selectedImage)
                            let record = Record(
                                id: UUID().uuidString,
                                recordTitle: recordTitle,
                                recordContent: recordContent,
                                createdAt: createdAt,
                                userID: userStore.user?.uid ?? "",
                                userNickName: userStore.user?.displayName ?? "",
                                photos: imageId)
                            recordeStore.addRecord(record)
                        } label: {
                            Text("완료")
                        }
                    })
                }
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil){
                ImagePicker(image: $selectedImage)
            }
    }
}

struct WriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            WriteDetailView(recordeStore: RecordStore())
        }
    }
}

