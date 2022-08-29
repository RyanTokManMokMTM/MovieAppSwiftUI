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
    @EnvironmentObject var userVM : UserViewModel
    
    @State private var value : CGSize = .zero
    @State private var message : String = ""
    @FocusState private var isFocues : Bool
    
    @State private var isShowUserProfile : Bool = false
    @State private var shownUserID : Int = 0
    
    @State private var isUserFollowing : Bool = false
    @State private var isLoadingComment : Bool = false
    @State private var commentInfos : [CommentInfo] = []
    @State private var index = 0
    @State private var isShowMoreDetail : Bool = false
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing:0){
//                PostDetailViewTopBar(isShowUserProfile: self.$isShowUserProfile,userID:$shownUserID, isFollowing: $isUserFollowing)
//                    .environmentObject(postVM)
//                    .environmentObject(userVM)
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
            print("user id: \(userVM.profile!.id)")
        }
        
        
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
                        CreatePostComment()
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
                                             comment: self.message, update_at: data.create_at)

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
            .onAppear{
                print(self.userVM.profile!.name)
                print(self.postVM.followingData.count)
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
        Text("Comments : \(commentInfos.count)")
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
    
    @ViewBuilder
    private func commentCell(comment : CommentInfo) ->  some View {
        HStack(alignment:.top){
//                HStack(alignment:.center){
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
                        
                        if self.postVM.selectedPost!.user_info.id == comment.user_info.id {
                            Text("Author")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(uiColor: .lightGray))
                                .padding(3)
                                .padding(.horizontal,5)
                                .background(BlurView().clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        }
                    }


                    Text(comment.comment)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 12, weight: .semibold))
                    
                    HStack{
                        Text(comment.comment_time.dateDescriptiveString())
                            .foregroundColor(.gray)
                            .font(.system(size: 11))
                        
                        Text("Reply")
                            .foregroundColor(.gray)
                            .font(.system(size: 11,weight:.semibold))
                    }
                }

//                }
            Spacer()

            Image(systemName: "heart")
                .imageScale(.small)
            
        }

        PostViewDivider
            .padding(.vertical,5)
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
