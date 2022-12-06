//
//  PostDetailWithSpecificCommentView.swift
//  IOS_DEV
//
//  Created by Jackson on 6/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailWithSpecificCommentView: View {
    @State var isShowMenu = false
    @State var selectedCommentInfo : CommentInfo? = nil

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
    @State private var postInfo : Post? = nil
    let postID : Int

    
    @State var isFetchingInfo : Bool = false
    @State var isDelete : Bool = false
    @State var isLoading : Bool = false
    @State var commentID : Int = -1
    var getCommentID : Int = 0
//    @Environment(\.pres)
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .top){
            
//            if !isChecking {
                VStack(spacing:0){
                    PostTopBar()
//                        .redacted(reason: self.isFetchingInfo ? .placeholder : [])
                    
                    //Image tab view
                    ScrollView(.vertical, showsIndicators: false){
                       postBody()
//                            .redacted(reason: self.isFetchingInfo ? .placeholder : [])
                            
                    }
                    CommentArea()
                        .redacted(reason: self.postInfo == nil ? .placeholder : [])
                }
//            }
            
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
            Task.init{
                await self.getPostInfo()
                await self.AsyncGetPostComments()
                //getting comment ...
            }
        }
        .actionSheet(isPresented: $isShowMenu){
            var action : [ActionSheet.Button] = []
            action.append(.default(Text("回覆")){
                self.placeHolder = "回覆@\(self.replyTo!.name)"
                self.isFocues = true
            })
            
            action.append(.default(Text("複製")){
                UIPasteboard.general.setValue(self.selectedCommentInfo!.comment, forPasteboardType: "public.plain-text")
            })
            
            if self.selectedCommentInfo!.user_info.id  == self.userVM.userID!{
                action.append(.destructive(Text("刪除")){
                    Task.init {
                        await self.DeleteComment(rootCommentID: self.rootCommentId, commentID: self.commentID)
                        self.replyCommentId = -1
                        self.message.removeAll()
                        self.isReply = false
                        self.placeHolder.removeAll()
                        self.rootCommentId = -1
                        self.replyTo = nil
                    }
                })
            }
            
            action.append(.cancel())
            
            return ActionSheet(title: Text((selectedCommentInfo?.user_info.name
                                           ?? "UNKNOW") + ":" + (selectedCommentInfo?.comment ?? "UNKNOW")),buttons: action)
        }

        
    }
    
    @MainActor
    private func DeleteComment(rootCommentID : Int, commentID : Int) async {
        if commentID == -1 {
            return
        }
        let resp = await APIService.shared.AsyncDeletePostComment(req: DeletePostCommentReq(comment_id: commentID))
        switch resp {
        case .success(_):
//            print("comment deleted")
            if rootCommentID == commentID {
                self.RemoveRoot(rootCommentID: rootCommentID)
            }else {
                self.RemoveChildComment(rootCommentID: rootCommentID, commentID: commentID)
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
        
    }
    
    private func RemoveRoot(rootCommentID : Int){
        print("root")
        guard let index = self.commentInfos.firstIndex(where: { $0.id == rootCommentID}) else {
            return
        }
    
        DispatchQueue.main.async {
//            switch postForm {
//            case .AllPost:
//                let postIndex = self.postVM.getPostIndexFromDiscoveryList(postId: postInfo.id)
//                self.postVM.postData[postIndex].post_comment_count -= self.commentInfos[index].reply_comments + 1
//            case .Profile:
//                let postIndex = self.userVM.GetPostIndex(postId: postInfo.id)
//                self.userVM.profile?.UserCollection?[postIndex].post_comment_count -= self.commentInfos[index].reply_comments + 1
//            }
//
//            self.postInfo.post_comment_count -= self.commentInfos[index].reply_comments + 1 //including root comment
//            self.commentInfos.removeAll(where:{$0.id == rootCommentID})
        }
    }
    
    private func RemoveChildComment(rootCommentID : Int, commentID : Int) {
        print("child")
        guard let index = self.commentInfos.firstIndex(where: { $0.id == rootCommentID}) else {
            return
        }
        
        guard let childIndex = self.commentInfos[index].replys?.firstIndex(where: { $0.id == commentID}) else {
            return
        }
        
        DispatchQueue.main.async {
//            switch postForm {
//            case .AllPost:
//                let postIndex = self.postVM.getPostIndexFromDiscoveryList(postId: postInfo.id)
//                self.postVM.postData[postIndex].post_comment_count -= 1
//            case .Profile:
//                let postIndex = self.userVM.GetPostIndex(postId: postInfo.id)
//                self.userVM.profile?.UserCollection?[postIndex].post_comment_count -= 1
//            }
            
            
            self.commentInfos[index].replys!.remove(at: childIndex)
            self.commentInfos[index].reply_comments -= 1
            self.postInfo!.post_comment_count -= 1
        }
    }
    
    private func getPostInfo() async{
        self.isFetchingInfo = true
        let resp = await APIService.shared.AsyncGetPostInfoByID(postID: self.postID)
        switch resp {
        case.success(let data):
            print(data.post_info)
            self.postInfo = data.post_info
            self.isFetchingInfo = false
        case .failure(let err):
            print(err)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
//        self.isFetchingInfo =
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
                            print("reply")
                            CreatePostReplyMessge()
                        }else {
                            print("comment")
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
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        
                        
                }
                .padding(.horizontal,10)
                
                
                Group {
                    WebImage(url:postInfo?.user_info.UserPhotoURL ?? URL(string:""))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .redacted(reason: self.isFetchingInfo ? .placeholder : [])
        //                .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
                    
                    Text(postInfo?.user_info.name ?? "UNKNOW")
                        .font(.system(size: 14, weight: .semibold))
                        .redacted(reason: self.isFetchingInfo ? .placeholder : [])
        //                .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
                }
                .onTapGesture{
//                    if postForm == .Profile{
//                        self.postVM.isShowPostDetail = false
//                        return
//                    }
                    
//                    if postInfo!.user_info.id != userVM.userID {
//                        self.shownUserID = postInfo!.user_info.id
//                        withAnimation{
//                            self.isShowUserProfile = true
//                        }
//                    }
                }
                
                Spacer()
                
                HStack{
                    Menu(content: {
                        if self.postInfo?.user_info.id ?? 0 == userVM.userID {
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
                                    self.postVM.sharedData = self.postInfo!
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

            }

            .padding(.horizontal,5)
            .frame(width:UIScreen.main.bounds.width,height:50)
            .background(Color("appleDark").edgesIgnoringSafeArea(.all))
            .alert(isPresented: $isDelete){
                withAnimation(){
                    Alert(title: Text("刪除當前文章"), message: Text("確定刪掉?"),
                          primaryButton: .default(Text("取消")){},
                          secondaryButton: .default(Text("刪除")){
                            Task.init{
                                await self.DeletePost(postID:self.postInfo!.id)
                            }
                    })
                }
            }
        }
    
    
    @ViewBuilder
    private func postBody() -> some View {
        VStack(spacing:5){
            ZStack(alignment:.topTrailing){
                //                TabView(selection:$index){
                WebImage(url: postInfo?.post_movie_info.PosterURL ?? URL(string: ""))
                    .placeholder(Image(systemName: "photo")) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .redacted(reason: self.isFetchingInfo ? .placeholder : [])
                    .frame(width: UIScreen.main.bounds.width)
                    .onTapGesture(count: 2){
                        feedBack.impactOccurred(intensity: 0.8)
                        withAnimation{
                            self.isTapToLike = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            withAnimation{
                                self.isTapToLike = false
                            }
                        }
                        
                        if postInfo?.is_post_liked ?? false {
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
        NavigationLink(destination: MovieDetailView(movieId: postInfo?.post_movie_info.id ?? 0, isShowDetail: $isShowMoreDetail)
                        .environmentObject(postVM)
                       ,isActive: $isShowMoreDetail){
            Text("#\(postInfo?.post_movie_info.title ?? "UNKNOW")")
                .font(.system(size: 15))
                .foregroundColor(.red)
                .redacted(reason: self.isFetchingInfo ? .placeholder : [])
        }

            
        Text(postInfo?.post_title ?? "UNKNOW")
                .redacted(reason: self.isFetchingInfo ? .placeholder : [])
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
//                .matchedGeometryEffect(id: postData.post_title, in: namespace)
                .multilineTextAlignment(.leading)
        
        Text(postInfo?.post_desc ?? "UNKNOW")
            .redacted(reason: self.isFetchingInfo ? .placeholder : [])
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
        
        Text("於\(postInfo?.post_at.dateDescriptiveString() ?? "UNKNOW")發佈")
            .redacted(reason: self.isFetchingInfo ? .placeholder : [])
            .foregroundColor(Color(uiColor: .systemGray2))
                .font(.caption2)
            
            PostViewDivider
        
    }
    
    @ViewBuilder
    func CommentView() -> some View{
        Text("留言 : \(postInfo?.post_comment_count ??  0)")
            .foregroundColor(.white)
            .font(.system(size: 14,weight: .medium))
            .redacted(reason: self.isFetchingInfo ? .placeholder : [])

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
                if let postData = Binding<Post>($postInfo){
                    ForEach(self.$commentInfos,id:\.id){ comment in
    //                    commentCell(comment: info)
                        
                        commentCell(isShowMenu:$isShowMenu,selectedCommentInfo: $selectedCommentInfo, commentID: $commentID,postInfo: postData, comment: comment, isLoadingReply: isLoadingReply, replyCommentId: $replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo, scrollTo: $scrollTo)
                            .task{
                                if self.isLastComment(id: comment.id){
                                    await self.LoadMoreCommentInfo(postID: self.postInfo!.id)
                                }
                            }
                    }
                }
                if (self.metaData?.page ?? 0) < (self.metaData?.total_pages ?? 0) && self.isLoading {
                    ActivityIndicatorView()
                        .padding(.vertical,15)
                } else {
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
    
    private func isLastComment(id : Int) -> Bool{
        self.commentInfos.last?.id == id
    }
        
    @MainActor
    private func DeletePost(postID : Int) async{
        let resp = await APIService.shared.AsyncDeletePost(req: DeletePostReq(post_id: postID))
        switch resp {
        case .success(_):
            withAnimation(){
                self.postVM.isShowPostDetail = false
            }
            
            self.userVM.profile!.UserCollection!.removeAll{$0.id == postID}
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    private func CreatePostComment(){
        if message.isEmpty { return }
        let postId =  postInfo!.id
        let req = CreateCommentReq(comment: self.message)
//        print(postId)
        APIService.shared.CreatePostComment(postId: postId, req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: 0,reply_id: 0,reply_to: SimpleUserInfo(id: 0, name: "", avatar: ""), meta_data: MetaData(total_pages: 0, total_results: 0, page: 0))
                
                self.commentInfos.insert(newComment, at: 0)
                DispatchQueue.main.async {
//                    switch postForm {
//                    case .AllPost:
//                        let postIndex = self.postVM.getPostIndexFromDiscoveryList(postId: self.postInfo.id)
//                        self.postVM.postData[postIndex].post_comment_count += 1
//                    case .Profile:
//                        let postIndex = self.userVM.GetPostIndex(postId: self.postInfo.id)
//                        self.userVM.profile?.UserCollection![postIndex].post_comment_count += 1
//                    }
                    postInfo!.post_comment_count += 1
                    
                }
             
                self.message.removeAll()
                self.rootCommentId = -1
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
    }
    
    private func CreatePostReplyMessge(){
//        print(self.replyCommentId)
        let index = commentInfos.firstIndex{$0.id == self.rootCommentId}

        guard let index = index else { return }
//        switch postForm {
//        case .AllPost:
//            let postIndex = self.postVM.getPostIndexFromDiscoveryList(postId: postInfo.id)
//            postID = self.postVM.postData[postIndex].id
//        case .Profile:
//            let postIndex = self.userVM.GetPostIndex(postId: postInfo.id)
//            postID = self.userVM.profile!.UserCollection![postIndex].id
//        }
//
        let req = CreateReplyCommentReq(post_id: self.postInfo!.id, comment_id: self.replyCommentId, info: ReplyCommentBody(parent_id: self.rootCommentId, comment: self.message))
        APIService.shared.CreateReplyComment(req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: self.rootCommentId,reply_id: self.replyCommentId, reply_to: SimpleUserInfo(id: self.replyTo!.id, name: self.replyTo!.name, avatar: self.replyTo!.avatar), meta_data: MetaData(total_pages: 0, total_results: 0, page: 0))
                
                DispatchQueue.main.async {
                    if self.commentInfos[index].replys == nil {
                        self.commentInfos[index].replys = []
                    }
//
//                    switch postForm {
//                    case .AllPost:
//                        let postIndex = self.postVM.getPostIndexFromDiscoveryList(postId: self.postInfo.id)
//                        self.postVM.postData[postIndex].post_comment_count += 1
//                    case .Profile:
//                        let postIndex = self.userVM.GetPostIndex(postId: self.postInfo.id)
//                        self.userVM.profile?.UserCollection![postIndex].post_comment_count += 1
//                    }
//
                    self.postInfo!.post_comment_count += 1
                    self.commentInfos[index].replys!.append(newComment)
                    self.commentInfos[index].reply_comments += 1
                    self.replyCommentId = -1
                    self.message.removeAll()
                    self.isReply = false
                    self.placeHolder.removeAll()
                    self.rootCommentId = -1
                    self.replyTo = nil
                }

                
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
    }
    
    private func AsyncGetPostComments() async{
        self.isLoadingComment = true
        let postId = postInfo!.id
        
        let resp =  await APIService.shared.AsyncGetPostComments(postId: postId)
        self.isLoadingComment = false
        switch resp {
        case .success(let data):
            self.commentInfos = data.comments
            print(self.commentInfos)
            self.metaData = data.meta_data
        case .failure(let err):
            print("get comment failed : \(err.localizedDescription)")
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
        postInfo!.is_post_liked = true
        postInfo!.post_like_count += 1
        let req = CreatePostLikesReq(post_id: postInfo!.id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                postInfo!.is_post_liked = false
                postInfo!.post_like_count += 1
                print(err.localizedDescription)
            
            }
        }
    }
    

    
}

