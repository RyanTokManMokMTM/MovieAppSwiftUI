//
//  NotificationTopView.swift
//  IOS_DEV
//
//  Created by Jackson on 31/8/2022.
//

import SwiftUI

struct NotificationView<Content : View>: View {
    @Binding var isShowView : Bool
    var topTitle : String
    var content : () -> Content
    var body: some View {
        GeometryReader{proxy in
            VStack(alignment:.leading,spacing:0){
                VStack{
                    HStack(){
                        Button(action:{
                            withAnimation{
                                isShowView = false
                            }
                        }){
                           Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                     
                    }
                    .overlay(
                        HStack{
                            Text(topTitle)
                                .font(.system(size:14,weight:.bold))
                                .foregroundColor(.white)
//                                .padding(.bottom,10)
                        }
                    
                    )
                    .font(.system(size: 14))
                    .padding(.horizontal,10)
                    .padding(.bottom,10)
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                .background(Color("DarkMode2"))
                Divider()
                
                content()
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
