//
//  HalfSheet.swift
//  IOS_DEV
//
//  Created by Jackson on 30/7/2022.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func halfSheetForComment<SheetView : View>(showShate : Binding<Bool>, isSelectedData: Binding<Post?>,@ViewBuilder sheetView: @escaping () -> SheetView,onEnded: @escaping ()->())-> some View{
        return self
            .background(
                UIHalfSheetViewForComment(sheetView: sheetView(), isShow: showShate, isSelectedData: isSelectedData, onEnded: onEnded)
            )
    }
    
    func halfSheet<SheetView : View>(showShate : Binding<Bool>,@ViewBuilder sheetView: @escaping () -> SheetView,onEnded: @escaping ()->())-> some View{
        return self
            .background(
                UIHalfSheetView(sheetView: sheetView(), isShow: showShate, onEnded: onEnded)
            )
    }
    
}

struct UIHalfSheetViewForComment<SheetView : View> : UIViewControllerRepresentable {
    var sheetView : SheetView
    @Binding var isShow : Bool
    @Binding var isSelectedData : Post?
    var onEnded : () -> ()

    let controller = UIViewController()
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isShow && isSelectedData != nil{
            let sheetController = CustomHostingControllerAllDentents(rootView:  sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true,completion: nil)
            
        }else {
            uiViewController.dismiss(animated: true,completion: nil)
        }
    }

    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent : UIHalfSheetViewForComment
        init (parent : UIHalfSheetViewForComment){
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.onEnded()
        }
   
    }
}

struct UIHalfSheetView<SheetView : View> : UIViewControllerRepresentable {
    var sheetView : SheetView
    @Binding var isShow : Bool
    var onEnded : () -> ()

    let controller = UIViewController()
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isShow {
            let sheetController = CustomHostingControllerMediumOnly(rootView:  sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            DispatchQueue.main.async {
                uiViewController.present(sheetController, animated: true,completion: nil)
            }
        }else {
            DispatchQueue.main.async {
                uiViewController.dismiss(animated: true,completion: nil)
            }
        }
    }

    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent : UIHalfSheetView
        init (parent : UIHalfSheetView){
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            self.parent.isShow = false
            parent.onEnded()
        }
   
    }
}


class CustomHostingControllerAllDentents<Content : View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as?  UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        definesPresentationContext = true

    }
    
}

class CustomHostingControllerMediumOnly<Content : View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as?  UISheetPresentationController {
            presentationController.detents = [
                .medium(),
            ]
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        definesPresentationContext = true
    }
    
}
