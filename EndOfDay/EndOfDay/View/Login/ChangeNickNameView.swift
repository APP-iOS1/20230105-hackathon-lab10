//
//  ChangeNickNameView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct ChangeNickNameView: View {
    @EnvironmentObject private var userStore: UserStore
    @State var nickname: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(userStore.currentUserNickname ?? "1")
                TextField("", text: $nickname)
                Button {
                    userStore.updateNickname(nickname)
                } label: {
                    Text("닉네임 변경")
                }

                
            }
        }
    }
}

//struct ChangeNickNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeNickNameView()
//    }
//}
