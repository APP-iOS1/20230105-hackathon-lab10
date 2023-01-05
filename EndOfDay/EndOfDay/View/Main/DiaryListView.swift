//
//  DiaryListView.swift
//  EndOfDay
//
//  Created by 이재희 on 2023/01/05.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct DiaryListView: View {
    @StateObject private var recordStore: RecordStore = RecordStore()
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Text("그룹명")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.horizontal)
                ScrollView {
                    ForEach(recordStore.records) { record in
                        NavigationLink {
                            DiaryCellView(record: record)
                        } label: {
                            DiaryCellView(record: record)
                            //                            .frame(height: 600)
                        }
                    }
                }
                //            .navigationBarTitle("타이틀")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        //                    WriteDetailView(recordeStore: recordStore)
                    } label: {
                        Image(systemName: "square.and.pencil")
               
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        //                    WriteDetailView(recordeStore: recordStore)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            recordStore.fetchRecords()
        }
    }
}


struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
}
