

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct DiaryFeedView: View {//
    @StateObject private var recordStore: RecordStore = RecordStore()
    @EnvironmentObject private var userStore: UserStore
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recordStore.records) { record in
                    NavigationLink {
                        RecordDetailView(record: record)
                    } label: {
                        ListCell(record: record)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Diary Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        WriteDetailView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        userStore.logOut()
                    } label: {
                        Text("로그아웃")
                    }
                }
            }
        }
        //        .sheet(isPresented: $isPickerShowing, onDismiss: nil){
        //            ImagePicker(image: $selectedImage)}
    
        .onAppear {
            Task{
                await recordStore.fetchRecords()
            }
        }
        .refreshable {
            Task{
                await recordStore.fetchRecords()
            }
        }
    }
}

//struct ListCell: View {
//    var record: Record
//    var body: some View {
//        VStack(alignment: .leading, spacing: 7) {
//            HStack {
//                Circle()
//                    .foregroundColor(.black)
//                    .frame(width: 40, height: 40)
//                VStack {
//                    HStack {
//                        Text("\(record.userNickName) |")
//                        Text(record.recordTitle)
//                            .lineLimit(1)
//                    }
//                }
//            }
//            .font(.subheadline)
//            .bold()
//            Text(record.recordContent)
//            HStack {
//                Spacer()
//                Text("\(record.createdDate)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding(.vertical, 5)
//    }
//}
struct DiaryFeedView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryFeedView()
    }
}

