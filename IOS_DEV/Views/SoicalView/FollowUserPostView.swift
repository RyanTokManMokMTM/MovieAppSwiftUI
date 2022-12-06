//
//  FollowUserPostView.swift
//  IOS_DEV
//
//  Created by Jackson on 15/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Refresher

struct FollowUserPostView: View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var HubState : BenHubState = BenHubState.shared
    
    @State private var isShowMovieDetail = false
    @State private var movieId = -1
    
    @State private var isShowMorePostDetail : Bool = false
    @State private var postId : Int = -1
    
    @State private var isShowUserProfile : Bool = false
    @State private var shownUserID : Int = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            if postVM.followingData.isEmpty {
                VStack{
                    Text("朋友圈暫無任何文章")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.vertical)
            }else {
                LazyVStack(spacing:0){
                    ForEach(self.$postVM.followingData){ info in
                        FollowPostCell(isShowMovieDetail: $isShowMovieDetail, movieId: $movieId,post : info, isShowMorePostDetail:self.$isShowMorePostDetail, postId: self.$postId,isShowUserProfile: $isShowUserProfile,shownUserID:$shownUserID)
                            .padding(.bottom,20)
                            .task{
                                if postVM.isFolloingLast(postID: info.id){
                                    await self.postVM.LoadMoreFollowingData()
                                }
                            }
                    }
                    
                    
                    if postVM.isFollowingLoadMore {
                        ActivityIndicatorView().padding(.bottom,15)
                    }

                }
            }
        }
        
        .refresher(style: .system){
            await self.postVM.refershFollowingData()
        }
        .SheetWithDetents(isPresented:  self.$isShowMorePostDetail, detents: [.medium()]){
            self.isShowMorePostDetail = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.postId = 0
            }
        } content : {
            PostBottomSheet(isShowMorePostDetail: $isShowMorePostDetail,postId:postId)
                .environmentObject(postVM)
                .environmentObject(userVM)
        }
        .frame(maxWidth:.infinity)
        .background(Color("DarkMode2"))
        .background(
            NavigationLink(destination: MovieDetailView(movieId: movieId, isShowDetail: $isShowMovieDetail)
                            .environmentObject(postVM)
                            .environmentObject(userVM)

                           , isActive: $isShowMovieDetail){
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination:OtherUserProfile(userID: shownUserID,owner: userVM.userID!)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                           ,isActive: $isShowUserProfile){
                EmptyView()
            }
        
        
        )
        .onAppear{
            if postVM.initFollowing {
                HubState.SetWait(message: "Loading")
                self.postVM.GetFollowUserPost(onSucceed: {
                    HubState.isWait = false
                }, onFailed: {errMsg in
                    HubState.isWait = false
                    HubState.AlertMessage(sysImg: "xmark.circle.fill", message: errMsg)
                })
                postVM.initFollowing = false
            }
        }
//        .wait(isLoading: $HubState.isWait){
//            BenHubLoadingView(message: HubState.message)
//        }
//        .alert(isAlert: $HubState.isPresented){
//            BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
//        }
        

    }
    

}


struct FollowPostCell : View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @State private var commentText : String = ""
    
    @Binding var isShowMovieDetail : Bool
    @Binding var movieId : Int
    
