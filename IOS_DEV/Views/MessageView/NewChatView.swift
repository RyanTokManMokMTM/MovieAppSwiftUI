//
//  NewChatView.swift
//  IOS_DEV
//
//  Created by Jackson on 25/10/2022.
//

import SwiftUI

var temp : [SimpleUserInfo] = [
    SimpleUserInfo(id:1,name: "jackson_tmm", avatar: "/FCD87869-5D05-4B8C-8C6A-5DD560B311B5.jpeg"),
    SimpleUserInfo(id:2,name: "TomxD", avatar: "/B4989329-7F9B-4974-989C-667C50C0FA81.jpeg"),
    SimpleUserInfo(id:3, name: "Alice.g", avatar: "/defaultAvatar.jpeg"),
    SimpleUserInfo(id:4, name: "M.DAS", avatar: "/FCD87869-5D05-4B8C-8C6A-5DD560B311B5.jpeg"),
]



struct NewChatView: View {
    @State private var friends : [SimpleUserInfo] = temp
    @Binding var isNewChat : Bool
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                VStack(alignment:.leading){
                    VStack{
                        HStack(){
                            Button(action:{
                                withAnimation{
                                    self.isNewChat = false
                                }
                            }){
                                Text("取消")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            Text("新聊天")
                                .font(.system(size: 14))
                            Spacer()
                            
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal,10)
                        .padding(.bottom,10)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
//                    .background(Color("appleDark"))
//                    Divider()
                    
                    List(friends, id:\.id){    info in
                        HStack{
                            AsyncImage(url: info.UserPhotoURL){ image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ActivityIndicatorView()
                            }
                            .frame(width: 40,height:40)
                            .clipShape(Circle())
                            .clipped()
            
                            
                            Text(info.name)
                                .bold()
                                .font(.system(size: 16))
                        }
                        .padding(.vertical,5)

                    }.listStyle(.plain)
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }
        }
    }
}

