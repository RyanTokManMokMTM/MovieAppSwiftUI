//
//  PostBottomSheet.swift
//  IOS_DEV
//
//  Created by Jackson on 15/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI



struct PostBottomSheet : View{
    @State var isShowMenu = false
    @State var selectedCommentInfo : CommentInfo? = nil

    @State var offset: CGFloat = 0.0
    @State var commentMetaData : MetaData?
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @State private var cardOffset:CGFloat = 0
    @State private var message : String = ""
    @FocusState var isFocues: Bool
    
    @Binding var isShowMorePostDetail : Bool
    var postId : Int
    
    @State private var commentInfos : [CommentInfo] = []
    @State private var isLoadingComment = false
    
    @State private var replyTo : CommentUser? = nil
//    @State private var isLoadingReply : Bool = false
    @State private var replyCommentId : Int = -1
    @State private var rootCommentId : Int = -1
    @State private var placeHolder : String = ""
    @State private var isReply : Bool = false
    @State private var scrollTo : Int = 0
    
    //MARK: if both are same -> is a root comment
    @State private var commentID : Int = -1
    
    @State private var isLoading : Bool = false

//    @Binding var postData : Post?
    var body : some View{
        VStack(spacing:3){
            Text("評論\(self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].post_comment_count > 0 ? "(\(self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].post_comment_count)" : "" )")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.isShowMorePostDetail = false
                            }
                            
                        }){
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                    }
                        .padding(.horizontal,10)
                        .frame(width: UIScreen.main.bounds.width)
                )
                .padding(.vertical,3)
            Divider()
            
