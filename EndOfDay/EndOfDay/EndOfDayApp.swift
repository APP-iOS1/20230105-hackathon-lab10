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
    @StateObject var userStore = UserStore()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userStore)
        }
    }
}
