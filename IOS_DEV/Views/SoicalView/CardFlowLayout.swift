//
//  CardFlowLayout.swift
//  IOS_DEV
//
//  Created by Jackson on 9/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardFlowLayout: View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var HubState : BenHubState = BenHubState.shared

    var body: some View {
        FlowLayoutWithPullView(list: self.postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10,onRefersh: refershData){ info in
                CardPostView(postInfo: self.$postVM.postData[self.postVM.getPostIndexFromDiscoveryList(postId: info.id)]){
                    DispatchQueue.main.async {
                        self.postVM.selectedPostInfo = info
                        withAnimation{
                            self.postVM.isShowPostDetail.toggle()
                        }
                    }
                }
        
        }
        .frame(maxWidth:.infinity)
        .background(Color("DarkMode2").frame(maxWidth:.infinity))
        .background(
            NavigationLink(destination:
                            PostDetailView(postForm: .AllPost, isFromProfile: false,postInfo: self.$postVM.selectedPostInfo)
                .environmentObject(postVM)
                .environmentObject(userVM)
                .navigationBarTitle("")
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                           , isActive: self.$postVM.isShowPostDetail){
                               EmptyView()
                               
                               
                           }
            
        )
        .onAppear{
            if postVM.initAllData {
                HubState.SetWait(message: "Loading")
                self.postVM.GetAllUserPost(onSucceed: {
                    HubState.isWait = false
                }, onFailed: {errMsg in
                    HubState.isWait = false
                    HubState.AlertMessage(sysImg: "xmark.circle.fill", message: errMsg)
                })
                postVM.initAllData = false
            }
        }
//        .wait(isLoading: $HubState.isWait){
//            BenHubLoadingView(message: HubState.message)
//        }
//        .alert(isAlert: $HubState.isPresented){
//            BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
//        }
//

    }
    
    private func refershData() async {
        //refershing just get the latest 20 posts ,and replace all oldest data that client have.
        print("wating...")
        let data = await APIService.shared.AsyncGetAllUserPost()
        switch data{
        case .success(let data):
//            print("get new data \(data.post_info)")
            self.postVM.postData = data.post_info
        case .failure(let err):
            print(err.localizedDescription)
            HubState.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
}