//            Spacer()
            //                PostInfoView(postId: self.$postId)
            //Comment View
            if isLoadingComment {
                Spacer()
                HStack{
                    ActivityIndicatorView()
                    Text("Loading...")
                        .font(.system(size:14))
                }
                .frame(maxWidth:.infinity,alignment: .center)
                
            }else {
                if self.commentInfos.count == 0 {
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
                    .padding(.vertical,20)
                }else {
                    ScrollViewReader{reader in
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVStack(alignment:.leading,spacing:8){
                                ForEach(self.$commentInfos) { comment in
                                    commentCell(isShowMenu : $isShowMenu, selectedCommentInfo : $selectedCommentInfo, commentID: $commentID,postInfo: self.$postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)], comment: comment, replyCommentId: $replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo, scrollTo: $scrollTo)
                                        .id(comment.id)
                                        .task {
                                            //Last one ???
                                            if self.isLastMessage(id: comment.id) {
                                                await LoadMoreCommentInfo(postID: self.postId)
                                            }
                                        }
                                        .padding(.top,8)
                                }
                                
                                if self.isLoading {
                                    
                                    ActivityIndicatorView()
                                        .padding(.vertical,15)
                                    
                                }
                            }
                            .onChange(of: self.scrollTo){ to in
                                if to == 0 {
                                    return
                                }
                                print(to)
                                ScrollTo(commentID: to, anchor: .bottom, shouldAnima: false, scrollViewReader: reader)                            }
                            
                        }
                    }
              
                }
                
                
            }
            Spacer()
            CommentArea()
        }
        .frame(alignment: .top)
        .padding(.horizontal)
        .padding(.top)
        .onAppear{
            GetPostComments()
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
                        
                    }
                })
            }
            
            action.append(.cancel())
            
            return ActionSheet(title: Text((selectedCommentInfo?.user_info.name
                                           ?? "UNKNOW") + ":" + (selectedCommentInfo?.comment ?? "UNKNOW")),buttons: action)
        }
    }
    
    func ScrollTo(commentID : Int,anchor : UnitPoint? = nil,shouldAnima : Bool,scrollViewReader : ScrollViewProxy){
        DispatchQueue.main.async {
            withAnimation(shouldAnima ? .easeIn : nil){
                scrollViewReader.scrollTo(commentID, anchor: anchor)
            }
        }
    }
    
    func isLastMessage(id : Int) -> Bool {
        return self.commentInfos.last?.id == id
    }
    
    @ViewBuilder
    private func CommentArea() -> some View {
        VStack{
            //                Spacer()
//            Divider()
            HStack{
                TextField(self.placeHolder.isEmpty ? "留下點什麼~" : self.placeHolder,text:$message)
                    .font(.system(size:14,weight:.semibold))
                    .accentColor(.white)
                    .padding(.horizontal)
                    .frame(height:30)
                    .background(BlurView())
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocues)
                    .submitLabel(.send)
                    .onSubmit({
//                        print("???")
                        //TODO: SEND THE COMMENT
                        if self.isReply {
                            CreatePostReplyMessge()
                        }else {
                            CreatePostComment()
                        }
                    })
                    .padding(.vertical,8)
            }
            .frame(height: 30)
        }
        .padding(.vertical,5)
        
        
    }
    
    private func CreatePostComment(){
        if message.isEmpty || postId == -1 { return }
        let req = CreateCommentReq(comment: self.message)
        APIService.shared.CreatePostComment(postId: postId, req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: 0,reply_id: 0,reply_to: SimpleUserInfo(id: 0, name: "", avatar: ""), meta_data: MetaData(total_pages: 0, total_results: 0, page: 0))
                
                self.commentInfos.insert(newComment, at: 0)
                DispatchQueue.main.async {
                    self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count += 1
                }
             
                self.message.removeAll()
                self.rootCommentId = -1
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
    }
    
    private func CreatePostReplyMessge(){
        if self.replyTo == nil {
            return
        }
        let index = commentInfos.firstIndex{$0.id == self.rootCommentId}
//        print("reply \(replyCommentId) in root \(rootCommentId)")
        guard let index = index else { return }
        let req = CreateReplyCommentReq(post_id: self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].id, comment_id: self.replyCommentId, info: ReplyCommentBody(parent_id: self.rootCommentId, comment: self.message))
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
                DispatchQueue.main.async {
                    self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count += 1
                    self.commentInfos[index].reply_comments += 1
//                    print(self.commentInfos[index].reply_comments)
                }
                
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
        APIService.shared.GetPostComments(postId: postId){ result in
            self.isLoadingComment = false
            switch result {
            case .success(let data):
                self.commentInfos = data.comments
                self.commentMetaData = data.meta_data
            case .failure(let err):
                print("get comment failed : \(err.localizedDescription)")
            }
        }
    }
    
    private func LoadMoreCommentInfo(postID :Int) async {
        if self.commentMetaData == nil || self.commentMetaData!.page == self.commentMetaData!.total_pages {
            return
        }
        
        self.isLoading = true
        let resp = await APIService.shared.AsyncGetPostComments(postId: postID, page: self.commentMetaData!.page + 1)
        switch resp {
        case .success(let data):
            self.commentInfos.append(contentsOf: data.comments)
            self.commentMetaData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isLoading = false
    }
    
    @MainActor
    private func DeleteComment(rootCommentID : Int, commentID : Int) async {
        if commentID == -1 {
            return
        }
        let resp = await APIService.shared.AsyncDeletePostComment(req: DeletePostCommentReq(comment_id: commentID))
        switch resp {
        case .success(_):
            print("comment deleted")
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
        guard let index = self.commentInfos.firstIndex(where: { $0.id == rootCommentID}) else {
            return
        }
        
        DispatchQueue.main.async {
            self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count  -= self.commentInfos[index].reply_comments + 1
            self.commentInfos.removeAll(where:{$0.id == rootCommentID})
        }
    }
    
    private func RemoveChildComment(rootCommentID : Int, commentID : Int) {
        guard let index = self.commentInfos.firstIndex(where: { $0.id == rootCommentID}) else {
            return
        }
        
        guard let childIndex = self.commentInfos[index].replys?.firstIndex(where: { $0.id == commentID}) else {
            return
        }
        
        DispatchQueue.main.async {
            self.commentInfos[index].replys!.remove(at: childIndex)
            self.commentInfos[index].reply_comments -= 1
            self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count  -= 1
        }
    }
}


struct commentCell : View {
    @Binding var isShowMenu : Bool
    @Binding var selectedCommentInfo : CommentInfo?
    @Binding var commentID : Int
    
    @State private var showedCommected = 0
    @EnvironmentObject private var postVM : PostVM
    @EnvironmentObject private var userVM : UserViewModel
    @Binding var postInfo : Post
    @Binding var comment : CommentInfo
    @State var isLoadingReply : Bool = false
    @Binding  var replyCommentId : Int
    @Binding  var rootCommentId : Int
    @Binding  var placeHolder : String
    @Binding  var isReply : Bool
    @Binding var commentInfos : [CommentInfo]
    @Binding var replyTo : CommentUser?
    @Binding var scrollTo : Int
    @State var replyCommentMetaData : MetaData?
    @State private var isShowLess = false
    var body : some View {
        VStack{
            HStack(alignment:.top){
                //                HStack(alignment:.center){
                Group{
                    WebImage(url:comment.user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding(.vertical,3)
                    
                    VStack(alignment:.leading,spacing: 3){
                        HStack{
                            Text(comment.user_info.name)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGray))
                            
                            if postInfo.user_info.id == comment.user_info.id {
                                Text("作者")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .lightGray))
                                    .padding(3)
                                    .padding(.horizontal,5)
                                    .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            }
                        }
                        
                        
                        
                        HStack{
                            Text(comment.comment)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text(comment.comment_time.dateDescriptiveString())
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .multilineTextAlignment(.leading)
                        .padding(.top,3)
                    }
                }
                .onTapGesture {
                    self.placeHolder = "回覆@\(comment.user_info.name)"
                    self.isReply = true
                    self.replyCommentId = comment.id
                    self.rootCommentId = comment.id
                    self.replyTo = comment.user_info
                }
                Spacer()
                
                VStack(spacing:5){
                    Image(systemName: comment.is_liked ? "heart.fill" :"heart")
                        .imageScale(.small)
                        .foregroundColor(comment.is_liked ? .red : .gray)
                        .onTapGesture{
                            if comment.is_liked {
                                self.unlikeComment(commentID: comment.id)
                            }else {
                                self.likeComment(commentID: comment.id)
                            }
                        }
                    if comment.comment_likes_count > 0 {
                        Text(comment.comment_likes_count.description)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            //TODO: Load more reply comment
            if comment.reply_comments > 0{
                HStack(spacing:0){
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width / 8.5)
                    VStack{
                        if comment.replys != nil{
                            if !self.isShowLess {
                                ForEach(0..<self.showedCommected,id:\.self){ i in
                                    replyCommentCell(postInfo: $postInfo, comment: $comment, replyCommentId:$replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo, releatedCommentId: comment.id, replyListIndex: i)
                                        .onLongPressGesture{
//                                                print("testing long gesture")
                                            self.selectedCommentInfo = comment.replys![i]
                                            self.isShowMenu = true
                                            self.isReply = true
                                            self.replyCommentId = comment.replys![i].id//reply to this comment id
                                            self.rootCommentId = comment.id
                                            self.replyTo = comment.replys![i].user_info
                                            self.commentID = comment.replys![i].id
                                        }
                                        .padding(.vertical,8)
                                        
                                }
                            }
                        }
                        
                        if comment.replys != nil && comment.reply_comments - comment.replys!.count <= 0 {
                            HStack{
                                if comment.replys != nil {
                                    Button(action:{
//                                            withAnimation{
                                            self.isShowLess.toggle()
                                            if self.isShowLess{
                                                showedCommected = 0
                                                scrollTo = comment.id
                                            } else {
//                                                showedCommected = comment.replys?.count ?? 0
                                                let showComment = showedCommected + 5
                                                showedCommected = min(showComment,comment.replys?.count ?? 0)
                                            }
                                            
//                                            }
                                    }){
                                        Text("顯示\(self.isShowLess ? "更多" : "更少")")
                                            .font(.system(size:14,weight: .semibold))
                                        
                                    }
                                }
                                
                                Spacer()
                                
                                
                            }
                            .padding(.vertical,5)
                            .foregroundColor(.gray)
                        } else {
                            HStack{
                                Button(action:{
//                                        GetCommentReply(commentId: comment.id)
                                    //how many comment can be showed?
                                    isShowLess = false
                                    if showedCommected < comment.replys?.count ?? 0{
                                        let showComment = showedCommected + 5
                                        showedCommected = min(showComment,comment.replys?.count ?? 0)
                                    }else {
                                        Task.init{
                                            await LoadCommentReply(commentId: comment.id)
                                            
                                        }
                                    }
                                }){
                                    HStack{
                                        Text("顯示\(comment.reply_comments - self.showedCommected)條評論")
                                            .font(.system(size:14,weight: .semibold))
                                            
                                        Spacer()
                                    }
                                    .padding(.vertical,5)
                                    .foregroundColor(.gray)
                                }
                                
                                if comment.replys != nil {
                                    Button(action:{
                                        self.isShowLess.toggle()
                                        if self.isShowLess{
                                            showedCommected = 0
                                            scrollTo = comment.id
                                        } else {
                                            let showComment = showedCommected + 5
                                            showedCommected = min(showComment,comment.replys?.count ?? 0)
                                        }
                                    }){
                                        HStack{
                                            Text("顯示\(self.isShowLess ? "更多" : "更少")")
                                                .font(.system(size:14,weight: .semibold))
                                                
                                            Spacer()
                                        }
                                        .padding(.vertical,5)
                                        .foregroundColor(.gray)
                                    }
                                }
                                
                            }
    
                        }
                        
                        if self.isLoadingReply{
                            
                            ActivityIndicatorView()
                                .padding(.top)
    //                            .font(.system(size:12,weight: .semibold))
                        }
                    }
                }
            }
            
            PostViewDivider
        }
        .onLongPressGesture{
            self.selectedCommentInfo =  comment
            self.isShowMenu = true
            self.isReply = true
            self.replyCommentId = comment.id
            self.rootCommentId = comment.id
            self.replyTo = comment.user_info
            self.commentID = comment.id
        }
    }
    
    private func LoadCommentReply(commentId : Int) async {
        let index = commentInfos.firstIndex{$0.id == commentId}
        guard let index = index else { return }
        self.isLoadingReply = true
        let req = GetReplyCommentReq(comment_id: commentId)
        let resp = await APIService.shared.AsyncGetReplyComment(req: req,page: self.replyCommentMetaData == nil ? 1 : self.replyCommentMetaData!.page + 1)
        
        switch resp {
        case .success(let data):
            print(data.meta_data)
            self.showedCommected += data.reply.count
            if self.commentInfos[index].replys != nil {
                for reply in data.reply{
                    let e = self.commentInfos[index].replys!.contains{$0.id == reply.id}
                    if !e {
                        self.commentInfos[index].replys!.append(reply)
                    }
                }
            }else {
                self.commentInfos[index].replys = data.reply
            }
//            self.scrollTo = data.reply.last?.id ?? 0
            self.replyCommentMetaData = data.meta_data
            self.comment.reply_comments = data.meta_data.total_results //get the updated count
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isLoadingReply = false
    
    }
//    private func GetCommentReply(commentId : Int){
//        let index = commentInfos.firstIndex{$0.id == commentId}
//        guard let index = index else { return }
//
//        self.isLoadingReply = true
//        let req = GetReplyCommentReq(comment_id: commentId)
//        APIService.shared.GetReplyComment(req: req){ result in
//            self.isLoadingReply = false
//            switch result{
//            case .success(let data):
//
//                if self.commentInfos[index].replys != nil {
//                    for reply in data.reply{
//                        let e = self.commentInfos[index].replys!.contains{$0.id == reply.id}
//                        if !e {
//                            self.commentInfos[index].replys!.append(reply)
//                        }
//                    }
//                }else {
//                    self.commentInfos[index].replys = data.reply
//                }
//
//
////               let index = commentInfos.first{$0.id = self.replyCommentId}
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
    
    private func likeComment(commentID : Int){
        
        APIService.shared.CreateCommentLikes(req: CreateCommentLikesReq(comment_id: commentID)){ result in
            switch result{
            case .success(_):
                print("like comment success")
                comment.comment_likes_count  += 1
                comment.is_liked = true
            case .failure(let err):
                print("like comment faile")
                print(err.localizedDescription)
                comment.comment_likes_count -= 1
                comment.is_liked = false
            }
        }
    }
    
    private func unlikeComment(commentID : Int){
        APIService.shared.RemoveCommentLikes(req: RemoveCommentLikesReq(comment_id: commentID)){ result in
            switch result{
            case .success(_):
                print("like comment success")
                comment.comment_likes_count  -= 1
                comment.is_liked = false
            case .failure(let err):
                print("like comment faile")
                print(err.localizedDescription)
                comment.comment_likes_count += 1
                comment.is_liked = true
            }
        }
    }
}

struct replyCommentCell : View {
    @EnvironmentObject private var postVM : PostVM
    @EnvironmentObject private var userVM : UserViewModel
    @Binding var postInfo : Post
    @Binding var comment : CommentInfo
    @Binding  var replyCommentId : Int
    @Binding  var rootCommentId : Int
    @Binding  var placeHolder : String
    @Binding  var isReply : Bool
    @Binding var commentInfos : [CommentInfo]
    @Binding var replyTo : CommentUser?
    let releatedCommentId : Int
    let replyListIndex : Int

    var body : some View {
        VStack{
//            PostViewDivider
//                .padding(.vertical,2)
            
            HStack(alignment:.top){
                Group{
                    WebImage(url:comment.replys![replyListIndex].user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                        .padding(.vertical,3)
                    
                    VStack(alignment:.leading,spacing: 3){
                        HStack{
                            Text(comment.replys![replyListIndex].user_info.name)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGray))
                            
                            if postInfo.user_info.id == comment.replys![replyListIndex].user_info.id {
                                Text("作者")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .lightGray))
                                    .padding(3)
                                    .padding(.horizontal,5)
                                    .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            }
                            
                           
                            
                            //if reply to parent comment, ignoring it
                            if comment.replys![replyListIndex].reply_id != comment.id {
                                Image(systemName:"arrowtriangle.forward.fill")
                                    .foregroundColor(.gray)
                                    .imageScale(.small)

                                Text(comment.replys![replyListIndex].reply_to.name) //Testing
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .systemGray))
                            }
                        }
                        
                        
                        
                        HStack{
                            Text(comment.replys![replyListIndex].comment)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text(comment.replys![replyListIndex].comment_time.dateDescriptiveString())
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .padding(.top,3)
                        .multilineTextAlignment(.leading)
                    }
                }
                .onTapGesture {
                    self.placeHolder = "回覆@\(comment.replys![replyListIndex].user_info.name)"
                    self.isReply = true
                    self.replyCommentId = comment.replys![replyListIndex].id//reply to this comment id
                    self.rootCommentId = comment.id
                    self.replyTo = comment.replys![replyListIndex].user_info
                }
                Spacer()
                
        
                VStack(spacing:8){
                    Image(systemName: comment.replys![replyListIndex].is_liked ? "heart.fill" :"heart")
                        .imageScale(.small)
                        .foregroundColor(comment.replys![replyListIndex].is_liked ? .red : .gray)
                    .onTapGesture{
                        if comment.replys![replyListIndex].is_liked {
                            self.unlikeComment(commentID: comment.replys![replyListIndex].id)
                        }else {
                            self.likeComment(commentID: comment.replys![replyListIndex].id)
                        }
                    }
                    if comment.replys![replyListIndex].comment_likes_count > 0 {
                        Text(comment.replys![replyListIndex].comment_likes_count.description)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            
        }
    }
    
//    private func getPostInfo() -> Post{
//        return self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postID)]
//    }
    
    private func likeComment(commentID : Int){
        
        APIService.shared.CreateCommentLikes(req: CreateCommentLikesReq(comment_id: commentID)){ result in
            switch result{
            case .success(_):
                print("like comment success")
//                comment.comment_likes_count  += 1
//                comment.is_liked = true
                comment.replys![replyListIndex].is_liked = true
                comment.replys![replyListIndex].comment_likes_count += 1
            case .failure(let err):
                print("like comment faile")
                print(err.localizedDescription)
                comment.replys![replyListIndex].is_liked = false
                comment.replys![replyListIndex].comment_likes_count -= 1
            }
        }
    }
    
    private func unlikeComment(commentID : Int){
        APIService.shared.RemoveCommentLikes(req: RemoveCommentLikesReq(comment_id: commentID)){ result in
            switch result{
            case .success(_):
                print("like comment success")
                comment.replys![replyListIndex].is_liked = false
                comment.replys![replyListIndex].comment_likes_count -= 1
            case .failure(let err):
                print("like comment faile")
                print(err.localizedDescription)
                comment.replys![replyListIndex].is_liked = true
                comment.replys![replyListIndex].comment_likes_count += 1
            }
        }
    }
    
}
