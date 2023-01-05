//
//  ChangeNickNameView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct ChangeNickNameView: View {
    @EnvironmentObject private var userStore: UserStore
    @State private var isShowingTextField = false
    @State var nickname: String = ""
    
    var body: some View {
        HStack {
            ZStack {
                Text(userStore.currentUserNickname ?? "")
                    .animation(.easeIn)
                
                TextField("", text: $nickname)
                    .background(Color.white)
                    .opacity(isShowingTextField == true ? 1 : 0)
            }
            
            Button {
                isShowingTextField.toggle()
                Task {
                    await userStore.updateNickname(nickname)
                }
            } label: {
                Text("닉네임 변경")
            }
        }
    }
}

//struct ChangeNickNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeNickNameView()
//    }
//}
