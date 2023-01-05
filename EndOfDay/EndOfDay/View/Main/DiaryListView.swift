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
        NavigationStack{
            List {
                ForEach(recordStore.records) { record in
                    NavigationLink {
                        DiaryCellView(record: record)
                    } label: {
                        DiaryCellView(record: record)
//                            .frame(height: 600)
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
