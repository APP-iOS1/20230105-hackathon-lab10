//
//  SettingView.swift
//  EndOfDay
//
//  Created by 김태성 on 2023/01/05.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            HStack {
                VStack {
                    Image(systemName: "person.3.sequence.fill")
                    Text("일기를 같이 쓰고싶은 친구를 초대하세요!")
                        .padding()
                    
                    Button {
                        
                    } label: {
                        Text("초대코드 복사하기")
                    }
                    .modifier(MaxWidthColoredButtonModifier(cornerRadius: 30))
                }
            }
            .padding()
//            .overlay(
//                Rectangle()
//                    .frame(width: UIScreen.main.bounds.width - 30)
//                    .cornerRadius(15)
//                    .foregroundColor(.gray.opacity(0.1))
//            )

            Section(header: Text("함께하는 사람들"), content: {
                Text("조운상")
                Text("이영우")
                Text("김태성")
            })
            
            Button {
                
            } label: {
                Text("일기장 표지 수정")
            }
            
            Button {
                
            } label: {
                Text("일기장 나가기")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationBarTitle("일기 설정", displayMode: .inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView()
        }
    }
}


struct MaxWidthColoredButtonModifier: ViewModifier {
    var color: Color = Color("AccentColor")
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .frame(width: UIScreen.main.bounds.width - 50, height: 44)
            .bold()
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
    }
}
