//
//  FollowingNotification.swift
//  IOS_DEV
//
//  Created by Jackson on 31/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct SimpleUserInfoTemp : Identifiable {
    var id : String =  UUID().uuidString
    var name : String
    var avatar : String
    var isFriend : Bool
    var followingTime : Date
    var UserPhotoURL: URL {
        return URL(string: avatar)!
    }

}

var TempUser : [SimpleUserInfoTemp] = [
    SimpleUserInfoTemp(name: "jackson_tmm", avatar: "https://upload.cc/i1/2022/08/31/IdXtkZ.jpeg", isFriend: false, followingTime: Date.now),
    SimpleUserInfoTemp(name: "TomxD", avatar: "https://upload.cc/i1/2022/08/31/Fz4how.jpeg", isFriend: true, followingTime: Date.now),
    SimpleUserInfoTemp(name: "Alice.g", avatar: "https://upload.cc/i1/2022/08/31/0EA7rd.jpeg", isFriend: false, followingTime: Date.now),
    SimpleUserInfoTemp(name: "M.DAS", avatar: "https://upload.cc/i1/2022/08/31/qXuNME.jpeg", isFriend: true, followingTime:  Date.now),
    SimpleUserInfoTemp(name: "瑪麗", avatar: "https://upload.cc/i1/2022/08/31/4FzITC.jpeg", isFriend: false, followingTime:  Date.now),
    SimpleUserInfoTemp(name: "小白", avatar: "https://upload.cc/i1/2022/07/03/MJIXkd.jpeg", isFriend: false, followingTime:  Date.now)
]


struct FollowingNotification: View {
    @Binding var isShowView : Bool
    var body: some View {
        NotificationView(isShowView:$isShowView,topTitle: "關注"){
            List(){
                ForEach(TempUser){ info in
                    FollowingCell(info: info)
                        .listRowBackground(Color("DarkMode2"))
                }
            }.listStyle(.plain)
        }
        .background(Color("DarkMode2"))
    }
    
    @ViewBuilder
    private func FollowingCell(info : SimpleUserInfoTemp) -> some View{
        HStack(){
            WebImage(url: info.UserPhotoURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 50,maxWidth: 50)
                .clipShape(Circle())

            
            VStack(alignment:.leading,spacing: 8){
                Text(info.name)
                    .font(.system(size: 16,weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("開始關注您 \(info.followingTime.dateDescriptiveString())")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.leading,5)
            Spacer()
            Text(info.isFriend ? "朋友" : "關注")
                .foregroundColor(info.isFriend ? .gray : .white)
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .padding(8)
                .background(info.isFriend ? Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)) : Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
        }
    }
}
