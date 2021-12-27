//
//  UIVScrollView.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 3/12/2021.
//

import SwiftUI

struct SearchScrollView<Content:View>: UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return SearchScrollView.Coordinator(parent: self)
    }
    @EnvironmentObject var searchVM : SearchBarViewModel

    @Binding var isLoading : Bool
    let content:Content
    
    init(isLoading:Binding<Bool>,@ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self._isLoading = isLoading
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        setUp(view: view)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //TODO
        setUp(view: uiView)
//        setUpController(view: uiView)
        uiView.delegate = context.coordinator
    }
    
    private func setUp(view : UIScrollView){
        let host = UIHostingController(rootView: self.content.frame(maxHeight:.infinity,alignment:.top))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constrains = [
            host.view.topAnchor.constraint(equalTo: view.topAnchor), //no constraint at top
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor), //no constraint at top bottom
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),//no constraint at leading
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor), //no constraint at trailing
            
            host.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            host.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,constant: 1),
        ]
        
        view.subviews.last?.removeFromSuperview()
        view.addSubview(host.view)
        view.showsVerticalScrollIndicator = false
        view.addConstraints(constrains)
    }
    
    

    class Coordinator:NSObject,UIScrollViewDelegate{
        var parent : SearchScrollView
        init(parent:SearchScrollView){
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            if offsetY > scrollView.contentSize.height - scrollView.frame.height{
                
                if !self.parent.isLoading{
                    withAnimation(){
                        self.parent.isLoading = true //is now loading
                    }
                    self.parent.searchVM.getMoreSearchingResult(succeed: {
                        withAnimation(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                                self.parent.isLoading = false //is now loading
                            }
                        }
                    }, failed: {
                        withAnimation(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                                self.parent.isLoading = false //is now loading
                            }
                        }
                        print("Data is failed to fetched!")
                    })
                }
                
                
            }
        }
    }
}


