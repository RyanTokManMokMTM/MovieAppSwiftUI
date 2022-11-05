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
//                .background(Color("DarkMode2").frame(maxWidth:.infinity))
            }
        }
        .background(Color("DarkMode2").frame(maxWidth:.infinity))
        .listStyle(.plain)

    }
}



struct FlowLayoutWithPullView< T : Identifiable,Content : View> : View where T : Hashable {
    
    var list : [T]
    var colums : Int
    
    var content : (T) -> Content
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    @Binding var refershState : RefershState
    var onRefersh : ()->()
    
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
    init(list : [T],columns : Int,HSpacing : CGFloat = 10,VSpacing : CGFloat = 10,refershSate : Binding<RefershState>,onRefersh : @escaping ()->(),@ViewBuilder content :@escaping (T) -> Content){
        self.content = content
        self.list = list
        self.colums = columns
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self._refershState = refershSate
        self.onRefersh = onRefersh
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            GeometryReader{reader -> AnyView in
                
                DispatchQueue.main.async {
                    if self.refershState.startOffset == 0 {
                        self.refershState.startOffset = reader.frame(in: .global).minY
                    }
                    
                    refershState.offset = reader.frame(in: .global).minY
                    
                    if self.refershState.offset - refershState.startOffset > 80 && !self.refershState.started {
                        self.refershState.started = true
                    }
                    
                    if self.refershState.offset == self.refershState.startOffset && self.refershState.started && !self.refershState.released{
                        self.refershState.released = true
                        onRefersh()
                    }
                    
                }

                return AnyView(Color.black.frame(width: 0, height: 0))
            }.frame(width: 0, height: 0)
            
            VStack(spacing:0){
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
    //                .background(Color("DarkMode2").frame(maxWidth:.infinity))
                }
            }
        }
        .background(Color("DarkMode2").frame(maxWidth:.infinity))
        .listStyle(.plain)

    }
}



