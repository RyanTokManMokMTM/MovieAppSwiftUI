//
//  PostDetailView.swift
//  IOS_DEV
//
//  Created by Jackson on 10/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Refresher
enum postDatFrom{
    case AllPost
    case Profile
}

struct PostDetailView: View {
    
    var postForm : postDatFrom
    var isFromProfile : Bool
    
    @State private var metaData : MetaData? = nil
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    
    @State private var value : CGSize = .zero
    @State private var message : String = ""
    @FocusState private var isFocues : Bool
    
    
    @State private var isTapToLike : Bool = false
    @State private var isShowUserProfile : Bool = false
    @State private var shownUserID : Int = 0
    
    @State private var isUserFollowing : Bool = false
    @State private var isLoadingComment : Bool = false
    @State private var commentInfos : [CommentInfo] = []
    @State private var index = 0
    @State private var isShowMoreDetail : Bool = false
    
    @State private var replyTo : CommentUser? = nil
    @State private var isLoadingReply : Bool = false
    @State private var replyCommentId : Int = -1
    @State private var rootCommentId : Int = -1
    @State private var placeHolder : String = ""
    @State private var isReply : Bool = false
    @State private var scrollTo : Int = 0
    @Binding var postInfo : Post
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing:0){
                PostTopBar()
                
                //Image tab view
                ScrollView(.vertical, showsIndicators: false){
                   postBody()
                        
                }
//                .refresher(style: .system){ done in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
//                        print("done")
//                        done()
//                    }
//                }
                //                .frame(maxHeight:.infinity,alignment:.top)
                CommentArea()
            }
            
            if self.postVM.isSharePost && self.postVM.sharedData != nil{
                SharingView(postInfo: self.postVM.sharedData!)
                    .environmentObject(postVM)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    .onDisappear(){
                        self.postVM.sharedData = nil
                    }
            }
        }
        //        .frame(maxHeight:.infinity,alignment: .top)/
        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
        .contentShape(Rectangle())
        .background(
            NavigationLink(destination:OtherUserProfile(userID: shownUserID, owner: userVM.userID!)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                           ,isActive: $isShowUserProfile){
                EmptyView()
            }
        
        
        )
        .onAppear{
//            IsUserFollowing()
            print(postInfo)
            GetPostComments()
        }

        
    }
    
    private func LoadMoreCommentInfo(postID :Int) async {
        if self.metaData == nil || self.metaData!.page == self.metaData!.total_pages {
            return
        }
        
        let resp = await APIService.shared.AsyncGetPostComments(postId: postID, page: self.metaData!.page + 1)
        switch resp {
        case .success(let data):
            self.commentInfos.append(contentsOf: data.comments)
            self.metaData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
//            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    @ViewBuilder
    func CommentArea() -> some View {
        VStack{
            //                Spacer()
            Divider()
            HStack{
                TextField(self.placeHolder.isEmpty ? "留下點什麼~" : self.placeHolder,text:$message)
                    .font(.system(size:14))
                    .padding(.horizontal)
                    .frame(height:35)
                    .background(BlurView())
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocues)
                    .submitLabel(.send)
                    .onSubmit({
                        //TODO: SEND THE COMMENT
                        
                        if self.isReply {
                            CreatePostReplyMessge()
                        }else {
                            CreatePostComment()
                        }
                    })
                    .accentColor(.white)
            }
            .padding(.horizontal)
            .frame(height: 35)
        }
        .padding(5)
        
        
    }
        
    @ViewBuilder
    private func PostTopBar() -> some View {
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
                    WebImage(url:postInfo.user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
        //                .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
                    
                    Text(postInfo.user_info.name)
                        .font(.system(size: 14, weight: .semibold))
        //                .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
                }
                .onTapGesture{
                    if postForm == .Profile{
                        self.postVM.isShowPostDetail = false
                        return
                    }
                    
                    if postInfo.user_info.id != userVM.userID {
                        self.shownUserID = postInfo.user_info.id
                        withAnimation{
                            self.isShowUserProfile = true
                        }
                    }
                }
                
                Spacer()
                Button(action:{
                    //TODO: SHARE - Yes
                    DispatchQueue.main.async {
                        withAnimation{
                            self.postVM.sharedData = self.postInfo
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
//                if self.postVM.selectedPost!.user_info.id != self.userVM.userID! {
//                    Button(action:{
//    //                    withAnimation{
////                        withAnimation{
////                            self.isUserFollowing.toggle()
////                        }
////                        if self.isUserFollowing{
////                            followUser()
////                        }else {
////                            UnFollowUser()
////                        }
//                            //TODO: Update following state
//    //                    }
//                    }){
//                        Text("未知狀態")
//                            .foregroundColor(.white)
//                            .font(.system(size: 14))
//                            .padding(5)
//                            .padding(.horizontal,5)
//                            .background(
//                                ZStack{
//                                    if self.isUserFollowing  {
//                                        BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
//                                            .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isUserFollowing ? Color.white : Color.clear))
//                                    }else {
//                                        Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
//                                    }
//                                }
//                            )
//
//                    }
//                }
//                else {
//                    Button(action:{
//                        //TODO: MODIFY THE POST
//                    }){
//                        Image(systemName: "ellipsis")
//                            .foregroundColor(.white)
//                            .imageScale(.large)
//                    }
//                }

            }
    //        .edgesIgnoringSafeArea(.all)
            .padding(.horizontal,5)
            .frame(width:UIScreen.main.bounds.width,height:50)
            .background(Color("appleDark").edgesIgnoringSafeArea(.all))
//            .onAppear{
//                print(self.userVM.profile!.name)
//                print(self.postVM.followingData.count)
//            }
        }
    
    
    @ViewBuilder
    private func postBody() -> some View {
        VStack(spacing:5){
            ZStack(alignment:.topTrailing){
                //                TabView(selection:$index){
                WebImage(url: postInfo.post_movie_info.PosterURL)
                    .placeholder(Image(systemName: "photo")) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
//                    .matchedGeometryEffect(id: self.postVM.selectedPost!.id.description, in: namespace)
                    .frame(width: UIScreen.main.bounds.width)
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
                        
                        if !postInfo.is_post_liked {
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
//                        .animation(.spring())
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
    }
    
    @ViewBuilder
    func PostContent() -> some View{
   
            //Jump to the detail view
        NavigationLink(destination: MovieDetailView(movieId: postInfo.post_movie_info.id, isShowDetail: $isShowMoreDetail)
                        .environmentObject(postVM)
                       ,isActive: $isShowMoreDetail){
            Text("#\(postInfo.post_movie_info.title)")
                .font(.system(size: 15))
                .foregroundColor(.red)
        }

            
        Text(postInfo.post_title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
//                .matchedGeometryEffect(id: postData.post_title, in: namespace)
                .multilineTextAlignment(.leading)
        
        Text(postInfo.post_desc)
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
        
        Text("於\(postInfo.post_at.dateDescriptiveString())發佈")
            .foregroundColor(Color(uiColor: .systemGray2))
                .font(.caption2)
            
            PostViewDivider
        
    }
    
    @ViewBuilder
    func CommentView() -> some View{
        Text("留言 : \(postInfo.post_comment_count)")
            .foregroundColor(.white)
            .font(.system(size: 14,weight: .medium))
        
        //All Comment
        if self.isLoadingComment {
//            Spacer()
            HStack{
                ActivityIndicatorView()
                Text("Loading...")
                    .font(.system(size:14))
            }
            .frame(maxWidth:.infinity,alignment: .center)
        }else {
            if self.commentInfos.isEmpty{
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
                ForEach(self.$commentInfos,id:\.id){ comment in
//                    commentCell(comment: info)
                    commentCell(postInfo: $postInfo, comment: comment, isLoadingReply: $isLoadingReply, replyCommentId: $replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo, scrollTo: $scrollTo)
                }
                
                
                if self.metaData?.page ?? 0 < self.metaData?.total_pages ?? 0{
                    HStack{
                        Spacer()
                        ActivityIndicatorView()
                        Spacer()
                    }.task {
                        await self.LoadMoreCommentInfo(postID: self.postInfo.id)
                    }
                }else {
                    HStack{
                        Spacer()
                        Text("沒有評論了唷~ ")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.vertical,8)
                        Spacer()
                    }
                }
           
            }
        }
    }
        
    private func CreatePostComment(){
        if message.isEmpty { return }
        let postId =  postInfo.id
        let req = CreateCommentReq(comment: self.message)
//        print(postId)
        APIService.shared.CreatePostComment(postId: postId, req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: 0,reply_id: 0,reply_to: SimpleUserInfo(id: 0, name: "", avatar: ""), meta_data: MetaData(total_pages: 0, total_results: 0, page: 0))
                
                self.commentInfos.insert(newComment, at: 0)
                postInfo.post_comment_count += 1
                self.message.removeAll()
                self.rootCommentId = -1
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
    }
    
    private func CreatePostReplyMessge(){
        let index = commentInfos.firstIndex{$0.id == self.replyCommentId}
        guard let index = index else { return }
     
        let req = CreateReplyCommentReq(post_id: self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postInfo.id)].id, comment_id: self.replyCommentId, info: ReplyCommentBody(parent_id: self.rootCommentId, comment: self.message))
        APIService.shared.CreateReplyComment(req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: self.rootCommentId,reply_id: self.replyCommentId, reply_to: SimpleUserInfo(id: self.replyTo!.id, name: self.replyTo!.name, avatar: self.replyTo!.avatar), meta_data: MetaData(total_pages: 0, total_results: 0, page: 0))
                
                if self.commentInfos[index].replys == nil {
                    self.commentInfos[index].replys = []
                }
                self.commentInfos[index].replys!.append(newComment)
                self.postVM.selectedPostInfo.post_comment_count += 1
                self.replyCommentId = -1
                self.message.removeAll()
                self.isReply = false
                self.placeHolder.removeAll()
                self.rootCommentId = -1
                self.replyTo = nil
                
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
    }
    
    private func GetPostComments(){
        self.isLoadingComment = true
        let postId = postInfo.id
        APIService.shared.GetPostComments(postId: postId){ result in
            self.isLoadingComment = false
            switch result {
            case .success(let data):
                self.commentInfos = data.comments
                self.metaData = data.meta_data
            case .failure(let err):
                print("get comment failed : \(err.localizedDescription)")
            }
        }
    }
    
    private func GetCommentReply(commentId : Int){
        let index = commentInfos.firstIndex{$0.id == commentId}
        guard let index = index else { return }
        
        self.isLoadingReply = true
        let req = GetReplyCommentReq(comment_id: commentId)
        APIService.shared.GetReplyComment(req: req){ result in
            self.isLoadingReply = false
            switch result{
            case .success(let data):
                self.commentInfos[index].replys = data.reply
                
//               let index = commentInfos.first{$0.id = self.replyCommentId}
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func LikePost(){
        postInfo.is_post_liked = true
        postInfo.post_like_count += 1
        let req = CreatePostLikesReq(post_id: postInfo.id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                postInfo.is_post_liked = false
                postInfo.post_like_count += 1
                print(err.localizedDescription)
            
            }
        }
    }
    

    private func getPostInfo() -> Post{
        //if post from post data -> get post from post data
        //else get from user profile
        print(self.postForm)
        let postId = postInfo.id
        let index : Int
        switch postForm {
        case .AllPost:
            index = self.postVM.getPostIndexFromDiscoveryList(postId: postId)
            return self.postVM.postData[index]
        case .Profile:
            index = self.userVM.GetPostIndex(postId: postId)
            print("profile index?\(index)")
            return self.userVM.profile!.UserCollection![index]
        }
    }
}

var PostViewDivider : some View {
    
    Divider()
        .background(Color("DetechingColor"))
        .padding(.vertical,5)
}
