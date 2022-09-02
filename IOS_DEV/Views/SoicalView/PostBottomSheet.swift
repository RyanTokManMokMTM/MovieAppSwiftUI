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
    
    @State private var isLoadingReply : Bool = false
    @State private var replyCommentId : Int = -1
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
                            ForEach(self.commentInfos) { comment in
                                commentCell(comment: comment)
                            }
                        }
                        .padding(.vertical)
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
            Divider()
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
        .padding(5)
        
        
    }
    
    private func CreatePostComment(){
        if message.isEmpty || postId == -1 { return }
        let req = CreateCommentReq(comment: self.message)
        APIService.shared.CreatePostComment(postId: postId, req: req){ result in
            switch result {
            case .success(let data):
                let newComment = CommentInfo(id: data.id, user_info:
                                                CommentUser(id: self.userVM.profile!.id, name: self.userVM.profile!.name, avatar: self.userVM.profile!.avatar ?? ""),
                                             comment: self.message, update_at: data.create_at, reply_comments: 0)
                
                self.commentInfos.insert(newComment, at: 0)
                DispatchQueue.main.async {
                    self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count += 1
                }
             
                self.message.removeAll()
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
    }
    
    private func CreatePostReplyMessge(){
        let index = commentInfos.firstIndex{$0.id == self.replyCommentId}
        guard let index = index else { return }
        
        let req = CreateReplyCommentReq(post_id: self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: postId)].id, comment_id: self.replyCommentId, comment: self.message)
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
                    self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)].post_comment_count += 1
                    self.commentInfos[index].reply_comments += 1
                    print(self.commentInfos[index].reply_comments)
                }
                
                self.replyCommentId = -1
                self.message.removeAll()
                self.isReply = false
                self.placeHolder.removeAll()
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
    }
    
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
//                .onTapGesture {
//                    self.placeHolder = "回覆@\(comment.user_info.name)"
//                    self.isReply = true
//                    self.replyCommentId = replyCommentId
//                }
                Spacer()
                
                Image(systemName: "heart")
                    .imageScale(.small)
            }

            
//            PostViewDivider
//                .padding(.vertical,5)
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
    
    private func getPostInfo() -> Post{
        return self.postVM.followingData[self.postVM.getPostIndexFromFollowList(postId: self.postId)]
    }
}
//
//struct PostInfoView : View {
////    @Binding var offset: CGFloat
//    @EnvironmentObject var postVM : PostVM
////    @EnvironmentObject var userVM : UserViewModel
//    @Binding var  postId : Int
//
//    @State private var isGettingComments : Bool = false
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false){
//            VStack(alignment:.leading,spacing:8){
//                //Content and Comment View
//
//                Text(postVM.followingData[postId].post_title)
//                    .font(.system(size: 18, weight: .bold))
//
//                Text(postVM.followingData[postId].post_desc)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(Color(uiColor: UIColor.lightText))
//                    .multilineTextAlignment(.leading)
//
//                Text(postVM.followingData[postId].post_at.dateDescriptiveString())
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                    .padding(.vertical,5)
//
//                Divider()
//                    .background(Color(uiColor: UIColor.darkGray))
//                    .padding(.bottom)
//
//                VStack(alignment:.leading){
//                    Text("Comments: \(postVM.followingData[postId].comments?.count ?? 0)")
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(Color(uiColor: UIColor.lightText))
//
//                    if isGettingComments {
//
//                        HStack{
//                            ActivityIndicatorView()
//                            Text("Loading...")
//                                .font(.system(size:14))
//                        }
//                        .frame(maxWidth:.infinity,alignment: .center)
//                    }else {
//                        if postVM.followingData[postId].comments != nil && postVM.followingData[postId].comments!.count == 0 {
//                            HStack{
//                                Spacer()
//                                Image(systemName: "text.bubble")
//                                    .imageScale(.medium)
//                                    .foregroundColor(.gray)
//                                Text("沒有評論,趕緊霸佔一樓空位!")
//                                    .font(.system(size: 12, weight: .semibold))
//                                    .foregroundColor(.gray)
//                                Spacer()
//                            }
//                            .padding(.vertical,20)
//                        }else {
//                            ForEach(postVM.followingData[postId].comments!) { comment in
//                                commentCell(comment: comment)
//                            }
//
//                        }
//                    }
//                }
//
//            }
//        }.coordinateSpace(name: "scroll")
//            .onAppear{
//                GetPostComments()
//            }
//    }
//
//    @ViewBuilder
//    func commentCell(comment : CommentInfo) ->  some View {
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
//                        if comment.user_info.id == self.postVM.followingData[postId].user_info.id {
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
//                    Text(comment.comment_time.dateDescriptiveString())
//                        .foregroundColor(.gray)
//                        .font(.system(size: 10))
//                }
//
////                }
//            Spacer()
//
//            Image(systemName: "heart")
//                .imageScale(.small)
//        }
//
//        PostViewDivider
//            .padding(.vertical,5)
//    }
//
//    private func GetPostComments(){
//        self.isGettingComments = true
//        APIService.shared.GetPostComments(postId: postVM.followingData[postId].id){ result in
//            switch result {
//            case .success(let data):
//                self.isGettingComments = false
//                postVM.followingData[postId].comments = data.comments
//            case .failure(let err):
//                print("get comment failed : \(err.localizedDescription)")
//            }
//        }
//    }
//}
//
//struct ScrollViewOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
//
//    typealias Value = CGPoint
//
//}
//
//struct ScrollViewOffsetModifier: ViewModifier {
//    let coordinateSpace: String
//    @Binding var offset: CGFloat
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            GeometryReader { proxy in
//                let x = proxy.frame(in: .named(coordinateSpace)).minX
//                let y = proxy.frame(in: .named(coordinateSpace)).minY
//                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
//            }
//        }
//        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//            offset = value.y
//        }
//    }
//}
//
//extension View {
//    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGFloat>) -> some View {
//        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
//    }
//}
