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
    var body: some View {
        FlowLayoutView(list: self.postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10){ info in
            CardPostView(Id:self.postVM.getPostIndexFromDiscoveryList(postId: info.id)){
                    self.postVM.selectedPost = info
                    withAnimation{
                        self.postVM.isShowPostDetail.toggle()
                    }
                }
        }
        .frame(maxWidth:.infinity)
        .background(Color("DarkMode2").frame(maxWidth:.infinity))
        .background(
            NavigationLink(destination:
                            PostDetailView(postForm: .AllPost, isFromProfile: false)
                            .environmentObject(postVM)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                           , isActive: self.$postVM.isShowPostDetail){
                EmptyView()
                
            }
        )

    }
    
}


