//
//  ExtenedScrollView.swift
//  IOS_DEV
//
//  Created by Jackson on 24/11/2022.
//

import Foundation
import SwiftUI
import Combine

enum ScrollingState  {
    case normal
    
    case pullUp //ready
    case PullDown //ready
    
    case refershHeader //loading
    case refershFooter //loading
}

class ScrollState : ObservableObject {
    //init scroll offset y
    var initOffsetY : CGFloat = 0
    
    //update pull view hegiht
    let progressViewHeight : CGFloat = 80
    @Published var progressViewCurrentHeight : CGFloat = 0 //pulling scrolling offset Y
    //current offset
    @Published var currOffset : CGFloat = 0
    
    var scrollHeight : CGFloat = 0
    var scrollContentHeight : CGFloat = 0
    @Published var refershFooterCurHeight : CGFloat = 0 //loading more / pull down offset Y
    
    //PullState
    @Published var state : ScrollingState = .normal
    
    private var cancelables : Set<AnyCancellable> = []
    
    private var updateProgressViewHightPublisher : AnyPublisher<CGFloat,Never> {
        Publishers.CombineLatest($currOffset,$state)
            .map {currOffset,state -> CGFloat in
                var _progressViewHeight : CGFloat = currOffset - self.initOffsetY
                if state == .refershHeader {
                    if _progressViewHeight < self.progressViewHeight{
                        _progressViewHeight = self.progressViewHeight
                    }
                }
                
                if _progressViewHeight < 0 {
                    _progressViewHeight = 0
                }
                
                return _progressViewHeight
            }.eraseToAnyPublisher()
    }
    
    private var canRefershPublisher : AnyPublisher<Bool,Never> {
        Publishers.CombineLatest($currOffset,$state)
            .map{ currOffset,state -> Bool in
                if currOffset - self.initOffsetY <= self.progressViewHeight && state == .PullDown {
                    return true
                }else {
                    return false
                }
            }.eraseToAnyPublisher()
    }
    
    init(){
        updateProgressViewHightPublisher
            .dropFirst()
            .removeDuplicates()
            .sink { height in
                DispatchQueue.main.async {
                    if self.state == .PullDown {
                        self.progressViewCurrentHeight = height
                    }else {
                        withAnimation{
                            self.progressViewCurrentHeight = height
                        }
                    }
                    
                }
            }
            .store(in: &cancelables)
        
        canRefershPublisher
            .dropFirst()
            .removeDuplicates()
            .sink{ canRefersh in
                if canRefersh {
                    print("can refersh")
                    self.state = .refershHeader
                }
            }
            .store(in: &cancelables)
    }
}


typealias ScrollRefershCompletion = () -> Void
typealias ScrollOnRefersh = (@escaping ScrollRefershCompletion) -> Void

struct ExtenedScrollView<Content : View>: View {
    @StateObject var state = ScrollState()
    
    var content : () -> (Content)
    var onRefershHeader : ScrollOnRefersh
    var onRefershFooter : ScrollOnRefersh
    
    @Binding var isRefershHeader : Bool
    @Binding var isRefershFooter : Bool
    init(isRefershHeader : Binding<Bool> = .constant(true),isRefershFooter : Binding<Bool>  = .constant(true),onRefershHeader : @escaping ScrollOnRefersh,onRefershFooter: @escaping ScrollOnRefersh,@ViewBuilder content : @escaping  ()->(Content) ){
        self.content = content
        self.onRefershHeader = onRefershHeader
        self.onRefershFooter = onRefershFooter
        self._isRefershHeader = isRefershHeader
        self._isRefershFooter = isRefershFooter
    }
    
