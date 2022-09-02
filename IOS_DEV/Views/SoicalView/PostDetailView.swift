//
//  PostDetailView.swift
//  IOS_DEV
//
//  Created by Jackson on 10/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

enum postDatFrom{
    case AllPost
    case Profile
}

struct PostDetailView: View {
    
    var postForm : postDatFrom
    var isFromProfile : Bool
    
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
    
    @State private var isLoadingReply : Bool = false
    @State private var replyCommentId : Int = -1
    @State private var placeHolder : String = ""
    @State private var isReply : Bool = false
    
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing:0){
                PostTopBar()
                
                //Image tab view
                ScrollView(.vertical, showsIndicators: false){
                   postBody()
                        
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
            GetPostComments()
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
                    if postForm == .Profile{
                        self.postVM.isShowPostDetail = false
                        return
                    }
                    
                    if postVM.selectedPost!.user_info.id != userVM.userID {
                        self.shownUserID = self.postVM.selectedPost!.user_info.id
                        withAnimation{
                            self.isShowUserProfile = true
                        }
                    }
                }
                
                Spacer()
                
                if self.postVM.selectedPost!.user_info.id != self.userVM.profile!.id {
                    Button(action:{
    //                    withAnimation{
                        withAnimation{
                            self.isUserFollowing.toggle()
                        }
                        if self.isUserFollowing{
                            followUser()
                        }else {
                            UnFollowUser()
                        }
                            //TODO: Update following state
    //                    }
                    }){
                        Text(self.isUserFollowing ? "已關注" : "關注")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(5)
                            .padding(.horizontal,5)
                            .background(
                                ZStack{
                                    if self.isUserFollowing  {
                                        BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                                            .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isUserFollowing ? Color.white : Color.clear))
                                    }else {
                                        Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                                    }
                                }
                            )
                            
                    }
                }
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
            .onAppear{
                print(self.userVM.profile!.name)
                print(self.postVM.followingData.count)
            }
        }
    
    
    @ViewBuilder
    private func postBody() -> some View {
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
                        
                        if !self.postVM.selectedPost!.is_post_liked {
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
        Text("留言 : \(self.postVM.selectedPost!.post_comment_count)")
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
            if self.commentInfos.isEmpty {
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
                ForEach(self.commentInfos,id:\.id){ info in
                    commentCell(comment: info)
                }
                
                HStack{
                    Spacer()
                    Text("The End ~ ")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                    Spacer()
                }
            }
        }
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
                    self.isUserFollowing.toggle()
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
                    self.isUserFollowing.toggle()
                }
            }
        }
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
    
    private func CreatePostComment(){
        if message.isEmpty { return }
        let postId =  self.postVM.selectedPost!.id
        let req = CreateCommentReq(comment: self.message)
        print(postId)
        APIService.shared.CreatePostComment(postId: postId, req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments:0)

                self.commentInfos.insert(newComment, at: 0)
                //this will change??
//                DispatchQueue.main.async {
//                    self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].post_comment_count += 1
//                }
                print(self.postVM.getPostIndexFromFollowList(postId: postId))

                self.message.removeAll()
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
    }
    
    private func CreatePostReplyMessge(){
        let index = commentInfos.firstIndex{$0.id == self.replyCommentId}
        guard let index = index else { return }
        
        let postId = self.postVM.selectedPost!.id
        
        let req = CreateReplyCommentReq(post_id: self.postVM.postData[self.postVM.getPostIndexFromDiscoveryList(postId: postId)].id, comment_id: self.replyCommentId, comment: self.message)
        APIService.shared.CreateReplyComment(req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0)

                if self.commentInfos[index].replys == nil {
                    self.commentInfos[index].replys = []
                }
                self.commentInfos[index].replys!.append(newComment)
                
                DispatchQueue.main.async {
                    self.postVM.postData[self.postVM.getPostIndexFromDiscoveryList(postId: postId)].post_comment_count += 1
//                    self.commentInfos[index].reply_comments += 1
                }
                
                self.replyCommentId = -1
                self.message.removeAll()
                self.isReply = false
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
    }
    
    private func GetPostComments(){
        self.isLoadingComment = true
        let postId = self.postVM.selectedPost!.id
        APIService.shared.GetPostComments(postId: postId){ result in
            self.isLoadingComment = false
            switch result {
            case .success(let data):
                self.commentInfos = data.comments
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
        self.postVM.selectedPost!.is_post_liked = true
        self.postVM.selectedPost!.post_like_count += 1
        let req = CreatePostLikesReq(post_id: self.postVM.selectedPost!.id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                self.postVM.selectedPost!.is_post_liked = false
                self.postVM.selectedPost!.post_like_count += 1
                print(err.localizedDescription)
            
            }
        }
    }
    
//    @ViewBuilder
//    private func commentCell(comment : CommentInfo) ->  some View {
//        HStack(alignment:.top){
////                HStack(alignment:.center){
//            WebImage(url:comment.user_info.UserPhotoURL)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 35, height: 35)
//                    .clipShape(Circle())
//                    .padding(.vertical,3)
//
//                VStack(alignment:.leading,spacing: 3){
//                    HStack{
//                        Text(comment.user_info.name)
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(Color(uiColor: .systemGray))
//
//                        if self.postVM.selectedPost!.user_info.id == comment.user_info.id {
//                            Text("Author")
//                                .font(.system(size: 12, weight: .semibold))
//                                .foregroundColor(Color(uiColor: .lightGray))
//                                .padding(3)
//                                .padding(.horizontal,5)
//                                .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                        }
//                    }
//
//
//                    Text(comment.comment)
//                        .multilineTextAlignment(.leading)
//                        .font(.system(size: 12, weight: .semibold))
//
//                    HStack{
//                        Text(comment.comment_time.dateDescriptiveString())
//                            .foregroundColor(.gray)
//                            .font(.system(size: 11))
//
//                        Text("Reply")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 11,weight:.semibold))
//                    }
//                }
//
////                }
//            Spacer()
//
//            Button(action:{
//                //Comment Like~
//            }){
//                Image(systemName: "heart")
//                    .imageScale(.small)
//            }
//
//        }
//
//        PostViewDivider
//            .padding(.vertical,5)
//    }
//
    @ViewBuilder
    private func commentCell(comment : CommentInfo) ->  some View {
        VStack{
            HStack(alignment:.top){
                //                HStack(alignment:.center){
                Group{
                    WebImage(url:comment.user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(.vertical,3)
                    
                    VStack(alignment:.leading,spacing: 3){
                        HStack{
                            Text(comment.user_info.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGray))
                            
                            if getPostInfo().user_info.id == comment.user_info.id {
                                Text("作者")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .lightGray))
                                    .padding(3)
                                    .padding(.horizontal,5)
                                    .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            }
                        }
                        
                        
                        Text(comment.comment)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .semibold))
                        
                        HStack{
                            Text(comment.comment_time.dateDescriptiveString())
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .padding(.top,3)
                    }
                }
                .onTapGesture {
                    self.placeHolder = "回覆@\(comment.user_info.name)"
                    self.isReply = true
                    self.replyCommentId = comment.id
                }
                Spacer()
                
                Image(systemName: "heart")
                    .imageScale(.small)
            }
            
            if comment.reply_comments > 0{
                HStack(spacing:0){
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width / 8.5)
                    
                    if self.isLoadingReply{
                        Text("Loading...")
                            .font(.system(size:12,weight: .semibold))
                    } else {
                        VStack{
                            if comment.replys != nil {
                                ForEach(comment.replys!){reply in
                                    replyCommentCell(comment: reply,releatedCommentId : comment.id)
                                }
                            }
                            
                            if comment.replys != nil && comment.reply_comments - comment.replys!.count <= 0 {
                                HStack{
                                    Text("已經沒有評論了~")
                                        .font(.system(size:14,weight: .semibold))
                                    
                                    Spacer()
                                }
                                .padding(.vertical,5)
                                .foregroundColor(.gray)
                            } else {
                                Button(action:{
                                    GetCommentReply(commentId: comment.id)
                                }){
                                    HStack{
                                        Text("顯示\(comment.reply_comments - (comment.replys?.count ?? 0))條評論")
                                            .font(.system(size:14,weight: .semibold))
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical,5)
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                    
                        
                    }
                }
            }
            
            PostViewDivider
                .padding(.vertical,5)
        }
    }
    
    @ViewBuilder
    private func replyCommentCell(comment : CommentInfo,releatedCommentId : Int) ->  some View {
        VStack{
            HStack(alignment:.top){
                Group{
                    WebImage(url:comment.user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(.vertical,3)
                    
                    VStack(alignment:.leading,spacing: 3){
                        HStack{
                            Text(comment.user_info.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGray))
                            
                            if getPostInfo().user_info.id == comment.user_info.id {
                                Text("作者")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .lightGray))
                                    .padding(3)
                                    .padding(.horizontal,5)
                                    .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            }
                        }
                        
                        
                        Text(comment.comment)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .semibold))
                        
                        HStack{
                            Text(comment.comment_time.dateDescriptiveString())
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .padding(.top,3)
                    }
                }
                .onTapGesture {
                    self.placeHolder = "回覆@\(comment.user_info.name)"
                    self.isReply = true
                    self.replyCommentId = replyCommentId
                }
                Spacer()
                
                Image(systemName: "heart")
                    .imageScale(.small)
            }

            
