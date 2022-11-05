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
    @State private var refershState : RefershState = RefershState(started: false, released: false, Ended: false)
    var body: some View {
        FlowLayoutWithPullView(list: self.postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10,refershSate: $refershState,onRefersh: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                print("Loading done....")
            }
        }){ info in
                
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
    
}


