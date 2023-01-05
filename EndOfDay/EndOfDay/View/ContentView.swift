//
//  ContentView.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/13.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @State private var firstNaviLinkActive: Bool = false
    var body: some View {
        NavigationStack {
            // MARK: user 프로퍼티의 상태(로그인 상태)에 따라서 다른 뷰 호출
            if userStore.user != nil {
                MainView()
            } else {
                LoginView()
            }
        }.onAppear {
            // MARK: 뷰가 그려질때 로그인 상태를 확인하고 user 프로퍼티를 업데이트
            userStore.listenToLoginState()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(UserStore())
//    }
//}
