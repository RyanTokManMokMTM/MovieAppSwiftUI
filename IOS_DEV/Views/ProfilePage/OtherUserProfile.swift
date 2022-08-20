//
//  OtherUserProfile.swift
//  IOS_DEV
//
//  Created by Jackson on 7/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct OtherUserProfile: View {
//    @Environment var userOwner : UserViewModel
    @StateObject var userVM = UserViewModel()
    @StateObject var postVM = PostVM()
    @State private var isUserFollowing = false
    @State private var follower : Int = -1
    @State private var following : Int = -1
    @State private var posts : Int = -1
    var userID : Int
    var body: some View {
        GeometryReader{ proxy in
            let topEdge = proxy.safeAreaInsets.top
            UserProfileView(topEdge: topEdge,isFollowing: $isUserFollowing,follower: $follower,following: $following,posts: $posts)
                .ignoresSafeArea(.all, edges: .top)
                .environmentObject(userVM)
                .environmentObject(postVM)
        }
        .onAppear{
            if userVM.profile == nil {
                DispatchQueue.main.async {
                    userVM.setUserID(userID: userID)
                    userVM.getUserProfile()
//                    print("profile get\(self.userVM.profile!.name)")
                    userVM.getUserPosts()
//                    print("post  get")
                    IsUserFollowing()
                }
                
            }
            getPostCount()
            getFollower()
            getFollowing()
            
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
    
    private func getFollower(){
        let req = CountFollowedReq(user_id: userID)
        APIService.shared.CountFollowedUser(req: req) { result in
            switch result{
            case .success(let data):
                print(data.total)
                self.follower = data.total
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }
    }
    
    private func getFollowing(){
            let req = CountFollowingReq(user_id:  userID)
            APIService.shared.CountFollowingUser(req: req) { result in
                switch result{
                case .success(let data):
                    print(data.total)
                    self.following = data.total
                case .failure(let err):
                    print(err.localizedDescription)
                }
                
            }
    }
    
    
    func IsUserFollowing(){
        let req = GetOneFriendReq(friend_id: self.userID)
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
    
    @Binding var follower : Int
    @Binding var following : Int
    @Binding var posts : Int
    
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
                                        Text(userVM.profile!.UserGenrePrerences![i].genreName)
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
            
            
            HStack{
                VStack{
                    Text(self.posts == -1 ? "--" : self.posts.description)
                        .bold()
                    Text("文章")
                }
                
                VStack{
                    Text(self.following == -1 ? "--" : self.following.description)
                        .bold()
                    Text("關注")
                }
                
                VStack{
                    Text(self.following == -1 ? "--" : self.follower.description)
                        .bold()
                    Text("粉絲")
                }

                Spacer()
                
                Button(action:{
                    //TODO : Edite data
                    withAnimation{
                        self.isFollowing.toggle()
                    }
                    if self.isFollowing{
                        followUser()
                    }else {
                        UnFollowUser()
                    }
                }){
                    Text(self.isFollowing ? "已關注" : "關注")
                        .fontWeight(.semibold)
                        .padding(8)
                        .background(self.isFollowing ? Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)) : Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(self.isFollowing ? Color.white : Color.clear))
//                        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                }
//                .buttonStyle(StaticButtonStyle())
                .foregroundColor(.white)

                Button(action:{
                    //TODO : Edite data
                }){
                    Text("訊息")
                        .padding(8)
                        .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                }
                .foregroundColor(.white)

            }
            .font(.footnote)
            .padding(.vertical)
        
        }
        .padding(.horizontal)
       
    }
    
    private func followUser(){
        if self.userVM.profile == nil { return }
        
        let req = CreateNewFriendReq(friend_id: self.userVM.profile!.id)
        APIService.shared.CreateNewFriend(req: req){ result in
            switch result{
            case .success(_):
                print("User Followed")
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isFollowing.toggle()
                }
            }
        }
    }
    
    private func UnFollowUser(){
        if self.userVM.profile == nil { return }
        
        let req = RemoveFriendReq(friend_id: self.userVM.profile!.id)
        APIService.shared.RemoveFriend(req: req){ result in
            switch result{
            case .success(_):
                print("User UnFollowed")
                
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isFollowing.toggle()
                }
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
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    var body: some View{
        if userVM.profile?.UserCollection != nil{
            if userVM.profile!.UserCollection!.isEmpty{
                VStack{
                    Spacer()
                    Text("Not Post yet")
                        .font(.system(size:15))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(height:UIScreen.main.bounds.height / 2)
            }else{
                FlowLayoutView(list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10){ info in
                
                    profileCardCell(post: info)
                        .onTapGesture {
                            withAnimation{
                                postVM.selectedPost = info
                                postVM.isShowPostDetail = true
                            }
                        }
                }
                .background(
                    NavigationLink(destination:   PostDetailView()
                                    .navigationBarTitle("")
                                    .navigationTitle("")
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                                    .environmentObject(postVM), isActive: self.$postVM.isShowPostDetail){
                        EmptyView()
                        
                    }
                )
                

                
            }
            
        }
    }
        
}

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
                        Text("You have't liked any movies yet!")
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
                   Text("User has no any custom list yet")
               } else {
                   ListInfo()
               }

           } else {
               Text("User has no any custom list yet?")
           }
        }
        .padding(8)
    }
    
    @ViewBuilder
    func ListInfo() -> some View {
        ForEach(0..<self.userVM.profile!.UserCustomList!.count){ i in
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
