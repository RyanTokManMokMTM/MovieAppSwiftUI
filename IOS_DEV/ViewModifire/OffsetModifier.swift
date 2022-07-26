//
//  OffsetModifier.swift
//  IOS_DEV
//
//  Created by Jackson on 8/9/2021.
//

import Foundation
import SwiftUI

struct PersonPageOffsetModifier : ViewModifier {
    @Binding var offset : CGFloat
    @Binding var isShowIcon : Bool
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    DispatchQueue.main.async {
                        self.offset = minY
                        print(minY)
                        
                        if -minY > 110{
                            withAnimation(.easeInOut(duration: 0.3)){
                                self.isShowIcon = true
                            }
                        }else if -minY < 100{
                            withAnimation(.easeInOut(duration: 0.3)){
                                self.isShowIcon = false
                            }
                        }
                        
                    }
                    return Color.clear
                    
                }
                ,alignment: .top
            )
    }
}

struct MovieDetailPageOffsetModifier : ViewModifier {
    @Binding var offset : CGFloat
    @Binding var isShowIcon : Bool
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    DispatchQueue.main.async {
                        self.offset = minY
                        if -minY > 110{
                            withAnimation(.spring()){
                                self.isShowIcon = true
                            }
                        }else if -minY < 100{
                            withAnimation(.spring()){
                                self.isShowIcon = false
                            }
                        }
                    }
                    return Color.clear
                    
                }
                ,alignment: .top
            )
    }
}

struct GenralOffsetModifier : ViewModifier{
    @Binding var offset : CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{proxy -> Color in
                    let minY = proxy.frame(in: .named("Genral")).minY
                    DispatchQueue.main.async {
                        self.offset = minY
                        print(minY)
                    }
                    return Color.clear
                    
                }
                ,alignment: .top
            )
    }
}

struct OffsetModifier: ViewModifier {
    @Binding var offset : CGFloat
    @State private var startValue : CGFloat = 0
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value:proxy.frame(in:.global).minY)
                }
            )
            .onPreferenceChange(OffsetKey.self){offset in
                if self.startValue == 0{
                    self.startValue = offset //current view starting point
                }
                self.offset = offset - startValue //current offset - starting point
//                print( self.offset)
            }
    }
}

struct OffsetKey : PreferenceKey{
    static var defaultValue : CGFloat = 0
    
    static func reduce(value : inout CGFloat,nextValue:()->CGFloat){
      //  print("current change : \(value)")
        value = nextValue()
    }
}

