//
//  FlowLayoutView.swift
//  IOS_DEV
//
//  Created by Jackson on 9/7/2022.
//

import SwiftUI

struct FlowLayoutView< T : Identifiable,Content : View> : View where T : Hashable {
    
    var list : [T]
    var colums : Int
    
    var content : (T) -> Content
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    private func customList() -> [[T]] {
        var curIndx = 0
        var gridList : [[T]] = Array(repeating: [], count: self.colums)
        list.forEach{ data  in
            //each row have colums data
            gridList[curIndx].append(data)
            if curIndx == colums - 1 {
                curIndx = 0
            } else {
                curIndx += 1
            }
        }
        return gridList
    }
    init(list : [T],columns : Int,HSpacing : CGFloat = 10,VSpacing : CGFloat = 10,@ViewBuilder content :@escaping (T) -> Content){
        self.content = content
        self.list = list
        self.colums = columns
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            if list.isEmpty {
                VStack{
                    Text("There is no any post yet...")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.vertical)
            }else {
                HStack(alignment:.top,spacing:HSpacing){
                    ForEach(customList(),id:\.self){datas in
                        LazyVStack(spacing:VSpacing){
                            ForEach(datas) { data in
                                content(data)
                            }
                        }
                    }
                    
                }
                .padding(.vertical,5)
                .padding(.horizontal,3)
            }
        }
//        .padding(.vertical,5)
    }
}

