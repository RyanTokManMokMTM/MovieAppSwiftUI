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
    var namespace : Namespace.ID
    @Binding var isShow : Bool
    @Binding  var selectedData : Post?
//    var columns = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        
        FlowLayoutView(list: postVM.postData, columns: 2,HSpacing: 5,VSpacing: 10){ info in
            CardPostView(namespace: namespace,postData: info){
                self.selectedData = info
                withAnimation{
                    self.isShow.toggle()
                }
            }
        }

    }
    
}


