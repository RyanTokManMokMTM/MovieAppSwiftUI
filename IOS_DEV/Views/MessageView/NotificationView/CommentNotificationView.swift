//
//  CommentNotificationView.swift
//  IOS_DEV
//
//  Created by Jackson on 1/9/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationCommentInfo : Identifiable {
    //PostInfo
    //UserInfo
    var id = UUID().uuidString
    var user_info : SimpleUserInfo
    var post_info : SimplePostInfo
    var comment_info : SimpleCommnetWithReplyInfo
    var create_time : Date
}

struct SimpleCommnetWithReplyInfo : Identifiable {
    let id : Int
    let comment : String
    let reply : String?
    let comment_state : Int
}

var TempCommentReplyInfo : [SimpleCommnetWithReplyInfo] = [
    SimpleCommnetWithReplyInfo(id: 1, comment: "謝謝分享！",reply: nil,comment_state: 0),
    SimpleCommnetWithReplyInfo(id: 2, comment: "真的！我覺得這是一個很好的電影，十分值得關注關看",reply: "我剛才也去看了！真不錯",comment_state: 1),
    SimpleCommnetWithReplyInfo(id: 3, comment: "Thx!",reply: nil,comment_state: 0),
    SimpleCommnetWithReplyInfo(id: 4, comment: "哈哈哈哈，我也這麼覺得",reply: "我覺得還好！",comment_state: 1)

]

var tempCommenttInfo : [NotificationCommentInfo] = [
    NotificationCommentInfo(user_info: TempSimpleUser[0], post_info: TempSimplePost[0], comment_info: TempCommentReplyInfo[0], create_time: Date.now),
    NotificationCommentInfo(user_info: TempSimpleUser[2], post_info: TempSimplePost[2], comment_info: TempCommentReplyInfo[1], create_time: Date.now.addingTimeInterval(-3600)),
    NotificationCommentInfo(user_info: TempSimpleUser[3], post_info: TempSimplePost[1], comment_info: TempCommentReplyInfo[1], create_time: Date.now.addingTimeInterval(-10000)),
    NotificationCommentInfo(user_info: TempSimpleUser[1], post_info: TempSimplePost[3], comment_info: TempCommentReplyInfo[2], create_time: Date.now.addingTimeInterval(-12563)),
    NotificationCommentInfo(user_info: TempSimpleUser[5], post_info: TempSimplePost[0], comment_info: TempCommentReplyInfo[0], create_time: Date.now.addingTimeInterval(-86400)),

]

struct CommentNotificationView: View {
    @Binding var isShowView : Bool
    var body: some View {
        NotificationView(isShowView:$isShowView,topTitle: "留言"){
            List(){
                ForEach(tempCommenttInfo){ info in
                    CommentCell(info: info)
                        .listRowBackground(Color("DarkMode2"))
                        .padding(.vertical,15)
                }
            }.listStyle(.plain)
        }
        .background(Color("DarkMode2"))
    }
    
    @ViewBuilder
    private func CommentCell(info : NotificationCommentInfo) -> some View {
        
        HStack(alignment:.top){
            AsyncImage(url: info.user_info.UserPhotoURL){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ActivityIndicatorView()
            }
            .frame(width: 45,height:45)
            .clipShape(Circle())
            .clipped()
            
            
            
            VStack(alignment:.leading,spacing: 5){
                Text(info.user_info.name)
                    .font(.system(size: 14,weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if info.comment_info.comment_state == 0{
                    Text("給您留言 \(info.create_time.dateDescriptiveString())")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }else {
                    Text("回覆了您的留言 \(info.create_time.dateDescriptiveString())")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(info.comment_info.comment)
                    .lineLimit(1)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                if info.comment_info.comment_state == 1{
                    HStack(spacing:5){
                        BlurView().clipShape(CustomeConer(width: 10, height: 20, coners: .allCorners)).frame(width: 5, height: 20)
                        
                        Text(info.comment_info.reply ?? "")
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing:5){
                        Image(systemName: "message")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                        Text("回覆")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.white)
                    .frame(width: 80, height: 23)
                    .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                    .padding(.top,5)
                }
            }
            .padding(.leading,5)
            Spacer()
            //
            //
            WebImage(url: info.post_info.movie_info.PosterURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 40,maxWidth: 40)
                .cornerRadius(8)
            
        }
    }
    
}
