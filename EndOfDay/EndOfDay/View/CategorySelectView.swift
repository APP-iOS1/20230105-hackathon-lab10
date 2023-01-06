//
//  CategorySelectView.swift
//  EndOfDay
//
//  Created by MIJU on 2023/01/06.
//

import SwiftUI

struct CategorySelectView: View {
    //    @State private var diariesID: [Int] = []
    @State private var diariesID: [String] = []
    @Binding var showingSheet : Bool
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var imageStore: ImageStore
    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var recordStore: RecordStore
    @Environment(\.dismiss) private var dismiss
    
    @Binding var test: String
    
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
                        test = "모달 닫기"
//                        showingSheet.toggle()
//                        dismiss()
                        print("모달 dismiss")
//                        dismiss()
                        Task{
                            await recordStore.addRecord(record:record, diariesID: diariesID)
                        }
                    } label: {
                        Text("완료")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Text("그룹 선택")
                        .frame(width: 280, alignment: .center)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
            }
        }
        
    }
}

//struct CategorySelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategorySelectView()
//    }
//}
