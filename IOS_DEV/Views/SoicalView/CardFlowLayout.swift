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
    var namespace: Namespace.ID
    var body: some View {
        FlowLayoutView(list: self.postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10){ info in
            CardPostView(postData: info,namespace:namespace){

                self.postVM.selectedPost = info
                withAnimation{
                    self.postVM.isShowPostDetail.toggle()
                }
            }
        }

    }
    
}