    var body: some View {
        VStack(spacing:0){
            ScrollView(.vertical){
                ZStack(alignment:.bottom){
                    VStack(spacing:0){
                        GeometryReader{ reader -> AnyView in
//                            print(reader.frame(in: .global).minY)
                            let minY = reader.frame(in: .global).minY
                            if state.initOffsetY == 0 {
                                state.initOffsetY = minY
                            }
                            
                            DispatchQueue.main.async {

                                state.currOffset = minY
                                
//                                if self.isRefershFooter{
                                    let _refershFooterCurrentHeigh = state.initOffsetY - minY + state.scrollHeight - state.scrollContentHeight
                                    print(_refershFooterCurrentHeigh)
                                    if _refershFooterCurrentHeigh > 0 && state.state != .refershFooter {
                                        state.refershFooterCurHeight = _refershFooterCurrentHeigh
                                    }

                                    if _refershFooterCurrentHeigh > state.progressViewHeight && state.state == .normal{
                                        withAnimation{
                                            state.state = .pullUp
                                        }
                                    }

                                    if _refershFooterCurrentHeigh < state.progressViewHeight && state.state == .pullUp {
                                        withAnimation{
                                            state.state = .refershFooter
                                        }
                                    }
//                                }
                                
                                //setting scrolling state
//                                if self.isRefershHeader {
                                    if state.currOffset - state.initOffsetY > state.progressViewHeight && state.state == .normal {
                                        withAnimation{
                                            state.state = .PullDown //can pulled
                                        }
                                    }
                                    
//                                }
       
                            }
                            
                            return AnyView(Color.clear)
                        }
                        
                        if self.isRefershHeader{
                            VStack(spacing:0){
                                Spacer(minLength: 0)
                                if state.state == .refershHeader{
                                    ActivityIndicatorView()
                                        .frame(height: state.progressViewHeight)
                                } else {
                                    Image(systemName: "arrow.down")
                                        .frame(height: state.progressViewHeight)
                                        .rotationEffect(.degrees(self.state.state == .normal ? 0 : 180))
                                        .opacity(self.state.progressViewCurrentHeight == 0 ? 0 : 1)
                                }
                            }
                            .frame(height:state.progressViewCurrentHeight)
                            .frame(maxWidth:.infinity)
                            .clipped()
                        }
                        //
                        content()
                        
                        
                    }
                    .overlay{
                        GeometryReader { proxy -> AnyView in
                            let height = proxy.frame(in: .global).height
                            DispatchQueue.main.async {
                                if state.scrollContentHeight != height {
                                    state.scrollContentHeight = height
                                }
                            }
                            
                            return AnyView(Color.clear)
                        }
                    }
                    .offset(y : self.state.state == .refershFooter && self.isRefershFooter ? -self.state.progressViewHeight : 0)
                    
                    
                    VStack {
                        Spacer(minLength: 0)
                        if state.state == .refershFooter{
                            ActivityIndicatorView()
                                .frame(height: state.progressViewHeight)
                        } else {
                            Image(systemName: "arrow.up")
                                .frame(height: state.progressViewHeight)
                                .rotationEffect(.degrees(self.state.state == .normal ? 0 : 180))
                                .opacity(self.state.refershFooterCurHeight == 0 ? 0 : 1)
                        }
                    }
                    .frame(height:state.state == .refershFooter ? state.progressViewHeight : state.refershFooterCurHeight)
                    .clipped()
                    .offset(y : state.state == .refershFooter ? 0 : state.refershFooterCurHeight)
                    .zIndex(1)
                }
                
                //offset a progress view
            }
            .edgesIgnoringSafeArea(.all)
//            .overlay{
//                GeometryReader { proxy -> AnyView in
//                    //Getting whole scroll view height
//                    let height = proxy.frame(in: .global).height
//                    DispatchQueue.main.async {
//                        if state.scrollHeight != height{
//                            state.scrollHeight = height
//                        }
//                    }
//                    return AnyView(Color.clear)
//                }
//            }
            .onChange(of: state.state){ newVal in
                if newVal == .refershHeader {
                    onRefershHeader {
                        DispatchQueue.main.async {
                            self.state.state = .normal
                        }
                    }
                }
                
                if newVal == .refershFooter {
                    print("??refering???")
                    onRefershFooter {
                        DispatchQueue.main.async {
                            self.state.state = .normal
                        }
                    }
                }
            }
        }
    }
}


