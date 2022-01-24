//
//  ScrollableTabBar.swift
//  IOS_DEV
//
//  Created by Jackson on 24/1/2022.
//

import SwiftUI

struct ScrollableTabBar<Content: View>: UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    let content : Content
    let rect : CGRect //used to calculated the size
    let tabs : [Any]
    
    @Binding var offset : CGFloat
    init(tabs : [Any],rect : CGRect,offset : Binding<CGFloat>,@ViewBuilder content:() -> Content){
        self.content = content()
        self._offset = offset
        self.rect = rect
        self.tabs = tabs
    }
    
    let scrollView = UIScrollView()
    
    func makeUIView(context: Context) ->  UIScrollView {
        setting()
        scrollView.contentSize = CGSize(width: rect.width *  CGFloat(tabs.count), height: .infinity)
        scrollView.addSubview(extraSwiftUIView())
        scrollView.delegate = context.coordinator
        return scrollView
    }
    
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
    func setting()  {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func extraSwiftUIView()-> UIView{
        let root = UIHostingController(rootView: self.content)
        root.view.frame = CGRect(x: 0, y: 0, width: rect.width * CGFloat(tabs.count), height: rect.height)
        return root.view
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        let parent : ScrollableTabBar
        
        init(parent : ScrollableTabBar){
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.parent.offset = scrollView.contentOffset.x
        }
    }
    
}
