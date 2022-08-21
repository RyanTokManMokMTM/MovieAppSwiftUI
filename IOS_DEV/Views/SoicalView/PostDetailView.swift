//
//  PostDetailView.swift
//  IOS_DEV
//
//  Created by Jackson on 10/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct PostDetailView: View {
    @EnvironmentObject var postVM : PostVM
    @State private var value : CGSize = .zero
    @State private var message : String = ""
    @FocusState private var isFocues : Bool
    
    @State private var isShowUserProfile : Bool = false
    @State private var shownUserID : Int = 0
    
    @State private var isUserFollowing : Bool = false
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing:0){
                PostDetailViewTopBar(isShowUserProfile: self.$isShowUserProfile,userID:$shownUserID, isFollowing: $isUserFollowing)
                
                //Image tab view
                ScrollView(.vertical, showsIndicators: false){
                    PostDetailDescView()
                    
                }
                //                .frame(maxHeight:.infinity,alignment:.top)
                CommentArea()
            }
        }
        //        .frame(maxHeight:.infinity,alignment: .top)/
        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
        .contentShape(Rectangle())
        .background(
            NavigationLink(destination:OtherUserProfile(userID: shownUserID)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                           ,isActive: $isShowUserProfile){
                EmptyView()
            }
        
        
        )
        .onAppear{
            IsUserFollowing()
        }
        
        
    
