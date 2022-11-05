//
//  OtherUserProfile.swift
//  IOS_DEV
//
//  Created by Jackson on 7/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct OtherUserProfile: View {
    
    @StateObject var userVM = UserViewModel()
    @StateObject var postVM = PostVM()
    @State private var isUserFollowing = false
    @State private var friends : Int = -1
    @State private var posts : Int = -1
    @State private var isFriendInfo : IsFriendResp? = nil

    var userID : Int
    var owner :Int
    var body: some View {
        GeometryReader{ proxy in
            let topEdge = proxy.safeAreaInsets.top
            UserProfileView(topEdge: topEdge,isFollowing: $isUserFollowing,friends: $friends,posts: $posts,isFriendInfo: $isFriendInfo,owner:owner)
                .ignoresSafeArea(.all, edges: .top)
                .environmentObject(postVM)
                .environmentObject(userVM)
        }
        .onAppear{
            if userVM.profile == nil {
                DispatchQueue.main.async {
                    userVM.setUserID(userID: userID)
                    userVM.getUserProfileByID()
                    userVM.getUserPosts()
                    userVM.GetUserGenresSetting()
                }
                
            }
            getPostCount()
            getFriendCount()
            getIsFriend()

            
        }

    }
    
    private func getPostCount(){
        let req = CountUserPostReq(user_id:  userID)
        APIService.shared.CountUserPosts(req: req) { result in
            switch result{
            case .success(let data):
                self.posts = data.total_posts
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }
    }
    
    private func getFriendCount(){
        let req = CountFriendReq(user_id: userID)
        APIService.shared.CountFriend(req: req) { result in
            switch result{
            case .success(let data):
                print(data.total)
                self.friends = data.total
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }
    }
    
    private func getIsFriend(){
        let req = IsFriendReq(friend_id: self.userID)
        APIService.shared.IsFriend(req: req){ result in
            switch result{
            case .success(let data):
                self.isFriendInfo = data
                
//                self.isFriend = data.is_friend
//                self.isSentReq = data.is_sent_request
//                self.fdReqID = data.request?.request_id ?? -1
//                self.reqSender = data.request?.sender_id ?? -1
            case .failure(let err):
//                print(err.loc)
                print(err.localizedDescription)
            }
        }
    }
//
//    private func getFollower(){
//        let req = CountFollowedReq(user_id: userID)
//        APIService.shared.CountFollowedUser(req: req) { result in
//            switch result{
//            case .success(let data):
//                print(data.total)
//                self.follower = data.total
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//
//        }
//    }
//
//    private func getFollowing(){
//            let req = CountFollowingReq(user_id:  userID)
//            APIService.shared.CountFollowingUser(req: req) { result in
//                switch result{
//                case .success(let data):
//                    print(data.total)
//                    self.following = data.total
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//
//            }
//    }
//
//
//    func IsUserFollowing(){
//        let req = GetOneFriendReq(friend_id: self.userID)
//        APIService.shared.GetOneFriend(req: req){ result in
//            switch result {
//            case .success(let data):
//                self.isUserFollowing = data.is_friend
//                print(self.isUserFollowing)
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
}

struct UserProfileView : View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    private let max = UIScreen.main.bounds.height / 2.5
    var topEdge : CGFloat
    @State private var offset:CGFloat = 0.0
    @State private var menuOffset:CGFloat = 0.0
    @State private var isShowIcon : Bool = false
    @State private var tabBarOffset = UIScreen.main.bounds.width
    @State private var tabOffset : CGFloat = 0.0
    @State private var tabIndex : Int = 0
    @State private var listIndex : Int = 0
    @State private var isViewMovieList : Bool = false
    
    @Binding var isFollowing : Bool
    @Binding var friends : Int
    @Binding var posts : Int
    
    @Binding var isFriendInfo : IsFriendResp?
    var owner : Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment:.top){
            ZStack{
//                it may add in the Future
                HStack{
                    Button(action:{
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: topEdge)
                .padding(.top,30)
                .zIndex(1)
                .unredacted()
                
                VStack(alignment:.center){
                    Spacer()
                    HStack{
                        WebImage(url: userVM.profile?.UserPhotoURL  ??  URL(string: ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                        
                        Text(userVM.profile?.name ?? "UNKNOW")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom))
                .offset(y:self.isShowIcon ? 0 : 40)
                .padding(.trailing,20)
                .frame(width:UIScreen.main.bounds.width ,height: topEdge)
                .padding(.top,30)
                .zIndex(10)
                .clipped()
            }
            .background(Color("ResultCardBlack").opacity(getOpacity()))
            .zIndex(1)
            .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
           
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
                        GeometryReader{ proxy  in
                            ZStack(alignment:.top){
                                WebImage(url: userVM.profile?.UserBackGroundURL ??  URL(string: ""))
                                    .resizable()
                                    .aspectRatio( contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                    .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
                                    .overlay(
                                        LinearGradient(colors: [
                                            Color("PersonCellColor").opacity(0.3),
                                            Color("PersonCellColor").opacity(0.6),
                                            Color("PersonCellColor").opacity(0.8),
                                            Color("PersonCellColor"),
                                            Color.black
                                        ], startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                            .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
                                    )
                                  
                                    .zIndex(0)
                                
                                
                                profileInfo()
                                    .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
                                    .frame(maxWidth:.infinity)
                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                    .zIndex(1)
                                
                            }
                        }
                        .frame(height:max)
                        .offset(y:-offset)
                        
                        Section {
                            switch tabIndex{
                            case 0:
                                //                                Text("Empty Post")
                                OtherPersonPostCardGridView()
                                    .padding(.vertical,3)
                                    .environmentObject(userVM)
                                    .redacted(reason: self.userVM.IsPostLoading ? .placeholder : [])
                            case 1:
                                OtherLikedPostCardGridView()
                                    .environmentObject(userVM)
                                    .environmentObject(postVM)
                                    .padding(.vertical,3)
                                    .onAppear{
                                        if userVM.profile?.UserLikedMovies == nil{
                                            userVM.getUserLikedMovie()
                                        }
                                    }
                            case 2:
                                OtherUserCustomListView(isViewMovieList:$isViewMovieList, listIndex:$listIndex)
                                    .environmentObject(userVM)
                                    .environmentObject(postVM)
                                    .padding(.vertical,3)
                                    .onAppear{
                                        if userVM.profile?.UserCustomList == nil{
                                            userVM.getUserList()
                                        }
                                    }
                            default:
                                EmptyView()
                            }
                        
            
                        } header: {
                            VStack(spacing:0){
                                //
                                PersonPostTabBar(tabIndex: $tabIndex)
                                Divider()
                            }
                            .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
                            .overlay(
                                GeometryReader{proxy -> Color in
                                    let minY = proxy.frame(in: .global).minY
                                    
                                    DispatchQueue.main.async {
                                        self.menuOffset = minY
                                    }
                                    return Color.clear
                                }
                            )
                        }
                        
                        
                        
                    }
                    .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
                    .frame(alignment:.top)
                }
                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
                .zIndex(0)
 
            }
            
        }

        .background(
            NavigationLink(destination:ViewMovieList(index: listIndex, isViewList: $isViewMovieList)
                            .environmentObject(userVM)
                            .environmentObject(postVM)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                           ,isActive:$isViewMovieList){
                               EmptyView()
                           }
        )
        
        
    }
    
    @ViewBuilder
    func profileInfo() -> some View{
        VStack(alignment:.leading){
            Spacer()
            HStack(alignment:.center){
                WebImage(url: ((userVM.profile?.UserPhotoURL)))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )

                VStack(alignment:.leading){
                    Text(userVM.profile?.name ?? "").bold()
                        .font(.title2)
                        .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
                    
                    Text("@\(userVM.profile?.name ?? "")")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
                    
                }
                
                Spacer()
            }
                .padding(.bottom)
            
            VStack(alignment:.leading,spacing: 8){
                Text("個人喜好電影🎬")
                    .font(.footnote)
                    .bold()
                
                if !userVM.isLoadingProfile && userVM.PostError == nil{
                    if self.userVM.profile != nil && self.userVM.profile!.UserGenrePrerences != nil{
                        if self.userVM.profile!.UserGenrePrerences!.isEmpty{
                            Text("使用者沒有特定喜好的電影項目~")
                                .font(.footnote)
                        }else{
                            
                            HStack{
                                ForEach(0..<userVM.profile!.UserGenrePrerences!.count){i in
                                        Text(userVM.profile!.UserGenrePrerences![i].name)
                                            .font(.caption)
                                            .padding(8)
                                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                       

                                }
                            }
                            .padding(.top,5)
                        }
                    }
                }
            }
            
            
            HStack(spacing:8){
                VStack{
                    Text(self.posts == -1 ? "--" : self.posts.description)
                        .bold()
                    Text("文章")
                }
                VStack{
                    Text(self.friends == -1 ? "--" : self.friends.description)
                        .bold()
                    Text("朋友")
                }

                Spacer()
                
                if isFriendInfo != nil {
                    if isFriendInfo!.is_friend{
                        HStack(spacing:8){
                            Text("朋友")
                                .foregroundColor(.gray )
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .padding(8)
                                .padding(.horizontal,5)
                                .background(Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(Color.gray))
                        }
                    }
                    else if isFriendInfo!.is_sent_request {
                        if isFriendInfo!.request!.sender_id == userVM.userID!{
                            HStack(spacing:8){
                                Button(action:{
                                    accecpt(id: isFriendInfo!.request!.request_id)
                                }){
                                    Text("確認")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(8)
                                        .padding(.horizontal,5)
                                        .background( Color.blue.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                    //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
                                }.buttonStyle(.plain)
                                
                                Button(action:{
    //                                decline(id: info.request_id)
                                    decline(id: isFriendInfo!.request!.request_id)
                                }) {
                                    Text("拒絕")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(8)
                                        .padding(.horizontal,5)
                                        .background( Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                                }.buttonStyle(.plain)
                            
                            }
                        } else {

                            Button(action:{
                                cancel(id: isFriendInfo!.request!.request_id)
                            }){
                                Text("取消交友邀請")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .padding(8)
                                    .padding(.horizontal,5)
                                    .background( Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            }.buttonStyle(.plain)
                            
                        }
                        
                    }
                    else {
                        Button(action:{
                            addFriend()
                        }){
                            Text("加為好友")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .padding(8)
                                .padding(.horizontal,5)
                                .background( Color.blue.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
            //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
                        }.buttonStyle(.plain)
                        
                    }
    //
                }
//

            }
            .font(.footnote)
            .padding(.vertical)
        
        }
        .padding(.horizontal)
       
    }
    
    private func addFriend(){
        
        let req = AddFriendReq(user_id: self.userVM.userID!)
        APIService.shared.AddFriend(req: req){ result in
            switch result{
            case .success(let data):
//                print(data.message)
                if var info = self.isFriendInfo {
                    info.is_sent_request = true
                    info.request?.sender_id = data.sender
                    info.request?.request_id = data.request_id
                    self.isFriendInfo = info
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func accecpt(id : Int){
        let req = FriendRequestAccecptReq(request_id: id)
        APIService.shared.AccepctFriendRequest(req: req){ result in
            switch result{
            case .success(let data):
                print(data.message)
                if var info = self.isFriendInfo {
                    info.is_sent_request = false
                    info.is_friend = true
                    self.isFriendInfo = info
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func decline(id : Int){
        let req = FriendRequestDeclineReq(request_id: id)
        APIService.shared.DeclineFriendRequest(req: req){ result in
            switch result{
            case .success(let data):
                print(data.message)
                if var info = self.isFriendInfo {
                    info.is_sent_request = false
                    info.is_friend = false
                    self.isFriendInfo = info
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func cancel(id : Int){
        let req = FriendRequestCancelReq(request_id: id)
        APIService.shared.CancelFriendRequest(req: req){ result in
            switch result{
            case .success(let data):
                print(data.message)
                if var info = self.isFriendInfo {
                    info.is_sent_request = false
                    info.is_friend = false
                    self.isFriendInfo = info
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    private func getHeaderHigth() -> CGFloat{
        //setting the height of the header
        
        let top = max + offset
        //constrain is set to 80 now
        // < 60 + topEdge not at the top yet
        return top > (40 + topEdge) ? top : 40 + topEdge
    }
    
    private func getOpacity() -> CGFloat{
        let progress = -(offset + 40 ) / 70
        return -offset > 40  ?  progress : 0
    }
}

struct OtherPersonPostCardGridView : View{
//    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @EnvironmentObject var userVM :  UserViewModel
    @EnvironmentObject var postVM : PostVM
    var body: some View{
        if userVM.profile?.UserCollection != nil{
            if userVM.profile!.UserCollection!.isEmpty{
                VStack{
                    Spacer()
                    Text("無文章")
                        .font(.system(size:15))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(height:UIScreen.main.bounds.height / 2)
            }else{
                FlowLayoutView(list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10){ info in
                
                    profileCardCell(Id : userVM.GetPostIndex(postId: info.id)){
                        DispatchQueue.main.async {
                            self.postVM.selectedPostInfo = info
                            withAnimation{
                                self.postVM.isShowPostDetail.toggle()
                            }
                        
                        }
                    }
                }
                .background(
                    NavigationLink(destination:   PostDetailView(postForm: .Profile, isFromProfile: true,postInfo: self.$postVM.selectedPostInfo)
                        .navigationBarTitle("")
                        .navigationTitle("")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .environmentObject(userVM)
                        .environmentObject(postVM), isActive: self.$postVM.isShowPostDetail){
                            EmptyView()
                            
                        }
                    
                    
                )
//                

                
            }
            
        }
    }
        
}


//struct OtherPersonPostCardGridView : View{
////    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
//    @EnvironmentObject var userVM : OtherUserViewModel
//    @EnvironmentObject var postVM : PostVM
//    var body: some View{
//        if userVM.profile!.UserCollection == nil {
//            if self.userVM.IsPostLoading {
//                LoadingView(isLoading: self.userVM.IsPostLoading, error: self.userVM.PostError as NSError?){
//                    self.userVM.getUserPosts()
//                }
//            }
//        } else if userVM.profile!.UserCollection != nil{
//            if userVM.profile!.UserCollection!.isEmpty{
//                VStack{
//                    Spacer()
//                    Text("無文章")
//                        .font(.system(size:15))
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                .frame(height:UIScreen.main.bounds.height / 2)
//            }else{
//                FlowLayoutView(list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10){ info in
//
//                    profileCardCell(Id: userVM.GetPostIndex(postId: info.id)){
//                        self.postVM.selectedPostInfo = info
//                        withAnimation{
//                            self.postVM.isShowPostDetail.toggle()
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//
//}


struct OtherLikedPostCardGridView : View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @State private var isShowMovieDetail : Bool = false
    @State private var movieId : Int = -1
    
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack{
            if userVM.profile?.UserLikedMovies != nil{
                if userVM.profile!.UserLikedMovies!.isEmpty{
                    VStack{
                        Spacer()
                        Text("無喜歡電影")
                            .font(.system(size:15))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(height:UIScreen.main.bounds.height / 2)

                }else{
                    LazyVGrid(columns: gridItem){
                        ForEach(userVM.profile!.UserLikedMovies!,id:\.id){info in
                            Button(action:{
                                self.movieId = info.id
                                withAnimation{
                                    self.isShowMovieDetail = true
                                }
                            }){
                                LikedCardCell(movieInfo: info)
                            }
                        }
                        
                    }
                }
            }
        }
        .background(
        
            NavigationLink(destination: MovieDetailView(movieId: self.movieId, isShowDetail: $isShowMovieDetail)
                            .environmentObject(userVM)
                            .environmentObject(postVM)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                           ,isActive: $isShowMovieDetail){
                EmptyView()
            }
        )
    }
}

struct OtherUserCustomListView : View{
    @Binding var isViewMovieList : Bool
    @Binding var listIndex : Int
    @EnvironmentObject var userVM : UserViewModel
//    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack(alignment:.leading){
           if self.userVM.profile?.UserCustomList != nil{
               if self.userVM.profile!.UserCustomList!.isEmpty {
                   VStack{
                       Spacer()
                       Text("無收藏專輯")
                           .font(.system(size:15))
                           .foregroundColor(.gray)
                       Spacer()
                   }
               } else {
                   ListInfo()
               }

           }
        }
        .padding(8)
    }
    
    @ViewBuilder
    func ListInfo() -> some View {
        ForEach(0..<self.userVM.profile!.UserCustomList!.count, id:\.self){ i in
            Button(action:{
//                //Open the list view
                withAnimation{
                    self.isViewMovieList.toggle()
                    self.listIndex = i
                }
            }){
                HStack{
                    
                    VStack(alignment:.leading,spacing:5){
                        Text(self.userVM.profile!.UserCustomList![i].title)
                            .font(.system(size:16,weight:.semibold))
                        
                        Text("收藏電影: \(self.userVM.profile!.UserCustomList![i].movie_list == nil ? 0 :  self.userVM.profile!.UserCustomList![i].movie_list!.count)")
                            .font(.system(size:12,weight:.semibold))
                            .foregroundColor(Color(UIColor.darkGray))
                        
                        if self.userVM.profile!.UserCustomList![i].movie_list == nil{
                            HStack(spacing:5){
                                ForEach(0..<4){ _ in
                                    PlaceHoldRect(color: Color("DarkMode2"))
                                }
                            }
                        }else{
                            HStack(spacing:5){
                                ForEach(0..<4){ movieIndex in
                                    if movieIndex <  self.userVM.profile!.UserCustomList![i].movie_list!.count{
                                        WebImage(url: self.userVM.profile!.UserCustomList![i].movie_list![movieIndex].posterURL)
                                            .resizable()
                                            .indicator(.activity)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 85)
                                    }else {
                                        PlaceHoldRect(color: Color("DarkMode2"))
                                    }
                                }
                            }
                        }
                        
                    }
                    .foregroundColor(.gray)
                    .padding(5)
                }
                .frame(maxWidth:.infinity,alignment:.leading)
                .background(Color("MoviePostColor"))
                .cornerRadius(10)
            }
        }


    }
    
    @ViewBuilder
    func PlaceHoldRect(color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: 85,height:85 * 1.5)
            .cornerRadius(10)
    }
}
