//
//  SideMenu.swift
//  IOS_DEV
//
//  Created by Jackson on 24/11/2022.
//

import SwiftUI

struct SideMenu : View {
    @EnvironmentObject private var userVM : UserViewModel
    @Binding var isShow : Bool
    @Binding var isLogout : Bool
    @State private var offset = 0.0
    @State private var isAnimated = false
    @State private var isEditProfile = false
    var body : some View {
        VStack{
            menu()
                .offset(x : self.isAnimated ? 0 : -UIScreen.main.bounds.width / 1.5)
                .transition(.move(edge: .leading))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,alignment:.leading)
        .edgesIgnoringSafeArea(.all)
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).onTapGesture {
            withAnimation{
                self.isAnimated = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation{
                    self.isShow.toggle()
                }
            }
        })
        .onAppear(){
            withAnimation{
                self.isAnimated = true
            }
        }
    }
    
    @ViewBuilder
    private func menu() -> some View {
        VStack(alignment:.leading,spacing:12){
            //adding people
            
            Button(action:{
                withAnimation{
                    self.isAnimated = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation{
                        self.isShow.toggle()
                    }
                }
            }){
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .foregroundColor(.gray)
            }
            .padding(.vertical,5)
            
//            memuButton(imageName: "person.fill.badge.plus", title: "添加好友") {
//                print("to add friend?")
//            }
//            Divider()
            
            
            Button(action:{
                withAnimation{
                    self.isEditProfile.toggle()
                }
            }){
                NavigationLink(destination:
                                EditProfile(isEditProfile: $isEditProfile)
                    .environmentObject(userVM)
                               , isActive: $isEditProfile){
                    HStack(spacing:18){
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                            .font(.system(size: 15))
                        Text("修改資料")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.gray)
                }
                
            }
            
//
            
            
            Spacer()
            memuButton(imageName: "arrow.uturn.left", title: "登出"){
                withAnimation{
                    self.isLogout = true
                }
            }
            //setting?
//            Spacer()
        }
        .padding(.horizontal,18)
        .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(.top)
        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .padding(.bottom)
        .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height,alignment:.leading)
        .background(Color("appleDark"))
//        .gesture(
//            DragGesture()
//                .onChanged(self.onChage(value:))
//                .onEnded(self.onEnded(value:))
//        )
//        .offset(x : -self.offset)
        
        
    }
    
    private func onChage(value : DragGesture.Value){
        print(value.translation.width)
        if value.translation.width > 0 {
            self.offset = value.translation.width
        }
    }

    private func onEnded(value : DragGesture.Value){
        if value.translation.width > 0 {
            withAnimation(){
//                let cardHeight = UIScreen.main.bounds.height / 4
//
//                if value.translation.height > cardHeight / 2.8 {
//                    self.previewModel.isShowPreview.toggle()
//                }
                self.offset = 0
            }
        }
    }
    
    @ViewBuilder
    private func memuButton(imageName : String, title: String,action : @escaping ()->()) -> some View{
        Button(action:action){
            HStack(spacing:18){
                Image(systemName: imageName)
                    .imageScale(.large)
                    .font(.system(size: 15))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            .foregroundColor(.gray)
        }
    }
    
}
