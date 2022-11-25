//
//  postShareView.swift
//  IOS_DEV
//
//  Created by Jackson on 24/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SnapCard : View {
    //postData Here
    @Binding var isAnimated : Bool
    var postInfo : Post
    init(isAnimated : Binding<Bool>,postInfo:Post){
        self._isAnimated = isAnimated
        self.postInfo = postInfo
    }
    var body : some View{
        ZStack{
            WebImage(url:postInfo.post_movie_info.PosterURL)
                .placeholder(Image(systemName: "photo")) //
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height).edgesIgnoringSafeArea(.all)
                .overlay(BlurView().frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height).edgesIgnoringSafeArea(.all))
           
               
            
            VStack{
                ZStack(alignment:.bottomLeading){
                    WebImage(url:postInfo.post_movie_info.PosterURL)
                        .placeholder(Image(systemName: "photo")) //
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            LinearGradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.1),
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.6),
                                Color.black.opacity(0.8),
                                Color.black
                            ], startPoint: .top, endPoint: .bottom))
                        .clipShape(CustomeConer(width: 10, height: 10,coners: [.allCorners]))
                        
                    VStack(alignment:.leading){
                        HStack(alignment:.bottom){
                            WebImage(url:postInfo.user_info.UserPhotoURL)
                                .placeholder(Image(systemName: "photo")) //
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40,height:40)
                                .clipShape(Circle())
                                .clipped()
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            VStack(alignment:.leading){
                                Text(postInfo.user_info.name).bold()
                                    .font(.system(size: 15,weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("@\(postInfo.user_info.name)")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                    .foregroundColor(.white)
                                
                            }
                        }
                        
                        Text("\"\(postInfo.post_title + postInfo.post_desc)\"")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .font(.system(size: 12,weight: .semibold))
                    }
                    .padding()
                    
                        
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width / 1.2)
            .opacity(self.isAnimated ? 1 : 0)
            .offset(y: self.isAnimated ?  0 : -UIScreen.main.bounds.height)
//            .rotationEffect(.degrees(-180), anchor: UnitPoint(x: 0, y: 0))
            .animation(.spring())
            .transition(.move(edge: .top))

        }
        .frame(maxWidth:.infinity,maxHeight: .infinity).ignoresSafeArea()

    }
}

struct SharingView : View {
    //need the post data
    @EnvironmentObject private var postVM : PostVM
    @State private var isAnimated = false
    @State private var buttonAnimation = false
    var postInfo : Post
    var body : some View {
        ZStack(alignment:.bottom){
            BuildSnapCard()
            
            ShareSheet()
        }
        .frame(maxWidth:.infinity)
        .ignoresSafeArea()
        
    }
    
    @ViewBuilder
    private func ShareSheet() -> some View {
        VStack(alignment:.leading){
            HStack{
                Button(action:{
                    withAnimation(){
                        self.postVM.isSharePost.toggle()
                    }
                }){
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                }
                .foregroundColor(.white)
                Spacer()
                    
            }
            .padding(.horizontal)
            .padding(.vertical,5)
            .overlay(
                Text("分享至")
                    .foregroundColor(.white)
                    .font(.system(size: 14,weight: .semibold))
            )
            
            Divider()
            
            HStack(spacing:12){
                
                VStack{
                    Button(action:{
                        saveToAlbums()
                    }){
                        Image(systemName:"arrow.down.to.line")
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                            .background(Color("DarkMode"))
                            .clipShape(Circle())
                    }
                    
                    Text("保存")
                        .font(.system(size: 14,weight: .medium))
                        .foregroundColor(.gray)
                }
                
 
                VStack{
                    
                    Button(action:{
                        let viewImg = BuildSnapCard().asImage
                        withAnimation{
                            shareTo(uiImage: viewImg, urlScheme: URL(string: "instagram-stories://share")!)
                        }
                    }){
                        Image("ig-circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Text("動態")
                        .font(.system(size: 14,weight: .medium))
                        .foregroundColor(.gray)
                }
                
                
   
            }
            .padding(.horizontal)
            .offset(y: self.buttonAnimation ?  0 : UIScreen.main.bounds.height)
            .animation(.spring())
            .transition(.move(edge: .bottom))
        }
        .padding(.vertical)
        .padding(.bottom)
//        .padding(UIScreen.screens.)
        .frame(maxWidth:.infinity)
        .background(Color("appleDark"))
        .clipShape(CustomeConer(width: 10, height: 10, coners: [.topLeft,.topRight]))
        .ignoresSafeArea()
        .onAppear(){
            withAnimation{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.isAnimated = true
                }
 
                self.buttonAnimation = true
            }
            
        }
            
    }
    
    @ViewBuilder
    private func BuildSnapCard() -> some View {
        SnapCard(isAnimated: $isAnimated, postInfo: postInfo)
    }
    
    private func saveToAlbums(){
        let viewImage = BuildSnapCard().asImage
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil)
        
    }
    
    private func shareTo(uiImage : UIImage, urlScheme: URL){
        guard let imageData : Data = uiImage.pngData() else { return }
        let items = [["com.instagram.sharedSticker.backgroundImage":imageData]]
        let opt = [UIPasteboard.OptionsKey.expirationDate:Date().addingTimeInterval(60*5)]
        UIPasteboard.general.setItems(items,options: opt)
        UIApplication.shared.open(urlScheme,options: [:],completionHandler: nil)
    }
    
}
