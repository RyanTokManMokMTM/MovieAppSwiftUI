//
//  FlowLayoutView.swift
//  IOS_DEV
//
//  Created by Jackson on 9/7/2022.
//

import SwiftUI
import Refresher

struct FlowLayoutView< T : Identifiable,Content : View> : View where T : Hashable {
    
    var list : [T]
    var colums : Int
    
    var content : (T) -> Content
    
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    
    @Binding var isScrollable : Bool
    @State private var setUp = false
    
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
    init(list : [T],columns : Int,HSpacing : CGFloat = 10,VSpacing : CGFloat = 10,isScrollAble : Binding<Bool>,@ViewBuilder content :@escaping (T) -> Content){
        self.content = content
        self.list = list
        self.colums = columns
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self._isScrollable = isScrollAble
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                if !setUp{
                    if list.isEmpty {
                         VStack{
                             Text("無文章")
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


            }
            .introspectScrollView{scroll in
                scroll.isScrollEnabled = self.isScrollable
            }
            .onAppear() {
                self.setUp = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    self.setUp = false
                }
            }
        }




    }
}



struct FlowLayoutRefershAbleView< T : Identifiable,Content : View> : View where T : Hashable {
    
    var list : [T]
    var colums : Int
    
    var content : (T) -> Content
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    var onRefersh : () async ->()
    @Binding var isLoading : Bool
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
    init(isLoading : Binding<Bool> = .constant(false),list : [T],columns : Int,HSpacing : CGFloat = 10,VSpacing : CGFloat = 10,onRefersh : @escaping () async ->(),@ViewBuilder content :@escaping (T) -> Content){
        self.content = content
        self.list = list
        self.colums = columns
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self.onRefersh = onRefersh
        self._isLoading = isLoading
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing:0){
                if list.isEmpty {
                    VStack{
                        Text("暫無任何文章")
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
                    
                    if self.isLoading {
                       ActivityIndicatorView()
                            .padding(.bottom,15)
                    }
                }
            }
        }
//        .introspectScrollView{ scroll in
//            let controller = UIRefreshControl()
//            scroll.refreshControl = controller
//        }
        .refresher(style: .system) { done in
            Task.init{
                await onRefersh()
                done()
            }
        }

        .background(Color("DarkMode2").frame(maxWidth:.infinity))
        .listStyle(.plain)
    }
}




struct FlowLayoutWithLoadMoreView< T : Identifiable,Content : View> : View where T : Hashable {
    
    var list : [T]
    var colums : Int
    
    var content : (T) -> Content
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    
    @Binding var IsInit : Bool
//    @State private var setUp = false
    @Binding var isScrollable : Bool
    @Binding var isLoading : Bool
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
    init(isLoading : Binding<Bool> = .constant(false),isInit : Binding<Bool> = .constant(false),list : [T],columns : Int,HSpacing : CGFloat = 10,VSpacing : CGFloat = 10,isScrollable : Binding<Bool> = .constant(true),@ViewBuilder content :@escaping (T) -> Content){
        self.content = content
        self.list = list
        self.colums = columns
        self.HSpacing = HSpacing
        self.VSpacing = VSpacing
        self._isScrollable = isScrollable
        self._IsInit = isInit
        self._isLoading = isLoading
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            if !self.IsInit {
                LazyVStack(spacing:0){
                    if list.isEmpty {
                        VStack{
                            Text("暫無資料")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        .padding(.vertical)

                    }else {
                        HStack(alignment:.top,spacing:HSpacing){
                            ForEach(customList(),id:\.self){datas in
                                LazyVStack(spacing:VSpacing){
                                    ForEach(datas,id:\.id) { data in
                                        content(data)
                                    }
                                }
                            }
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,3)
                        
                        if self.isLoading {
                            ActivityIndicatorView()
                                .padding(.bottom,15)
                        }
                    }
                }
            }
            
        }
        .introspectScrollView{scroll in
            scroll.isScrollEnabled = self.isScrollable
        }
        .edgesIgnoringSafeArea(.all)

        .onAppear() {
            if !self.IsInit {
                return
            }
            print(self.IsInit)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                self.IsInit = false
            }
        }
    }
}