//        .onDisappear{
//            if !self.postVM.isShowPostDetail {
//                self.postVM.selectedPost = nil
//            }
//        }
//        .offset(x : self.value.width)
////        .scaleEffect(self.value.width > (self.value.width / 2) ? self.value.width / -500 + 1 : 1)
//        .gesture(
//            DragGesture()
//                .onChanged{ value in
//                    guard value.translation.width > 0 else {return }
//
//                    //left only
////                    if value.translation.width < 100 {
//                        self.value = value.translation
////                    }
//                }
//                .onEnded{ value in
//                    withAnimation(.spring()){
//                        if value.translation.width > 80 {
//                            self.postVM.isShowPostDetail.toggle()
//                        }else {
//                            self.value = .zero
//                        }
//                    }
//                }
//        )
        
    }
    
    @ViewBuilder
    func CommentArea() -> some View {
        VStack{
            //                Spacer()
            Divider()
            HStack{
                TextField("留下點什麼~",text:$message)
                    .font(.system(size:14))
                    .padding(.horizontal)
                    .frame(height:35)
                    .background(BlurView())
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocues)
                    .submitLabel(.send)
                    .onSubmit({
                        //TODO: SEND THE COMMENT
                    })
                    .accentColor(.white)
            }
            .padding(.horizontal)
            .frame(height: 35)
        }
        .padding(5)
        
        
    }
    
    func IsUserFollowing(){
        let req = GetOneFriendReq(friend_id: self.postVM.selectedPost!.user_info.id)
        APIService.shared.GetOneFriend(req: req){ result in
            switch result {
            case .success(let data):
                self.isUserFollowing = data.is_friend
                print(self.isUserFollowing)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

struct PostDetailViewTopBar : View {
    @Binding var isShowUserProfile : Bool
    @Binding var userID : Int
    @Binding var isFollowing : Bool
    
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
//    var postData : Post
//    @Binding var isShow : Bool
    
    var body: some View{
        HStack(alignment:.center){
            Button(action:{
                withAnimation(){
                    self.postVM.isShowPostDetail = false
                }
            }){
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    
                    
            }
            .padding(.horizontal,5)
            
            
            Group {
                WebImage(url:self.postVM.selectedPost!.user_info.UserPhotoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
    //                .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
                
                Text(self.postVM.selectedPost!.user_info.name)
                    .font(.system(size: 14, weight: .semibold))
    //                .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
            }
            .onTapGesture{
                if postVM.selectedPost!.user_info.id != userVM.userID {
                    self.userID = self.postVM.selectedPost!.user_info.id
                    withAnimation{
                        self.isShowUserProfile = true
                    }
                }
            }
            
            Spacer()
            
            if self.postVM.selectedPost!.user_info.id != userVM.profile!.id{
                Button(action:{
//                    withAnimation{
                    withAnimation{
                        self.isFollowing.toggle()
                    }
                    if self.isFollowing{
                        followUser()
                    }else {
                        UnFollowUser()
                    }
                        //TODO: Update following state
//                    }
                }){
                    Text(self.isFollowing ? "已關注" : "關注")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding(5)
                        .padding(.horizontal,5)
                        .background(
                            ZStack{
                                if self.isFollowing  {
                                    BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                                        .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isFollowing ? Color.white : Color.clear))
                                }else {
                                    Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                                }
                            }
                        )
                        
                }
            }else {
                Button(action:{
                    //TODO: MODIFY THE POST
                }){
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }

        }
//        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal,5)
        .frame(width:UIScreen.main.bounds.width,height:50)
        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
    }
    
    private func followUser(){
        let req = CreateNewFriendReq(friend_id: self.postVM.selectedPost!.user_info.id)
        APIService.shared.CreateNewFriend(req: req){ result in
            switch result{
            case .success(_):
                print("User Followed")
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isFollowing.toggle()
                }
            }
        }
    }
    
    private func UnFollowUser(){
        let req = RemoveFriendReq(friend_id: self.postVM.selectedPost!.user_info.id)
        APIService.shared.RemoveFriend(req: req){ result in
            switch result{
            case .success(_):
                print("User UnFollowed")
                
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isFollowing.toggle()
                }
            }
        }
    }
}

struct PostDetailDescView : View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @State private var index = 0
    @State private var isShowMoreDetail : Bool = false
    var body: some View {
        VStack(spacing:5){
            ZStack(alignment:.topTrailing){
                //                TabView(selection:$index){
                WebImage(url: self.postVM.selectedPost!.post_movie_info.PosterURL)
                    .placeholder(Image(systemName: "photo")) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
//                    .matchedGeometryEffect(id: self.postVM.selectedPost!.id.description, in: namespace)
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
        NavigationLink(destination: MovieDetailView(movieId: self.postVM.selectedPost!.post_movie_info.id, isShowDetail: $isShowMoreDetail)
                        .environmentObject(postVM)
                       ,isActive: $isShowMoreDetail){
            Text("#\(self.postVM.selectedPost!.post_movie_info.title)")
                .font(.system(size: 15))
                .foregroundColor(.red)
        }

            
        Text(self.postVM.selectedPost!.post_title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
//                .matchedGeometryEffect(id: postData.post_title, in: namespace)
                .multilineTextAlignment(.leading)
        
        Text(self.postVM.selectedPost!.post_desc)
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
        
        Text("Posted at \(self.postVM.selectedPost!.post_at.dateDescriptiveString())")
            .foregroundColor(Color(uiColor: .systemGray2))
                .font(.caption2)
            
            PostViewDivider
        
    }
    
    @ViewBuilder
    func CommentView() -> some View{
        Text("Comments : \(self.postVM.selectedPost!.post_comment_count)")
            .foregroundColor(.white)
            .font(.system(size: 14,weight: .medium))
        
        //This Maybe change ~~
//        HStack{
//            WebImage(url: userVM.profile!.UserPhotoURL)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 35, height: 35)
//                .clipShape(Circle())
//
//            HStack{
//                TextField("留下您寶貴的評論", text: $commentText)
//                    .font(.system(size: 14))
//                    .padding(.horizontal)
//                    .submitLabel(.done)
//            }
//            .padding(8)
//            .background(.ultraThinMaterial)
//            .clipShape(CustomeConer(width: 20, height: 20, coners: [.allCorners]))
//        }
//        .padding(.top)
        
        
        //All Comment
        PostViewDivider
        
        if self.postVM.selectedPost!.comments != nil && self.postVM.selectedPost!.comments!.count == 0 {
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
            ForEach(self.postVM.selectedPost!.comments!,id:\.id){ info in
                HStack(alignment:.top){
    //                HStack(alignment:.center){
                    WebImage(url: info.user_info.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        
                        VStack(alignment:.leading,spacing: 3){
                            Text(info.user_info.name)
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
