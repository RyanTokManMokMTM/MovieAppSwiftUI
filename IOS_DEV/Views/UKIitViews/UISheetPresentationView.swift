//
//  UISheetPresentationView.swift
//  IOS_DEV
//
//  Created by Jackson on 7/8/2022.
//

import SwiftUI
import UIKit

//MARK: FROM https://www.createwithswift.com/using-a-uisheetpresentationcontroller-in-swiftui/

struct UISheetPresentationViewController<Content> : UIViewRepresentable where Content : View {
    
    @Binding var isPresented : Bool
    let onDismiss : (() -> Void)?
    let content : Content
    var detents : [UISheetPresentationController.Detent] //medium,larget
    
    init(
        _ isPresented : Binding<Bool>,
        onDismiss : (() -> Void)? = nil,
        detents :  [UISheetPresentationController.Detent],
        @ViewBuilder content: () -> Content){
            self._isPresented = isPresented
            self.onDismiss = onDismiss
            self.detents = detents
            self.content = content()
        }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPersented: $isPresented, onDismiss: onDismiss)
    }
    
    func makeUIView(context: Context) ->  UIView {
        //TODO
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("update")
        let vc = UIViewController()
        let host = UIHostingController(rootView: self.content)
        
        //adding host to the controller
        vc.addChild(host)
        vc.view.addSubview(host.view)
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.leftAnchor.constraint(equalTo: vc.view.leftAnchor).isActive = true
        host.view.rightAnchor.constraint(equalTo: vc.view.rightAnchor).isActive = true
        host.view.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        host.didMove(toParent: vc)
        
        //controller as sheet controller?
        if let sheetController = vc.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = false
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheetController.largestUndimmedDetentIdentifier = .large
        }
        
        //setup delegate
        vc.presentationController?.delegate = context.coordinator
        
        //present or dismss
        if isPresented {
            uiView.window?.rootViewController?.present(vc, animated: true, completion: nil)
        } else {
            uiView.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    class Coordinator : NSObject,UISheetPresentationControllerDelegate{
        @Binding var isPresented : Bool
        let onDismiss : (()->Void)?
        init(isPersented : Binding<Bool>,onDismiss : (()->Void)? ){
            self.onDismiss = onDismiss
            self._isPresented = isPersented
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
            if let onDismiss = onDismiss {
                onDismiss()
            }
        }
        
    }
    
}


//View Modifier

struct SheetWithDetentsViewModifier<SwiftUIContent> : ViewModifier  where SwiftUIContent : View{
    @Binding var isPresented : Bool
    let onDismiss : (() -> Void)?
    let detents : [UISheetPresentationController.Detent]
    let swiftUIContent : SwiftUIContent
    
    init(
        isPresented : Binding<Bool>,
        detents : [UISheetPresentationController.Detent] = [.medium()],
        onDismiss: (() -> Void)? = nil,
        content : () -> SwiftUIContent
    ){
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        self.swiftUIContent = content()
        self.detents = detents
    }
    
    func body(content: Content) -> some View {
        ZStack{
            UISheetPresentationViewController($isPresented, onDismiss: onDismiss, detents: detents){
                swiftUIContent
            }
            content
        }
    }
    
}

//using modifier

extension View {
    func SheetWithDetents<Content>(
        isPresented : Binding<Bool>,
        detents : [UISheetPresentationController.Detent],
        onDismiss : (()->Void)? ,content : @escaping () -> Content) -> some View where Content : View{
            modifier(SheetWithDetentsViewModifier(isPresented: isPresented, detents: detents, onDismiss: onDismiss, content: content))
    }
    
//    func SheetWithDetentsFull<Content>(
//        isPresented : Binding<Bool>,
//        detents : [UISheetPresentationController.Detent],
//        onDismiss : (()->Void)? ,content : @escaping () -> Content) -> some View where Content : View{
//            modifier(SheetWithDetentsViewModifier(isPresented: isPresented, detents: detents, onDismiss: onDismiss, content: content))
//    }
}