//            PostViewDivider
//                .padding(.vertical,5)
        }
    }
    
    private func getPostInfo() -> Post{
        //if post from post data -> get post from post data
        //else get from user profile
        print(self.postForm)
        let postId = self.postVM.selectedPost!.id
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
//
//struct PostDetailViewTopBar : View {
//    @Binding var isShowUserProfile : Bool
//    @Binding var userID : Int
//    @Binding var isFollowing : Bool
//
//    @EnvironmentObject var postVM : PostVM
//    @EnvironmentObject var userVM : UserViewModel
////    var postData : Post
////    @Binding var isShow : Bool
//
//    var body: some View{
//        HStack(alignment:.center){
//            Button(action:{
//                withAnimation(){
//                    self.postVM.isShowPostDetail = false
//                }
//            }){
//                Image(systemName: "chevron.left")
//                    .imageScale(.large)
//                    .foregroundColor(.white)
//
//
//            }
//            .padding(.horizontal,5)
//
//
//            Group {
//                WebImage(url:self.postVM.selectedPost!.user_info.UserPhotoURL)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 40, height: 40)
//                    .clipShape(Circle())
//    //                .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
//
//                Text(self.postVM.selectedPost!.user_info.name)
//                    .font(.system(size: 14, weight: .semibold))
//    //                .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
//            }
//            .onTapGesture{
//                if postVM.selectedPost!.user_info.id != userVM.userID {
//                    self.userID = self.postVM.selectedPost!.user_info.id
//                    withAnimation{
//                        self.isShowUserProfile = true
//                    }
//                }
//            }
//
//            Spacer()
//
//            if self.postVM.selectedPost!.user_info.id != self.userVM.profile!.id{
//                Button(action:{
////                    withAnimation{
//                    withAnimation{
//                        self.isFollowing.toggle()
//                    }
//                    if self.isFollowing{
//                        followUser()
//                    }else {
//                        UnFollowUser()
//                    }
//                        //TODO: Update following state
////                    }
//                }){
//                    Text(self.isFollowing ? "已關注" : "關注")
//                        .foregroundColor(.white)
//                        .font(.system(size: 14))
//                        .padding(5)
//                        .padding(.horizontal,5)
//                        .background(
//                            ZStack{
//                                if self.isFollowing  {
//                                    BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
//                                        .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isFollowing ? Color.white : Color.clear))
//                                }else {
//                                    Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
//                                }
//                            }
//                        )
//
//                }
//            }else {
//                Button(action:{
//                    //TODO: MODIFY THE POST
//                }){
//                    Image(systemName: "ellipsis")
//                        .foregroundColor(.white)
//                        .imageScale(.large)
//                }
//            }
//
//        }
////        .edgesIgnoringSafeArea(.all)
//        .padding(.horizontal,5)
//        .frame(width:UIScreen.main.bounds.width,height:50)
//        .background(Color("appleDark").edgesIgnoringSafeArea(.all))
//        .onAppear{
//            print(self.userVM.profile!.name)
//            print(self.postVM.followingData.count)
//        }
//    }
//
//    private func followUser(){
//        let req = CreateNewFriendReq(friend_id: self.postVM.selectedPost!.user_info.id)
//        APIService.shared.CreateNewFriend(req: req){ result in
//            switch result{
//            case .success(_):
//                print("User Followed")
//            case .failure(let err):
//                print(err.localizedDescription)
//                withAnimation{
//                    self.isFollowing.toggle()
//                }
//            }
//        }
//    }
//
//    private func UnFollowUser(){
//        let req = RemoveFriendReq(friend_id: self.postVM.selectedPost!.user_info.id)
//        APIService.shared.RemoveFriend(req: req){ result in
//            switch result{
//            case .success(_):
//                print("User UnFollowed")
//
//            case .failure(let err):
//                print(err.localizedDescription)
//                withAnimation{
//                    self.isFollowing.toggle()
//                }
//            }
//        }
//    }
//}
//
//struct PostDetailDescView : View {
//    @EnvironmentObject var userVM : UserViewModel
//    @EnvironmentObject var postVM : PostVM
//    @State private var index = 0
//    @State private var isShowMoreDetail : Bool = false
//
//
//    @Binding var isLoadingComment : Bool
//    @Binding var commentInfos : [CommentInfo]
//    var body: some View {
//        VStack(spacing:5){
//            ZStack(alignment:.topTrailing){
//                //                TabView(selection:$index){
//                WebImage(url: self.postVM.selectedPost!.post_movie_info.PosterURL)
//                    .placeholder(Image(systemName: "photo")) //
//                    .resizable()
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.5))
//                    .aspectRatio(contentMode: .fit)
////                    .matchedGeometryEffect(id: self.postVM.selectedPost!.id.description, in: namespace)
//                    .frame(width: UIScreen.main.bounds.width)
//                //maxinum image is 10
//                Text("\(index + 1)/1")
//                    .font(.system(size: 12, weight: .semibold))
//                    .padding(8)
//                    .padding(.horizontal,5)
//                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 20, height: 20, coners: .allCorners)))
//                    .offset(x: -10, y: 10)
//    //                .overlay(RoundedRectangle(cornerRadius: 25).stroke())
//            }
//            .frame(height: UIScreen.main.bounds.height / 2.2)
//
//
//            HStack(spacing:5){
//                ForEach(1..<2){i in
//                    Circle()
//                        .fill(self.index + 1 == i ? .red : .gray)
//                        .frame(width: 5, height: 5)
//                        .scaleEffect(self.index + 1 == i ? 1.2 : 0.9)
//                        .animation(.spring())
//                }
//            }
//            VStack{
//                VStack(alignment: .leading, spacing:8){
//                    PostContent()
//                    CommentView()
//                        .edgesIgnoringSafeArea(.all)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top)
//
//        }
////        .edgesIgnoringSafeArea(.all)
//    }
//
//
//
//
//    @ViewBuilder
//    func PostContent() -> some View{
//
//            //Jump to the detail view
//        NavigationLink(destination: MovieDetailView(movieId: self.postVM.selectedPost!.post_movie_info.id, isShowDetail: $isShowMoreDetail)
//                        .environmentObject(postVM)
//                       ,isActive: $isShowMoreDetail){
//            Text("#\(self.postVM.selectedPost!.post_movie_info.title)")
//                .font(.system(size: 15))
//                .foregroundColor(.red)
//        }
//
//
//        Text(self.postVM.selectedPost!.post_title)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.white)
////                .matchedGeometryEffect(id: postData.post_title, in: namespace)
//                .multilineTextAlignment(.leading)
//
//        Text(self.postVM.selectedPost!.post_desc)
//            .font(.system(size: 15,weight: .regular))
//                .multilineTextAlignment(.leading)
//                .lineSpacing(8)
//
////        //Testing only
////            HStack{
////                Text("#劇透")
////                Text("#電影劇情分享")
//////                Text("#奇異博士")
//////                Text("#漫威")
////            }
////            .foregroundColor(.blue)
////            .font(.system(size: 15,weight: .semibold))
//
//        Text("Posted at \(self.postVM.selectedPost!.post_at.dateDescriptiveString())")
//            .foregroundColor(Color(uiColor: .systemGray2))
//                .font(.caption2)
//
//            PostViewDivider
//
//    }
//
//    @ViewBuilder
//    func CommentView() -> some View{
//        Text("Comments : \(commentInfos.count)")
//            .foregroundColor(.white)
//            .font(.system(size: 14,weight: .medium))
//
//        //All Comment
//        PostViewDivider
//        if self.isLoadingComment {
////            Spacer()
//            HStack{
//                ActivityIndicatorView()
//                Text("Loading...")
//                    .font(.system(size:14))
//            }
//            .frame(maxWidth:.infinity,alignment: .center)
//        }else {
//            if self.commentInfos.isEmpty {
//                HStack{
//                    Spacer()
//                    Image(systemName: "text.bubble")
//                        .imageScale(.medium)
//                        .foregroundColor(.gray)
//                    Text("沒有評論,趕緊霸佔一樓空位!")
//                        .font(.system(size: 12, weight: .semibold))
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//            }else {
//                ForEach(self.commentInfos,id:\.id){ info in
//                    commentCell(comment: info)
//                }
//
//                HStack{
//                    Spacer()
//                    Text("The End ~ ")
//                        .font(.system(size: 12, weight: .semibold))
//                        .foregroundColor(.gray)
//                        .padding(.vertical,8)
//                    Spacer()
//                }
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func commentCell(comment : CommentInfo) ->  some View {
//        HStack(alignment:.top){
////                HStack(alignment:.center){
//            WebImage(url:comment.user_info.UserPhotoURL)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 35, height: 35)
//                    .clipShape(Circle())
//                    .padding(.vertical,3)
//
//                VStack(alignment:.leading,spacing: 3){
//                    HStack{
//                        Text(comment.user_info.name)
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(Color(uiColor: .systemGray))
//
//                        if self.postVM.selectedPost!.user_info.id == comment.user_info.id {
//                            Text("Author")
//                                .font(.system(size: 12, weight: .semibold))
//                                .foregroundColor(Color(uiColor: .lightGray))
//                                .padding(3)
//                                .padding(.horizontal,5)
//                                .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                        }
//                    }
//
//
//                    Text(comment.comment)
//                        .multilineTextAlignment(.leading)
//                        .font(.system(size: 12, weight: .semibold))
//
//                    HStack{
//                        Text(comment.comment_time.dateDescriptiveString())
//                            .foregroundColor(.gray)
//                            .font(.system(size: 11))
//
//                        Text("Reply")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 11,weight:.semibold))
//                    }
//                }
//
////                }
//            Spacer()
//
//            Image(systemName: "heart")
//                .imageScale(.small)
//
//        }
//
//        PostViewDivider
//            .padding(.vertical,5)
//    }
//
//    private func GetPostComments(){
//        self.isLoadingComment = true
//        APIService.shared.GetPostComments(postId: self.postVM.selectedPost!.id){ result in
//            self.isLoadingComment = false
//            switch result {
//            case .success(let data):
//                self.commentInfos = data.comments
//            case .failure(let err):
//                print("get comment failed : \(err.localizedDescription)")
//            }
//        }
//    }
//}


var PostViewDivider : some View {
    
    Divider()
        .background(Color("DetechingColor"))
        .padding(.vertical,5)
}