//    var Id : Int
    @Binding var post : Post
    @Binding var isShowMorePostDetail : Bool
    @Binding var postId : Int
    @Binding var isShowUserProfile : Bool
    @Binding  var shownUserID : Int
    
    @State private var moreText : Bool = false
    @State private var isShowAll = false
    @State private var isTapToLike = false
    
    @State private var isDelete = false
    
    var body: some View{
        VStack(spacing:10){
            UserInfoCell()
            UserPostInfo()
        }
        .padding(.vertical,5)
        .frame(width: UIScreen.main.bounds.width)
        .alert(isPresented: $isDelete){
            withAnimation(){
                Alert(title: Text("刪除當前文章"), message: Text("確定刪掉?"),
                      primaryButton: .default(Text("取消")){},
                      secondaryButton: .default(Text("刪除")){
                        Task.init{
                            await self.DeletePost(postID:self.post.id)
                        }
                })
            }
        }

    }
    
    
    
    @ViewBuilder
    func UserInfoCell() -> some View{
        HStack(alignment:.center){
            Group{
                WebImage(url:self.post.user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                
                
                VStack(alignment:.leading){
                    HStack(alignment:.center, spacing:10){
                        Text(self.post.user_info.name)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(self.post.post_at.dateDescriptiveString())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text("@\(self.post.user_info.name)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture{
                if self.post.user_info.id != userVM.userID {
                    self.shownUserID = self.post.user_info.id
                    withAnimation{
                        self.isShowUserProfile = true
                    }
                }
            }
           
            Spacer()

            Menu(content: {
                if self.post.user_info.id == userVM.userID {
                    Button(action: {
                        // delete the selected post if user is owner
                    }) {
                        HStack {
                            Text("編輯")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    Button(action: {
                        // delete the selected post if user is owner
                        withAnimation{
                            isDelete = true
                        }
                    }) {
                        HStack {
                            Text("刪除")
                            Image(systemName: "trash")
                        }
                    }
                }
                
                Button(action: {
                    // share the post
                    DispatchQueue.main.async {
                        withAnimation{
                            self.postVM.sharedData = self.post
                            self.postVM.isSharePost.toggle()
                        }
                    }
                }) {
                    HStack {
                        Text("分享")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }){
                Label("", systemImage: "ellipsis")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal,10)

    }
    
    @MainActor
    private func DeletePost(postID : Int) async{
        let resp = await APIService.shared.AsyncDeletePost(req: DeletePostReq(post_id: postID))
        switch resp {
        case .success(_):
            withAnimation(){
                self.postVM.isShowPostDetail = false
            }
            
            self.postVM.followingData.removeAll{$0.id == postID}
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    
    @ViewBuilder
    func UserPostInfo() -> some View {
        VStack(alignment: .leading,spacing: 8){
//                TabView(selection:$index){
            WebImage(url:self.post.post_movie_info.PosterURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth:.infinity,maxHeight: UIScreen.main.bounds.height / 2.2)
                .onTapGesture(count: 2){
                    print("liked post")
                    feedBack.impactOccurred(intensity: 0.8)
                    withAnimation{
                        self.isTapToLike = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                        withAnimation{
                            self.isTapToLike = false
                        }
                    }
                    
                    if !self.post.is_post_liked {
                        //liked the post
                        LikePost()
                    }
                }
                .overlay(
                    ZStack{
                        if self.isTapToLike{
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .foregroundColor(.red)
                                .transition(.opacity)
                        }
                    }
                )
            
//            PostButton()
            
            HStack{
                Button(action:{
                    withAnimation{
                        self.isShowMovieDetail = true
                    }
                    self.movieId = self.post.post_movie_info.id
                }){
                    Text("#\(self.post.post_movie_info.title)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top,5)
                }
                Spacer()
                PostButton()
            }

            HStack(alignment:.bottom){
                Text(self.post.post_desc)
                    .lineLimit(self.isShowAll ? nil : 1)
                    .background(
                        Text(self.post.post_desc).lineLimit(1)
                            .background(GeometryReader { visibleTextGeometry in
                                ZStack { //large size zstack to contain any size of text
                                    Text(self.post.post_desc)
                                        .background(GeometryReader { fullTextGeometry in
                                            Color.clear.onAppear {
                                                self.moreText = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                            }
                                        })
                                        
                                }
                                .frame(height: .greatestFiniteMagnitude)
                               
                            })
                            .hidden() //keep hidden
                )
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top,5)
                    .foregroundColor(Color(uiColor: UIColor.lightGray))
  
                if moreText && !isShowAll{
                    Button(action:{
                        //TODO: A BOTTON SHEET SHOW COMMENT LIST AND INFO
//                        self.postId = info.id
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                            withAnimation{
//                                self.isShowMorePostDetail = true
//                            }
//                        }
                        withAnimation{
                            self.isShowAll = true
                        }
                    }){
                        Text("顯示全部")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            
//            HStack{
//                WebImage(url: userVM.profile!.UserPhotoURL) //user???
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//
//                HStack{
//                    TextField("喜歡的就留下您的評論", text: $commentText)
//                        .font(.system(size: 14))
//                        .padding(.horizontal,5)
//                        .submitLabel(.done)
//                }
//
//
//            }
//            .padding(5)
//            .background(.ultraThinMaterial)
//            .clipShape(CustomeConer(width: 25, height: 25, coners: [.allCorners]))
//            .padding(.top)
        }
        .padding(.horizontal,10)

    }
    
    @ViewBuilder
    func PostButton() -> some View {
        Spacer()
        HStack(alignment:.center){
//            .disabled(true)
            
            HStack(spacing:10){
                Button(action:{
                    //TODO: SHARE - Yes
                    DispatchQueue.main.async {
                        withAnimation{
                            self.postVM.sharedData = self.post
                            self.postVM.isSharePost.toggle()
                        }
                    }
                }){
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                    }
                    .foregroundColor(.white)
                }
                
                HStack(spacing:5){
                    Button(action:{
                        //TODO: Like the post
                        if self.post.is_post_liked {
                           UnLikePost()
                        }else {
                            LikePost()
                        }
                    }){
                        
                        Image(systemName: self.post.is_post_liked ?  "heart.fill" : "heart")
                            .imageScale(.large)
                            .foregroundColor(self.post.is_post_liked ? .red : .white)
                        
                    }
                    
                    if self.post.post_like_count > 0 {
                        Text(self.post.post_like_count.description)
                            .font(.caption)
                    }
                }
                .foregroundColor(.white)
                
                HStack(spacing:5){
                    Button(action:{
                        self.postId  = self.post.id
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            withAnimation{
                                self.isShowMorePostDetail = true
                            }
                        }
                    }){
                            Image(systemName: "text.bubble")
                                .imageScale(.large)
                                .foregroundColor(.white)
                    }
                    
                    if self.post.post_comment_count > 0{
                        Text(self.post.post_comment_count.description)
                            .font(.caption)
                    }
                }
            }

        }

    }
    
    private func UnLikePost(){
        self.post.is_post_liked = false
        self.post.post_like_count =  self.post.post_like_count - 1
        let req = RemovePostLikesReq(post_id: self.post.id)
        APIService.shared.RemovePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post unliked")
            case .failure(let err):
                self.post.is_post_liked = true
                self.post.post_like_count = self.post.post_like_count + 1
                print(err.localizedDescription)
            
            }
        }
        
    }
    
    private func LikePost(){
        self.post.is_post_liked = true
        self.post.post_like_count =  self.post.post_like_count + 1
        let req = CreatePostLikesReq(post_id: self.post.id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                self.post.is_post_liked = false
                self.post.post_like_count =  self.post.post_like_count - 1
                print(err.localizedDescription)
            
            }
        }
    }
}
