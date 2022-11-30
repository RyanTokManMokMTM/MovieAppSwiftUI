//
//  FollowingNotification.swift
//  IOS_DEV
//
//  Created by Jackson on 31/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI



struct FollowingNotification: View {
    @EnvironmentObject private var notificationVM : NotificationVM
    @EnvironmentObject private var userVM : UserViewModel
    @Binding var isShowView : Bool
    var body: some View {
        NotificationView(isShowView:$isShowView,topTitle: "好友邀請"){
            VStack{
                List(){
                    if self.notificationVM.friendRequest.isEmpty {
                        HStack{
                            Spacer()
                            Text("暫無通知")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color("DarkMode2"))

                    }else {
//                        LazyVStack(spacing:0){
                            ForEach(self.notificationVM.friendRequest,id: \.request_id){ info in
                                FollowingCell(info: info)
                                    .listRowBackground(Color("DarkMode2"))
                                    .padding(.vertical,15)
                                    .task {
                                        if self.notificationVM.isLoadingFriendRequest {
                                            await self.notificationVM.LoadMoreFriendRequests()
                                        }
                                    }
                                    .listRowBackground(Color("DarkMode2"))
                            }
                            
                            
                            if self.notificationVM.isLoadingFriendRequest {
                                HStack{
                                    Spacer()
                                    ActivityIndicatorView()
                                    Spacer()
                                }
                                .listRowBackground(Color("DarkMode2"))
                                .listRowSeparator(.hidden)
                            }
//                        }
      

                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await self.notificationVM.RefershFriendRequest()
                }
                
            }
        }
        .onAppear{
            notificationVM.GetFriendRequests()
            UpdateNotificatin()
            
        }
        .onDisappear(){
            self.notificationVM.notificationMataData = nil
        }
        .background(Color("DarkMode2"))
    }
    
    private func UpdateNotificatin(){
        
        APIService.shared.ResetFriendNotification(){ result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.userVM.profile?.notification_info?.friend_notification_count = 0
                }
            case .failure(let err ):
                print(err.localizedDescription)
            }
        }
    }
    
    
    @ViewBuilder
    private func FollowingCell(info : FriendRequest) -> some View{
        HStack(){
            WebImage(url: info.sender.UserPhotoURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 50,maxWidth: 50)
                .clipShape(Circle())

            
            VStack(alignment:.leading,spacing: 8){
                Text(info.sender.name)
                    .font(.system(size: 16,weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    
                
                Text("於\(info.sendTime.dateDescriptiveString())請求加您為好友")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.leading,5)
            Spacer()
            
            if info.state == 1 {
                HStack(spacing:8){
                    Button(action:{
                        accecpt(id: info.request_id)
                    }){
                        Text("確認")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .padding(8)
                            .padding(.horizontal,5)
                            .background( Color.blue.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
        //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
                    }.buttonStyle(.plain)
                    
                    Button(action:{
                        decline(id: info.request_id)
                    }) {
                        Text("拒絕")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .padding(8)
                            .padding(.horizontal,5)
                            .background( Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                    }.buttonStyle(.plain)
                

    //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
                }
            }else if info.state == 2{
                HStack(spacing:8){
                    Text("朋友")
                        .foregroundColor(.gray )
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding(8)
                        .padding(.horizontal,5)
                        .background(Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(Color.gray))
                }
            }
        
//            Text(info.isFriend ? "朋友" : "關注")
//                .foregroundColor(info.isFriend ? .gray : .white)
//                .font(.system(size: 12))
//                .fontWeight(.semibold)
//                .padding(8)
//                .background(info.isFriend ? Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)) : Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
        }
    }
    
    private func accecpt(id : Int){
        let req = FriendRequestAccecptReq(request_id: id)
        APIService.shared.AccepctFriendRequest(req: req){ result in
            switch result{
            case .success(let data):
                print(data.message)
                
                if let idx = self.notificationVM.friendRequest.firstIndex(where: { info in
                    return info.request_id == id
                }) {
                    DispatchQueue.main.async {
                        self.notificationVM.friendRequest[idx].state = 2
                    }
                  
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func decline(id : Int){
        let req = FriendRequestDeclineReq(request_id: id)
        APIService.shared.DeclineFriendRequest(req: req){ result in
            switch result{
            case .success(let data):
                print(data.message)
                if let idx = self.notificationVM.friendRequest.firstIndex(where: { info in
                    return info.request_id == id
                }) {
                    DispatchQueue.main.async {
                        self.notificationVM.friendRequest.remove(at: idx)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
