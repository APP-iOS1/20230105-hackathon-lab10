//
//  EndOfDayApp.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/12.
//

import SwiftUI
import FirebaseCore

@main
struct EndOfDayApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        let userStore: UserStore = UserStore()
        let diaryStore: DiaryStore = DiaryStore()
        let recordStore: RecordStore = RecordStore()
        WindowGroup {
            ContentView()
                .environmentObject(diaryStore)
                .environmentObject(userStore)
                .environmentObject(recordStore)
        }
    }
}
