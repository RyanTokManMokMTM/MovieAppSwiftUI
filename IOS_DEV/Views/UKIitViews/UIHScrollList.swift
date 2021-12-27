//
//  UIHScrollList.swift
//  IOS_DEV
//
//  Created by Jackson on 20/8/2021.
//

import SwiftUI
import UIKit


struct UIHScrollList<Content:View>: UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return UIHScrollList.Coordinator(parent: self)
    }
    
//    func makeCoordinator() -> Coordinator {
//        return PlayerScrollView.Coordinator(parent: self,didRefresh: self.$reload)
//    }
    let width : CGFloat
    let hegiht : CGFloat
    var cardsCount :Int
    @Binding var page:Int
    let content:()->Content
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let contentWidth = width * CGFloat(cardsCount)
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: contentWidth, height: 1.0)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        //embed swiftUI view
        let rootView = UIHostingController(rootView: self.content())
        
        rootView.view.frame = CGRect(x: 0, y: 0, width: contentWidth, height: self.hegiht)
        rootView.view.backgroundColor = .clear
        view.addSubview(rootView.view)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //TODO
    }

    class Coordinator:NSObject,UIScrollViewDelegate{
        var parent : UIHScrollList
        init(parent:UIHScrollList){
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            parent.page = currentPage
        }
    }
}


