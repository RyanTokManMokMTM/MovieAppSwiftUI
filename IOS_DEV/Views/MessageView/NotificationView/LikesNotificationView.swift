//
//  LikesNotificationView.swift
//  IOS_DEV
//
//  Created by Jackson on 31/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI
//
//struct NotificationLikeInfo : Identifiable {
//    //PostInfo
//    //UserInfo
//    var id = UUID().uuidString
//    var user_info : SimpleUserInfo
//    var post_info : SimplePostInfoTemp
//    var comment_info : SimpleCommnetInfo
//    var create_time : Date
//}
//
//struct SimplePostInfoTemp : Identifiable {
//    let id = UUID().uuidString
//    let movie_info : PostMovieInfo
//}
//
//struct SimpleCommnetInfo : Identifiable {
//    let id : Int
//    let comment : String
//}
//
//var TempSimpleComment : [SimpleCommnetInfo] = [
//    SimpleCommnetInfo(id: 1, comment: "謝謝分享！"),
//    SimpleCommnetInfo(id: 2, comment: "真的！我覺得這是一個很好的電影，十分值得關注關看"),
//    SimpleCommnetInfo(id: 3, comment: "Thx!"),
//    SimpleCommnetInfo(id: 4, comment: "哈哈哈哈，我也這麼覺得")
//]
//var TempSimpleUser : [SimpleUserInfo] = [
//    SimpleUserInfo(id:1,name: "Alien_RA", avatar: "/B0CF7152-1791-4244-A7F8-0EFACBC84BBD.jpeg"),
//    SimpleUserInfo(id:2,name: "Tom", avatar:  "/49CF11D5-7497-421F-8AFF-18FD44A72223.jpeg"),
//    SimpleUserInfo(id:3,name: "Alice", avatar:  "/31E77503-1780-43EC-8850-0D946AF6EAB5.jpeg"),
//    SimpleUserInfo(id:4,name: "迪斯科", avatar:  "/8A7383C6-4596-4333-A651-62D6085DE522.jpeg"),
//    SimpleUserInfo(id:5,name: "瑪麗", avatar:  "/7DF0CE93-4DF5-4ABA-8C7F-441E4A9DBB32.jpeg"),
//    SimpleUserInfo(id:6,name: "小白", avatar:  "/16E157BE-7667-45BB-87B6-099E2A00CAFA.jpeg")
//]
//
//
//
//var TempSimplePost : [SimplePostInfoTemp] = [
//    SimplePostInfoTemp(movie_info: TempSimpleMovieInfo[0]),
//    SimplePostInfoTemp(movie_info: TempSimpleMovieInfo[1]),
//    SimplePostInfoTemp(movie_info: TempSimpleMovieInfo[2]),
//    SimplePostInfoTemp(movie_info: TempSimpleMovieInfo[2]),
//]
//
//var TempSimpleMovieInfo : [PostMovieInfo] = [
//    PostMovieInfo(id: 453395, title: "奇異博士2：失控多重宇宙", poster_path: "/xSNSQSuzEsVIVMDlcsfK9gw7GQC.jpg"),
//    PostMovieInfo(id: 762504, title: "不!", poster_path: "/wOuEBub0j2ryFsIvZ6dUTe8o9BL.jpg"),
//    PostMovieInfo(id: 1010819, title: "我是格魯特：小小救世主", poster_path: "/kBTMEtL1DNsxBElDLj65lf3Kdqa.jpg"),
//]
//
//
//var tempLikesCommentInfo : [NotificationLikeInfo] = [
//    NotificationLikeInfo(user_info: TempSimpleUser[0], post_info: TempSimplePost[0], comment_info: TempSimpleComment[0], create_time: Date.now),
//    NotificationLikeInfo(user_info: TempSimpleUser[2], post_info: TempSimplePost[2], comment_info: TempSimpleComment[1], create_time: Date.now.addingTimeInterval(-3600)),
//    NotificationLikeInfo(user_info: TempSimpleUser[3], post_info: TempSimplePost[1], comment_info: TempSimpleComment[1], create_time: Date.now.addingTimeInterval(-10000)),
//    NotificationLikeInfo(user_info: TempSimpleUser[1], post_info: TempSimplePost[3], comment_info: TempSimpleComment[2], create_time: Date.now.addingTimeInterval(-12563)),
//    NotificationLikeInfo(user_info: TempSimpleUser[5], post_info: TempSimplePost[0], comment_info: TempSimpleComment[0], create_time: Date.now.addingTimeInterval(-86400)),
//
//]

struct LikesNotificationView: View {
    @Binding var isShowView : Bool
    @EnvironmentObject private var notificationVM : NotificationVM
    @EnvironmentObject private var userVM :UserViewModel
    
    var body: some View {
        NotificationView(isShowView:$isShowView,topTitle: "點贊"){
            List(){
                if self.notificationVM.likesNotification.isEmpty {
                    HStack{
                        Spacer()
                        Text("暫無通知")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("DarkMode2"))
                }else {
//                    LazyVStack(spacing:0){
                        ForEach(self.notificationVM.likesNotification){ info in
                            LikesCell(info: info)
                                .listRowBackground(Color("DarkMode2"))
                                .padding(.vertical,15)
                                .task {
                                    if self.notificationVM.isLastLikesNotification(id: info.id){
                                        await self.notificationVM.LoadMoreLikesNotification()
                                    }
                                }
                                .listRowBackground(Color("DarkMode2"))
                        }
                        
                        if self.notificationVM.isLoadingLikes {
                            HStack{
                                Spacer()
                                ActivityIndicatorView()
                                Spacer()
                            }
                            .listRowBackground(Color("DarkMode2"))
                            .listRowSeparator(.hidden)
                        }
//                    }
                   
                    
                }
            }
            .listStyle(.plain)
            .refreshable {
//                await self.notificationVM.
                await self.notificationVM.RefershLikesNotification()
            }
        }
        .background(Color("DarkMode2"))
        .onAppear(){
            notificationVM.GetLikesNotification()
            UpdateNotificatin()
        }
        .onDisappear(){
            self.notificationVM.notificationMataData = nil
        }
        
    }
    
    private func UpdateNotificatin(){
        
        APIService.shared.ResetLikesNotification(){ result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.userVM.profile?.notification_info?.likes_notification_count = 0
                }
            case .failure(let err ):
                print(err.localizedDescription)
            }
            
        }
        
    }
    
    @ViewBuilder
    private func LikesCell(info : LikesNotification) -> some View {
        
        HStack(alignment:.top){
            AsyncImage(url: info.liked_by.UserPhotoURL){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ActivityIndicatorView()
                }
                .frame(width: 45,height:45)
                .clipShape(Circle())
                .clipped()

            
            if info.type == 1 {
                VStack(alignment:.leading,spacing: 5){
                    Text(info.liked_by.name)
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text("於\(info.likedAt.dateDescriptiveString())給您的文章點贊")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.leading,5)
            }else {
                VStack(alignment:.leading,spacing: 5){
                    Text(info.liked_by.name)
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text("於\(info.likedAt.dateDescriptiveString())給您的留言點讚")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    HStack{
                        BlurView().clipShape(CustomeConer(width: 10, height: 20, coners: .allCorners)).frame(width: 5, height: 20)
                        Text(info.comment_info.comment)
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading,5)
            }
            

            Spacer()
//
//
            WebImage(url: info.post_info.post_movie_info.PosterURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 40,maxWidth: 40)
                .cornerRadius(8)

        }
//        .padding(.vertical,15)
    }

}
//


//struct LikesNotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesNotificationView()
//    }
//}
