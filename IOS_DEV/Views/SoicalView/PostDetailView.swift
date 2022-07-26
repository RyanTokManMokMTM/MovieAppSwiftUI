//
//  PostDetailView.swift
//  IOS_DEV
//
//  Created by Jackson on 10/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct PostDetailView: View {
    var namespace : Namespace.ID
    var postData : Post
    @State private var value : CGSize = .zero
    @Binding var isShow : Bool
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing:0){
                PostDetailViewTopBar(namespace: namespace, postData: postData,isShow: $isShow)
                
                //Image tab view
                ScrollView(.vertical, showsIndicators: false){
                    PostDetailDescView(namespace: namespace,postData: postData)
                        
                }
                .frame(maxHeight:.infinity,alignment:.top)
//                .edgesIgnoringSafeArea(.all)
            }
//            .edgesIgnoringSafeArea(.all)
//            .ignoresSafeArea()
            
            
        }
        .frame(maxHeight:.infinity,alignment: .top)
        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
        .scaleEffect(self.value.width / -500 + 1)
        .gesture(
            DragGesture()
                .onChanged{ value in
                    guard value.translation.width > 0 else {return }

                    //left only
                    if value.translation.width < 100 {
                        self.value = value.translation
                    }
                }
                .onEnded{ value in
                    withAnimation(.spring()){
                        if value.translation.width > 80 {
                            self.isShow.toggle()
                        }else {
                            self.value = .zero
                        }
                    }
                }
        )
        
    }
}

struct PostDetailViewTopBar : View {
    var namespace : Namespace.ID
    var postData : Post
    @Binding var isShow : Bool
    @State private var isFollowing = false
    var body: some View{
        HStack(alignment:.center){
            Button(action:{
                withAnimation(){
                    self.isShow = false
                }
            }){
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    
                    
            }
            .padding(.horizontal,5)
            
            
            WebImage(url:postData.user_info.UserPhotoURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
//                .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
            
            Text(postData.user_info.name)
                .font(.system(size: 14, weight: .semibold))
//                .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
            
            Spacer()
            
            Button(action:{
                withAnimation{
                    self.isFollowing.toggle()
                }
            }){
                Text(self.isFollowing ? "Following" : "Follow")
                    .foregroundColor(self.isFollowing ? Color.white.opacity(0.8) : .red)
                    .font(.system(size: 14))
                    .padding(5)
                    .padding(.horizontal,5)
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isFollowing ? Color.white.opacity(0.8) : .red))
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal,5)
     
        .frame(width:UIScreen.main.bounds.width,height:UIApplication.shared.keyWindow?.safeAreaInsets.top)
        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
    }
}

struct PostDetailDescView : View {
    @EnvironmentObject var userVM : UserViewModel
    var namespace : Namespace.ID
    var postData : Post
    @State private var index = 0
    @State private var commentText : String = ""

    var body: some View {
        VStack(spacing:5){
            ZStack(alignment:.topTrailing){
//                TabView(selection:$index){
                WebImage(url: postData.post_movie_info.PosterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "\(postData.user_info.id)_\(postData.post_movie_info.id)_\(postData.create_at)", in: namespace)
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
                       
                .matchedGeometryEffect(id: postData.post_movie_info.id, in: namespace)
                .frame(width: UIScreen.main.bounds.width)
                //maxinum image is 10
                Text("\(index + 1)/1")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(8)
                    .padding(.horizontal,5)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 20, height: 20, coners: .allCorners)))
                    .offset(x: -10, y: 10)
    //                .overlay(RoundedRectangle(cornerRadius: 25).stroke())
            }
            .frame(height: UIScreen.main.bounds.height / 2.2)
            
            
            HStack(spacing:5){
                ForEach(1..<2){i in
                    Circle()
                        .fill(self.index + 1 == i ? .red : .gray)
                        .frame(width: 5, height: 5)
                        .scaleEffect(self.index + 1 == i ? 1.2 : 0.9)
                        .animation(.spring())
                }
            }
            VStack{
                VStack(alignment: .leading, spacing:8){
                    PostContent()
                    CommentView()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
//        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func PostContent() -> some View{
   
            //Jump to the detail view

            Button(action:{}){
                Text("#\(postData.post_movie_info.title)")
                    .font(.system(size: 15))
                    .foregroundColor(.red)
            }
            
            
        Text(postData.post_title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
//                .matchedGeometryEffect(id: postData.post_title, in: namespace)
                .multilineTextAlignment(.leading)
        
        Text(postData.post_desc)
            .font(.system(size: 15,weight: .regular))
                .multilineTextAlignment(.leading)
                .lineSpacing(8)
            
//        //Testing only
//            HStack{
//                Text("#劇透")
//                Text("#電影劇情分享")
////                Text("#奇異博士")
////                Text("#漫威")
//            }
//            .foregroundColor(.blue)
//            .font(.system(size: 15,weight: .semibold))
        
        Text("Posted at \(postData.post_at.dateDescriptiveString())")
            .foregroundColor(Color(uiColor: .systemGray2))
                .font(.caption2)
            
            PostViewDivider
        
    }
    
    @ViewBuilder
    func CommentView() -> some View{
        Text("Comments : \(postData.post_comment_count)")
            .foregroundColor(.white)
            .font(.system(size: 14,weight: .medium))
        
        HStack{
            WebImage(url: userVM.profile!.UserPhotoURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            HStack{
                TextField("留下您寶貴的評論", text: $commentText)
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    .submitLabel(.done)
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(CustomeConer(width: 20, height: 20, coners: [.allCorners]))
        }
        .padding(.top)
        
        
        //All Comment
        PostViewDivider
        
        if postData.comments != nil && postData.comments!.count == 0 {
            HStack{
                Spacer()
                Image(systemName: "text.bubble")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
                Text("沒有評論,趕緊霸佔一樓空位!")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                Spacer()
            }
        }else {
            ForEach(postData.comments!,id:\.id){ info in
                HStack(alignment:.top){
    //                HStack(alignment:.center){
                    WebImage(url: info.user_info.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        
                        VStack(alignment:.leading,spacing: 3){
                            Text(info.user_info.user_name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGray))
                            
                            
                            Text(info.comment)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text(info.comment_time.dateDescriptiveString())
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                        
    //                }
                    Spacer()
                    
                    Image(systemName: "heart")
                        .imageScale(.medium)
                }
                
                PostViewDivider
                    .padding(.vertical,5)
            }
            
            HStack{
                Spacer()
                Text("The End ~ ")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}


var PostViewDivider : some View {
    Divider()
        .background(Color("DetechingColor"))
        .padding(.vertical,5)
}
