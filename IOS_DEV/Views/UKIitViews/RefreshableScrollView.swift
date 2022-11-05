//
//  RefreshableScrollView.swift
//  IOS_DEV
//
//  Created by Jackson on 14/9/2021.
//

import SwiftUI
import UIKit

struct DragRefreshableScrollView<Content:View> : UIViewRepresentable{
    
    @EnvironmentObject var dragPreviewModel : DragSearchModel
    @Binding var datas : [DragItemData]
    @Binding var isLoading : Bool
    var dataType : CharacterRule
    var content : Content
    var onRefresh : (UIRefreshControl)->()
    var beAbleToUpdate : Bool
    var isOffsetting : Bool
    var offsetVal : CGFloat
    var refreshController = UIRefreshControl()
    init(
        dataType :CharacterRule,
        datas : Binding<[DragItemData]>,
        isLoading : Binding<Bool>,
        beAbleToUpdate : Bool,
        isOffsetting:Bool = false,
        offsetVal:CGFloat = 0,
        @ViewBuilder content: @escaping ()->Content,
        onRefresh: @escaping (UIRefreshControl)->()){
            self.content = content()
            self.onRefresh = onRefresh
            self._isLoading = isLoading
            self._datas = datas
            self.dataType = dataType
            self.beAbleToUpdate = beAbleToUpdate
            self.isOffsetting = isOffsetting
            self.offsetVal = offsetVal
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) ->  UIScrollView {
        let view = UIScrollView()
        
        setUp(view: view)
        
        if beAbleToUpdate{
//            self.refreshController.attributedTitle = NSAttributedString(string: "Loading...")
            self.refreshController.tintColor = .white
            self.refreshController.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
            
            self.refreshController.bounds = CGRect(x: self.refreshController.bounds.origin.x, y: self.isOffsetting ? -offsetVal : 0, width: self.refreshController.bounds.width, height: self.refreshController.bounds.height)
            view.refreshControl = self.refreshController //need to add  after setting up
        }
//        setUpController(view: view)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //TO UPDATE CURRENT VIEW
        setUp(view: uiView)
//        setUpController(view: uiView)
        uiView.delegate = context.coordinator
    }
    
//    private func setUpController(view : UIScrollView){
//
//    }
    
    private func setUp(view : UIScrollView){
        let host = UIHostingController(rootView: self.content.frame(maxHeight: .infinity, alignment: .top))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        //our swiftui view add the constrans to uiview
        
        let constrains = [ //UIKit autolayout to swiftUI layout
            host.view.topAnchor.constraint(equalTo: view.topAnchor,constant: self.isOffsetting ? offsetVal : 0),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            host.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            host.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,constant: 1),
        ]
        
        //here we need to remove the previous view before adding a new view, only for updating case
        view.subviews.last?.removeFromSuperview() //remove
        view.addSubview(host.view)
        view.showsVerticalScrollIndicator = false
        view.addConstraints(constrains)

    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        var parent : DragRefreshableScrollView
        init(parent : DragRefreshableScrollView){
            self.parent = parent
        }
        
        @objc func onRefresh(){
            parent.onRefresh(parent.refreshController)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            if offsetY > scrollView.contentSize.height - 300 - scrollView.frame.height {
                    if self.parent.beAbleToUpdate && !self.parent.isLoading{
                        self.parent.isLoading = true
                        switch self.parent.dataType {
                        case .Actor:
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                self.parent.dragPreviewModel.getActorsList(updateDataAt: .back, succeed: {
                                    self.parent.isLoading = false
                                }, failed: {
                                    self.parent.isLoading = false
                                    print("data fetching error")
                                })
                            }
                            break
                            
                        case .Director:
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                self.parent.dragPreviewModel.getDirectorList(updateDataAt: .back, succeed: {
                                    self.parent.isLoading = false
                                }, failed: {
                                    self.parent.isLoading = false
                                    print("data fetching error")
                                })
                            }
                            break
                        default:
                            break
                        }
                    }
                
            }
        }
        
    }
}

struct RefreshableScrollView<Content:View> : UIViewRepresentable{

//    @Binding var datas : [T]
    @Binding var isLoading : Bool
    var content : Content
    var onRefresh : (UIRefreshControl)->()
    var beAbleToUpdate : Bool
    var refreshController = UIRefreshControl()
    init(
//        datas : Binding<[T]>,
        isLoading : Binding<Bool>,
        beAbleToUpdate : Bool,
//        isOffsetting:Bool = false,
//        offsetVal:CGFloat = 0,
        @ViewBuilder content: @escaping ()->Content,
        onRefresh: @escaping (UIRefreshControl)->()){
            self.content = content()
            self.onRefresh = onRefresh
            self._isLoading = isLoading
//            self._datas = datas
//            self.dataType = dataType
            self.beAbleToUpdate = beAbleToUpdate
//            self.isOffsetting = isOffsetting
//            self.offsetVal = offsetVal
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) ->  UIScrollView {
        let view = UIScrollView()
        
        setUp(view: view)
        view.backgroundColor = UIColor(named: "DarkMode2")
        
        if beAbleToUpdate{
            self.refreshController.attributedTitle = NSAttributedString(string: "Loading...")
            self.refreshController.tintColor = .white
            self.refreshController.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
            
            self.refreshController.bounds = CGRect(x: self.refreshController.bounds.origin.x, y: 0, width: self.refreshController.bounds.width, height: self.refreshController.bounds.height)
            view.refreshControl = self.refreshController //need to add  after setting up
        }
//        setUpController(view: view)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //TO UPDATE CURRENT VIEW
        setUp(view: uiView)
//        setUpController(view: uiView)
        uiView.delegate = context.coordinator
    }
    
//    private func setUpController(view : UIScrollView){
//
//    }
    
    private func setUp(view : UIScrollView){
        let host = UIHostingController(rootView: self.content.frame(maxHeight: .infinity, alignment: .top))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        //our swiftui view add the constrans to uiview
        
        let constrains = [ //UIKit autolayout to swiftUI layout
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            host.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            host.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,constant: 1),
        ]
        
        //here we need to remove the previous view before adding a new view, only for updating case
        view.subviews.last?.removeFromSuperview() //remove
        view.addSubview(host.view)
        view.showsVerticalScrollIndicator = false
        view.addConstraints(constrains)

    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        var parent : RefreshableScrollView
        init(parent : RefreshableScrollView){
            self.parent = parent
        }
        
        @objc func onRefresh(){
            parent.onRefresh(parent.refreshController)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            if offsetY > scrollView.contentSize.height - 300 - scrollView.frame.height {
                    if self.parent.beAbleToUpdate && !self.parent.isLoading{
                      print("loading....")
                    }
                
            }
        }
        
    }
}

