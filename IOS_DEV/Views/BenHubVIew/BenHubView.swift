//
//  BenHubView.swift
//  IOS_DEV
//
//  Created by Jackson on 3/9/2022.
//

import SwiftUI

enum BenHubType {
    case Wait
    case Alert
}

struct BenHub <Content : View>: View {
    let type : BenHubType
    @ViewBuilder var content : Content
    var body: some View {
        
        if type == .Wait{
            content
                .padding(.horizontal,12)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("appleDark"))
                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 5)
                )
        }else if type == .Alert{
            content
                .padding(.horizontal,12)
                .padding(16)
                .background(
                    Capsule()
                        .foregroundColor(Color("appleDark"))
                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 5)
                )
        }
    }
}

extension View {
    func wait<Content : View>(isLoading : Binding<Bool>,@ViewBuilder content : () -> Content) -> some View{
        ZStack{
            self
            
            if isLoading.wrappedValue {
                Color.black.opacity(0.5).frame(maxWidth:.infinity,maxHeight: .infinity).edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                BenHub(type:.Wait,content: content)
                    .zIndex(2)
            }
        }
    }
    
    func alert<Content : View>(isAlert : Binding<Bool>,@ViewBuilder content : () -> Content) -> some View{
        ZStack(alignment:.top){
            self
            
            if isAlert.wrappedValue {
                BenHub(type:.Alert,content: content)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                    .onAppear{
//                        print("???")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            print("disappear")
                            withAnimation{
                                isAlert.wrappedValue = false
                                print(isAlert.wrappedValue)
                            }
                        }
                    }
            }
        }
    }
    
    func notify<Content : View>(isAlert : Binding<Bool>,@ViewBuilder content : () -> Content) -> some View{
        ZStack(alignment:.bottom){
            self
            
//            if isAlert.wrappedValue {
//                BenHub(type:.Alert,content: content)
//                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
//                    .zIndex(1)
//                    .onAppear{
////                        print("???")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                            print("disappear")
//                            withAnimation{
//                                isAlert.wrappedValue = false
//                                print(isAlert.wrappedValue)
//                            }
//                        }
//                    }
//            }
        }
    }
}


struct BenHubLoadingView : View {
    let message : String
    var body: some View {
        VStack{
            ActivityIndicatorView()
            
            Text(message)
                .font(.system(size: 14,weight:.semibold))
        }
        .padding(15)
      
    }
}

struct BenHubAlertView : View {
    let message : String
    let sysImg : String
    var body: some View {
        HStack(spacing:8){
            Image(systemName: sysImg)
                .imageScale(.medium)
            Text(message)
                .font(.system(size: 14,weight:.semibold))
        }
    }
}

struct BenHubAlertWithFriendRequest : View {
    let user : SimpleUserInfo
    let message : String
    var body: some View{
        HStack{
            //UserAvatar
            
            //Message
            AsyncImage(url: user.UserPhotoURL){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ActivityIndicatorView()
                }
                .frame(width: 30,height:30)
                .clipShape(Circle())
                .clipped()
            
            Text(message)
                .font(.system(size: 14,weight:.semibold))
        }
    }
    
}
struct BenHubAlertWithMessage : View {
    let user : SimpleUserInfo
    let message : String
    var body: some View{
        HStack{
            //UserAvatar
            
            //Message
            AsyncImage(url: user.UserPhotoURL){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ActivityIndicatorView()
                }
                .frame(width: 30,height:30)
                .clipShape(Circle())
                .clipped()
            VStack(alignment:.leading,spacing: 8){
                Text("收到新的訊息")
                    .font(.system(size: 15, weight: .bold))
                Text(message)
                    .font(.system(size: 14,weight:.semibold))
                    .lineLimit(1)
            }

        }
    }
}
