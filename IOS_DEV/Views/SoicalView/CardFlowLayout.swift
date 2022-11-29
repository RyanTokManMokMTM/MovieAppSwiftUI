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
        FlowLayoutWithPullView(list: self.postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10,onRefersh: self.postVM.refershDiscoverData,content: { info in
                CardPostView(postInfo: self.$postVM.postData[self.postVM.getPostIndexFromDiscoveryList(postId: info.id)]){
                        DispatchQueue.main.async {
                            self.postVM.selectedPostInfo = info
                            self.postVM.selectedPostFrom = .AllPost
                            withAnimation{
                                self.postVM.isShowPostDetail.toggle()
                            }
                        }
                    }
                .transition(.move(edge: .bottom))


        },loadMoreContent: {
            if self.postVM.discoverMetaData?.page ?? 0  < self.postVM.discoverMetaData?.total_pages ?? 0{
                ActivityIndicatorView()
                    .padding(.vertical,5)
                    .task{
                        await self.postVM.LoadMoreDiscoverData()
                    }
            }
        })
        .frame(maxWidth:.infinity)
        .background(Color("DarkMode2").frame(maxWidth:.infinity))
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


