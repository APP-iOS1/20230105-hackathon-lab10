//
//  HomeView.swift
//  EndOfDay
//
//  Created by 이재희 on 2022/12/13.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject private var userStore: UserStore
     
    var body: some View {
        NavigationStack{
            VStack {
                if let user = userStore.user {
                  // User is signed in. Get their display name.
                    Text(user.displayName ?? "등록된 닉네임이 없는데여")
                    AsyncImage(url: user.photoURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                } else {
                  // User is not signed in. Prompt them to sign in.
                    Text("로그인 안됐는데?ㅋㅋㅋㅋㅋㅋㅋ")
                }
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) { Button(
                    action: { userStore.logOut()
                    }, label: {
                        Text("Sign Out") .bold()
                    })
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(UserStore())
//    }
//}
