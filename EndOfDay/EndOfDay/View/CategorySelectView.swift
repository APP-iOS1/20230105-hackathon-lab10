//
//  CategorySelectView.swift
//  EndOfDay
//
//  Created by MIJU on 2023/01/06.
//

import SwiftUI
import AlertToast

struct CategorySelectView: View {
//    @State private var diariesID: [Int] = []
    @State private var diariesID: [String] = []
    @Binding var showingSheet : Bool
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var imageStore: ImageStore
    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var recordStore: RecordStore
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingPopup = false
    var record: Record
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(diaryStore.diaries) {  diary in
                    HStack {
                        Button(action: {
                            if diariesID.contains(diary.id) {
                                diariesID.remove(at: diariesID.firstIndex(of: diary.id) ?? 0)
                                
                            } else {
                                diariesID.append(diary.id)
                            }
                            print(diariesID)
                        }) {
                            Image(systemName: diariesID.contains(diary.id) ? "checkmark.square.fill" : "square")
                                .foregroundColor(diariesID.contains(diary.id) ? Color(UIColor.systemBlue) : Color.secondary)
                        }
                        Text(diary.dairyTitle)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button() {
                        showingSheet.toggle()
                        isShowingPopup = true
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                          // 1초 후 실행될 부분
                            dismiss()
                        }
                        Task{
                            await recordStore.addRecord(record:record, diariesID: diariesID)
                        }
                    } label: {
                        Text("완료")
                            .foregroundColor(.black)
                    }
                }
            }
            .toast(isPresenting: $isShowingPopup){
                
                // `.alert` is the default displayMode
//                AlertToast(type: .regular, title: "Message Sent!")
                
                //Choose .hud to toast alert from the top of the screen
                AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
            }
        }
        
    }
}

//struct CategorySelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategorySelectView()
//    }
//}
