//
//  PostBottomSheet.swift
//  IOS_DEV
//
//  Created by Jackson on 15/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI



struct PostBottomSheet : View{
    @State var offset: CGFloat = 0.0
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
    @State private var isLoadingReply : Bool = false
    @State private var replyCommentId : Int = -1
    @State private var rootCommentId : Int = -1
    @State private var placeHolder : String = ""
    @State private var isReply : Bool = false

//    @Binding var postData : Post?
    var body : some View{
        VStack(spacing:3){
            Text("評論(\(self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].post_comment_count))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.isShowMorePostDetail = false
                            }
                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                                self.postId = 0
//                            }
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
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(alignment:.leading,spacing:8){
                            ForEach(self.$commentInfos) { comment in
                                commentCell(postInfo: self.$postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)], comment: comment, isLoadingReply: $isLoadingReply, replyCommentId: $replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo)
                                    .padding(.vertical,5)
                            }
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
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: 0,reply_id: 0,reply_to: SimpleUserInfo(id: 0, name: "", avatar: ""))
                
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
                                             comment: self.message, update_at: data.create_at, reply_comments: 0, is_liked: false, comment_likes_count: 0, parent_comment_id: self.rootCommentId,reply_id: self.replyCommentId, reply_to: SimpleUserInfo(id: self.replyTo!.id, name: self.replyTo!.name, avatar: self.replyTo!.avatar))

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
            case .failure(let err):
                print("get comment failed : \(err.localizedDescription)")
            }
        }
    }
    
}


struct commentCell : View {
    @EnvironmentObject private var postVM : PostVM
    @EnvironmentObject private var userVM : UserViewModel
    @Binding var postInfo : Post
    @Binding var comment : CommentInfo
    @Binding var isLoadingReply : Bool
    @Binding  var replyCommentId : Int
    @Binding  var rootCommentId : Int
    @Binding  var placeHolder : String
    @Binding  var isReply : Bool
    @Binding var commentInfos : [CommentInfo]
    @Binding var replyTo : CommentUser?
    
    @State private var isShowLess = false
    var body : some View {
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
                                .font(.system(size: 14, weight: .semibold))
                            
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
                    
                    if self.isLoadingReply{
                        Text("Loading...")
                            .font(.system(size:12,weight: .semibold))
                    } else {
                        VStack{
                            if comment.replys != nil{
                                if !self.isShowLess {
                                    ForEach(0..<comment.replys!.count,id:\.self){ i in
                                        replyCommentCell(postInfo: $postInfo, comment: $comment, replyCommentId:$replyCommentId, rootCommentId: $rootCommentId, placeHolder: $placeHolder, isReply: $isReply, commentInfos: $commentInfos, replyTo: $replyTo, releatedCommentId: comment.id, replyListIndex: i)
                                    
                                    }
                                }
                            }
                            
                            if comment.replys != nil && comment.reply_comments - comment.replys!.count <= 0 {
                                HStack{
                                    if !self.isShowLess {
                                        Text("已經沒有評論了~")
                                            .font(.system(size:12,weight: .semibold))
                                        
                                    }
                                    if comment.replys != nil {
                                        Button(action:{
                                            withAnimation{
                                                self.isShowLess.toggle()
                                            }
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
                                    
                                    if comment.replys != nil {
                                        Button(action:{
                                            self.isShowLess.toggle()
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
                        }
                    
                        
                    }
                }
            }
            
            PostViewDivider
                .padding(.vertical,3)
        }
    }
//
//    private func getPostInfo() -> Post{
//        return self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postID)]
//    }
    
    private func GetCommentReply(commentId : Int){
        let index = commentInfos.firstIndex{$0.id == commentId}
        guard let index = index else { return }
        
        self.isLoadingReply = true
        let req = GetReplyCommentReq(comment_id: commentId)
        APIService.shared.GetReplyComment(req: req){ result in
            self.isLoadingReply = false
            switch result{
            case .success(let data):
                
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
               
                
//               let index = commentInfos.first{$0.id = self.replyCommentId}
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
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
            PostViewDivider
//                .padding(.vertical,2)
            
            HStack(alignment:.top){
                Group{
                    WebImage(url:comment.replys![replyListIndex].user_info.UserPhotoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(.vertical,3)
                    
                    VStack(alignment:.leading,spacing: 3){
                        HStack{
                            Text(comment.replys![replyListIndex].user_info.name)
                                .font(.system(size: 14, weight: .semibold))
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
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .systemGray))
                            }
                        }
                        
                        
                        
                        HStack{
                            Text(comment.replys![replyListIndex].comment)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 14, weight: .semibold))
                            
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
