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
                    Text("You haven't follow any people yet")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.vertical)
            }else {
                LazyVStack(spacing:0){
                    ForEach(self.postVM.followingData){ info in
                        FollowPostCell(isShowMovieDetail: $isShowMovieDetail, movieId: $movieId,Id : postVM.getPostIndexFromFollowList(postId: info.id), isShowMorePostDetail:self.$isShowMorePostDetail, postId: self.$postId,isShowUserProfile: $isShowUserProfile,shownUserID:$shownUserID)
                            .padding(.bottom,10)
                    }
                    
                    if self.postVM.followingMetaData?.page ?? 0  < self.postVM.followingMetaData?.total_pages ?? 0{
                        ActivityIndicatorView()
                            .padding(.vertical,5)
                            .onAppear(){
                                //do some request here
                                print("loading...")
                            }
                            .task{
                                await self.postVM.LoadMoreFollowingData()
                            }
                    }
                }
//                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom )

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
    
    var Id : Int
    @Binding var isShowMorePostDetail : Bool
    @Binding var postId : Int
    @Binding var isShowUserProfile : Bool
    @Binding  var shownUserID : Int
    
    @State private var moreText : Bool = false
    @State private var isShowAll = false
    @State private var isTapToLike = false
    
    var body: some View{
        VStack(spacing:10){
            UserInfoCell()
            UserPostInfo()
        }
        .padding(.vertical,5)
        .frame(width: UIScreen.main.bounds.width)

    }
    
    @ViewBuilder
    func UserInfoCell() -> some View{
        HStack(alignment:.center){
            //TODO: Fix this one !! out of range !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! coz the id problem
            WebImage(url:self.postVM.followingData[Id].user_info.UserPhotoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())

            
            VStack(alignment:.leading){
                HStack(alignment:.center, spacing:10){
                    Text(self.postVM.followingData[Id].user_info.name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(self.postVM.followingData[Id].post_at.dateDescriptiveString())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("@\(self.postVM.followingData[Id].user_info.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            //TODO: Coming Soone???
//            Button(action: {
//                //TODO: DO SOME MORE THING??
//            }){
//                Image(systemName: "ellipsis")
//                    .imageScale(.large)
//                    .foregroundColor(.white)
//            }
//            .disabled(true)
            
            
        }
        .padding(.horizontal,10)
        .onTapGesture{
            if postVM.followingData[Id].user_info.id != userVM.userID {
                self.shownUserID = self.postVM.followingData[Id].user_info.id
                withAnimation{
                    self.isShowUserProfile = true
                }
            }
        }
    }
    
    @ViewBuilder
    func UserPostInfo() -> some View {
        VStack(alignment: .leading,spacing: 8){
//                TabView(selection:$index){
            WebImage(url:self.postVM.followingData[Id].post_movie_info.PosterURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth:.infinity,maxHeight: UIScreen.main.bounds.height / 2.2)
                .onTapGesture(count: 2){
                    print("liked post")
                    withAnimation{
                        self.isTapToLike = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        withAnimation{
                            self.isTapToLike = false
                        }
                    }
                    
                    if !self.postVM.followingData[Id].is_post_liked {
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
                        }
                    }
                )
            
//            PostButton()
            
            HStack{
                Button(action:{
                    withAnimation{
                        self.isShowMovieDetail = true
                    }
                    self.movieId = self.postVM.followingData[Id].post_movie_info.id
                }){
                    Text("#\(self.postVM.followingData[Id].post_movie_info.title)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top,5)
                }
                Spacer()
                PostButton()
            }

            HStack(alignment:.bottom){
                Text(self.postVM.followingData[Id].post_desc)
                    .lineLimit(self.isShowAll ? nil : 1)
                    .background(
                        Text(self.postVM.followingData[Id].post_desc).lineLimit(1)
                            .background(GeometryReader { visibleTextGeometry in
                                ZStack { //large size zstack to contain any size of text
                                    Text(self.postVM.followingData[Id].post_desc)
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
        HStack(alignment:.center){
//            Button(action:{
//                //TODO: SHARE - NOT
//            }){
//                HStack{
//                    Image(systemName: "square.and.arrow.up")
//                        .imageScale(.medium)
//                }
//                .foregroundColor(.white)
//            }
//            .disabled(true)
            Spacer()
            
            HStack(spacing:10){
                HStack(spacing:5){
                    Button(action:{
                        //TODO: Like the post
                        if self.postVM.followingData[Id].is_post_liked {
                           UnLikePost()
                        }else {
                            LikePost()
                        }
                    }){
                        
                        Image(systemName: self.postVM.followingData[Id].is_post_liked ?  "heart.fill" : "heart")
                            .imageScale(.medium)
                            .foregroundColor(self.postVM.followingData[Id].is_post_liked ? .red : .white)
                        
                    }
                    
                    Text(self.postVM.followingData[Id].post_like_count.description)
                        .font(.caption)
                }
                .foregroundColor(.white)
                
                Button(action:{
                    self.postId  = self.postVM.followingData[Id].id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        withAnimation{
                            self.isShowMorePostDetail = true
                        }
                    }
                }){
                    HStack(spacing:5){
                        Image(systemName: "text.bubble")
                            .imageScale(.medium)
                        Text(self.postVM.followingData[Id].post_comment_count.description)
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
            }

        }

    }
    
    
    private func UnLikePost(){
        self.postVM.followingData[Id].is_post_liked = false
        self.postVM.followingData[Id].post_like_count =  self.postVM.followingData[Id].post_like_count - 1
        let req = RemovePostLikesReq(post_id: self.postVM.followingData[Id].id)
        APIService.shared.RemovePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post unliked")
            case .failure(let err):
                self.postVM.followingData[Id].is_post_liked = true
                self.postVM.followingData[Id].post_like_count =  self.postVM.followingData[Id].post_like_count + 1
                print(err.localizedDescription)
            
            }
        }
        
    }
    
    private func LikePost(){
        self.postVM.followingData[Id].is_post_liked = true
        self.postVM.followingData[Id].post_like_count =  self.postVM.followingData[Id].post_like_count + 1
        let req = CreatePostLikesReq(post_id: self.postVM.followingData[Id].id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                self.postVM.followingData[Id].is_post_liked = false
                self.postVM.followingData[Id].post_like_count =  self.postVM.followingData[Id].post_like_count - 1
                print(err.localizedDescription)
            
            }
        }
    }
}
