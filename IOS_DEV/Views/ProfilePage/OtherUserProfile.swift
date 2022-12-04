//
//  OtherUserProfile.swift
//  IOS_DEV
//
//  Created by Jackson on 7/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct OtherUserProfile: View {
    @StateObject var HubState : BenHubState = BenHubState.shared
    @StateObject var userVM = UserViewModel()
    @StateObject var postVM = PostVM()
//    @State private var isUserFollowing = false
    @State private var friends : Int = -1
    @State private var posts : Int = -1
    @State private var collected : Int = -1
    @State private var isFriendInfo : IsFriendResp? = nil

    var userID : Int
    var owner :Int
    var body: some View {
        GeometryReader{ proxy in
            let topEdge = proxy.safeAreaInsets.top
            UserProfileView(topEdge: topEdge,friends: $friends,posts: $posts,collected: $collected,isFriendInfo: $isFriendInfo,owner:owner,user_id: userID)
                .edgesIgnoringSafeArea(.all)
                .environmentObject(postVM)
                .environmentObject(userVM)
                .environmentObject(HubState)
                
        }
        .onAppear{
            
            if userVM.profile == nil{
                userVM.setUserID(userID: self.userID)
                getPostCount()
                getFriendCount()
                getIsFriend()
                
                Task.init{
                    await userVM.AsyncGetProfile(userID: self.userID)
                    await userVM.AsyncGetPost(userID: self.userID)
                }
                
                Task.init {
                    await getCollectedMovieCount()
                }
            }
        }
        .wait(isLoading: $HubState.isWait){
            BenHubLoadingView(message: HubState.message)
        }
        .alert(isAlert: $HubState.isPresented){
            switch HubState.type{
            case .normal,.system_message:
                BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
            case .notification:
                BenHubAlertWithUserInfo(user: HubState.senderInfo!, message: HubState.message)
            case .message:
                BenHubAlertWithMessage(user: HubState.senderInfo!, message: HubState.message)
            }
        }

    }
    
    private func getCollectedMovieCount() async{
        let resp = await APIService.shared.GetCollectedMovieCount(userID: self.userID)
        switch resp {
        case .success(let data):
            self.collected = data.total
        case .failure(let err):
            print(err.localizedDescription)
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

struct UserProfileView: View {
//    @Binding var isShowMenu : Bool
//    @Binding var isShowLikedMovie : Bool
    @EnvironmentObject var HubState : BenHubState
    @EnvironmentObject private var userVM : UserViewModel
    @EnvironmentObject private var postVM : PostVM
    @State private var isEditProfile : Bool = false
    @State private var isSetting : Bool = false
    @State private var isAddingList : Bool = false
    @State private var refersh = RefershState(started: false, released: false)
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
    @State private var headerHeight : CGFloat = 0.0
    @State private var navHeigh : CGFloat = 0.0
//    @State private var follower : Int = 0
//    @State private var following : Int = 0
    
    @State private var headerOffset : CGFloat = 0
    @State private var headerMinY : CGFloat = 0
    @State private var height : CGFloat = 0
    
    
//    @State private var isAbleToScroll = false
    @Binding var friends : Int
    @Binding var posts : Int
    @Binding var collected : Int
    
    @Binding var isFriendInfo : IsFriendResp?
    @State private var isShowActionSheet : Bool = false
    var owner : Int
    let user_id : Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { globalProxy in
            ZStack(alignment:.top){
                ZStack{
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
                            ZStack{
                                GeometryReader{ reader -> AnyView in
                                    let frame = reader.frame(in: .global)
//                                    print(userVM.isAllowToScroll)
                                    DispatchQueue.main.async {
//                                        print( headerOffset -  height + 78)
                                        
                                        if self.height != frame.height && frame.height != 0{
                                            self.height = frame.height - 78
                                        }
//                                        print(frame.height)
//                                        print(frame.minY)
                                        headerOffset = headerMinY - frame.minY

                                        
//                                        print(headerOffset)
                                        let newValue = headerOffset > height
                                        if userVM.isAllowToScroll != newValue {
                                            userVM.isAllowToScroll = newValue
                                        }
                                    }
   
//                                    print(frame.minY)
                                    return AnyView(Color.clear)
                                
                                    
                                }
                                
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
                                        
                                        
                                        
                                        profile()
                                            .frame(maxWidth:.infinity)
                                            .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                            .zIndex(2)
                                        
                                        
                                        
                                    }
                                }
                                .frame(height:max)
                                .offset(y:-offset)
                                
                            }
                            
                            Section {
                                profileCellItems()
                                    .frame(height: UIScreen.main.bounds.height - 78 - self.headerHeight)
                            } header : {
                                VStack(spacing:0){
                                    PersonPostTabBar(tabIndex: $tabIndex)
                                }
                                .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
                                .overlay(
                                    GeometryReader{proxy -> Color in
                                        let minY = proxy.frame(in: .global).minY
                                        if headerHeight == 0 {
                                            DispatchQueue.main.async {
                                                self.headerHeight = proxy.frame(in: .global).height
                                            }
                                        }
                  
                                        DispatchQueue.main.async {
                                            self.menuOffset = minY
                                        }
                                        return Color.clear
                                    }
                                )
                            }

                            
    //
                        }
                        .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
                        .frame(alignment:.top)
                    }
//                    .disabled(self.isAbleToScroll)
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
            .background(
                ZStack{
            
                    NavigationLink(destination:   PostDetailView(postForm: postVM.selectedPostFrom, isFromProfile: true,postInfo:
                                                                    self.$postVM.selectedPostInfo)
                        .navigationBarTitle("")
                        .navigationTitle("")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .environmentObject(userVM)
                        .environmentObject(postVM), isActive: self.$postVM.isShowPostDetail){
                            EmptyView()
                            
                            
                        }
                    
                    
                    
                }
            )
            .actionSheet(isPresented: self.$isShowActionSheet){
                ActionSheet(title: Text(self.userVM.profile?.name ?? "UNKNOW"), buttons: [
                    .default(Text("移除好友"),action:{
                        Task.init{
                           await self.removeFriend()
                        }
                       
                    }),
                    .cancel(Text("取消"))
                ])
            }

            
            
        }
       
    }
    
    
    
    
    @ViewBuilder
    private func profileCellItems() -> some View{
        GeometryReader{ proxy in
            HStack(spacing:0){
                OtherPersonPostCardGridView()
                    .padding(.vertical,3)
                    .environmentObject(userVM)
                    .redacted(reason: self.userVM.IsPostLoading ? .placeholder : [])
                    .frame(width: UIScreen.main.bounds.width)

                OtherLikedPostCardGridView()
                    .environmentObject(userVM)
                    .environmentObject(postVM)
                    .padding(.vertical,3)
                    .frame(width: UIScreen.main.bounds.width)
                
                OtherUserCustomListView(isViewMovieList:$isViewMovieList, listIndex:$listIndex)
                    .environmentObject(userVM)
                    .environmentObject(postVM)
                    .padding(.vertical,3)
                    .frame(width: UIScreen.main.bounds.width)

//
            }
            .offset(x : CGFloat(self.tabIndex) * -UIScreen.main.bounds.width)
            .onChange(of: self.tabIndex){ index in
                if index == 1 {
                    if userVM.profile?.UserLikedMovies == nil{
                        print("get liked movie")
                        Task.init {
                            await userVM.AsyncGetUserLikedMoive(userID: self.user_id)
                        }
                    }
                } else if index == 2{
                    if userVM.profile?.UserCustomList == nil{
                        print("get collection movie")
                        Task.init {
                            await userVM.AsyncGetUserList(userID: self.user_id)
                        }
                    }
                }
                
            }
 
        }
        .frame(width: UIScreen.main.bounds.width,alignment:.top)
        .gesture(DragGesture().onEnded{ t in
            let cur = t.translation.width
            var curInd = self.tabIndex
            
            if cur > 50 {
                curInd -= 1
            } else if cur < -50 {
                curInd += 1
            }
            
            curInd = Swift.max(min(curInd,4),0)
            withAnimation(.spring()){
                self.tabIndex = curInd
            }
        })
    }
    
    func updateData() async{
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            self.refersh.started = false
            self.refersh.released = false
            print("done")
        }catch {
            print(error.localizedDescription)
        }
    }
    
    @ViewBuilder
    func profile() -> some View{
        VStack(alignment:.leading){
            Spacer()
            VStack(alignment:.center){
                HStack(spacing:20){

                    WebImage(url: userVM.profile?.UserPhotoURL ??  URL(string: ""))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80, alignment: .center)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                        )
                    
                }
                VStack(alignment:.center){
                    Text(userVM.profile?.name ?? "").bold()
                        .font(.title2)
                    
                    Text("@\(userVM.profile?.name ??  "")")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                }
                
                VStack(alignment:.leading,spacing: 8){
                    if !userVM.isLoadingProfile && userVM.PostError == nil{
                        if self.userVM.profile != nil && self.userVM.profile!.UserGenrePrerences != nil{
                            if self.userVM.profile!.UserGenrePrerences!.isEmpty{
                                Text("使用者沒有特定喜好的電影項目~")
                                    .font(.footnote)
                            }else{
                                
                                HStack{
                                    ForEach(0..<userVM.profile!.UserGenrePrerences!.count,id:\.self){i in
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
                .padding(.top,5)
                
                HStack{
                    Spacer()
                    VStack{
                        
                        Text("文章")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(self.posts == -1 ? "--" : self.posts.description)
                            .bold()
                    }
                    Spacer()
                    VStack{
                        
                        Text("朋友")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(self.friends == -1 ? "--" : self.friends.description)
                            .bold()
                    }
                    Spacer()
                    VStack{
                        
                        Text("收藏")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(self.collected == -1 ? "--" : self.collected.description)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.top,5)
                
                if isFriendInfo != nil {
                    if isFriendInfo!.is_friend{
                        Button(action:{
                            withAnimation{
                                self.isShowActionSheet = true
                            }
                        }) {
                            HStack(spacing:8){
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .padding(.horizontal,5)
                            }
                            .frame(maxWidth:.infinity)
                            .background(BlurView().clipShape(CustomeConer(width: 8, height: 8, coners: .allCorners)))
                            .overlay(
                                Text("朋友")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                            )
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
                                        .frame(maxWidth:.infinity)
                                        .padding(12)
                                        .padding(.horizontal,5)
                                        .background( Color.blue.cornerRadius(8))
                                }.buttonStyle(.plain)

                                Button(action:{
    //                                decline(id: info.request_id)
                                    decline(id: isFriendInfo!.request!.request_id)
                                }) {
                                    Text("拒絕")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .frame(maxWidth:.infinity)
                                        .padding(12)
                                        .padding(.horizontal,5)
                                        .background( Color.red.cornerRadius(8))
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
                                    .frame(maxWidth:.infinity)
                                    .padding(12)
                                    .padding(.horizontal,5)
                                    .background( Color.red.cornerRadius(8))
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
                                .frame(maxWidth:.infinity)
                                .padding(12)
                                .padding(.horizontal,5)
                                .background( Color.blue.cornerRadius(8))
//
//                                .clipShape(CustomeConer(width: 10, height: 10, coners: .allCorners))
                                
            //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
                        }.buttonStyle(.plain)

                    }
    //
                }
                
            }
            .padding(.bottom)
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
    
    @MainActor
    private func removeFriend() async {
        if isFriendInfo?.is_friend == false {
            return
        }
        
        let resp = await APIService.shared.AsyncRemoveFriend(req: RemoveFriendReq(user_id:self.user_id))
        switch resp{
        case .success(_):
            self.isFriendInfo!.is_friend = false
            self.isFriendInfo!.is_sent_request = false
            self.HubState.AlertMessage(sysImg: "checkmark", message: "成功移除")
            self.friends -= 1
        case .failure(let err):
            print(err.localizedDescription)
            self.HubState.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
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

//struct UserProfileView : View {
//    @EnvironmentObject var userVM : UserViewModel
//    @EnvironmentObject var postVM : PostVM
//    private let max = UIScreen.main.bounds.height / 2.5
//    var topEdge : CGFloat
//    @State private var offset:CGFloat = 0.0
//    @State private var menuOffset:CGFloat = 0.0
//    @State private var isShowIcon : Bool = false
//    @State private var tabBarOffset = UIScreen.main.bounds.width
//    @State private var tabOffset : CGFloat = 0.0
//    @State private var tabIndex : Int = 0
//    @State private var listIndex : Int = 0
//    @State private var isViewMovieList : Bool = false
//    @State private var refersh = RefershState(started: false, released: false)
//
//    @Binding var isFollowing : Bool
//    @Binding var friends : Int
//    @Binding var posts : Int
//
//    @Binding var isFriendInfo : IsFriendResp?
//    var owner : Int
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        ZStack(alignment:.top){
//            ZStack{
////                it may add in the Future
//                HStack{
//                    Button(action:{
//                        dismiss()
//                    }){
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .frame(height: topEdge)
//                .padding(.top,30)
//                .zIndex(1)
//                .unredacted()
//
//                VStack(alignment:.center){
//                    Spacer()
//                    HStack{
//                        WebImage(url: userVM.profile?.UserPhotoURL  ??  URL(string: ""))
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .clipShape(Circle())
//
//                        Text(userVM.profile?.name ?? "UNKNOW")
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                .transition(.move(edge: .bottom))
//                .offset(y:self.isShowIcon ? 0 : 40)
//                .padding(.trailing,20)
//                .frame(width:UIScreen.main.bounds.width ,height: topEdge)
//                .padding(.top,30)
//                .zIndex(10)
//                .clipped()
//            }
//            .background(Color("ResultCardBlack").opacity(getOpacity()))
//            .zIndex(1)
//            .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
//
//
//            GeometryReader { proxy in
//                ScrollView(showsIndicators: false){
//                    GeometryReader{reader -> AnyView in
//
//                        DispatchQueue.main.async {
//                            if self.refersh.startOffset == 0 {
//                                self.refersh.startOffset = reader.frame(in: .global).minY
//                            }
//                            refersh.offset = reader.frame(in: .global).minY
//
//
//                            if self.refersh.offset - refersh.startOffset > 60 && !self.refersh.started {
//                                self.refersh.started = true
//                            }
//
//                            if self.refersh.offset == self.refersh.startOffset && self.refersh.started && !self.refersh.released{
//
//                                self.refersh.released = true
//                                Task.init{
//                                    await updateData()
//                                }
//
//                            }
//
//                        }
//
//                        return AnyView(Color.black.frame(width: 0, height: 0))
//                    }.frame(width: 0, height: 0)
//
//                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
//                        GeometryReader{ proxy  in
//                            ZStack(alignment:.top){
//                                WebImage(url: userVM.profile?.UserBackGroundURL ??  URL(string: ""))
//                                    .resizable()
//                                    .aspectRatio( contentMode: .fill)
//                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
//                                    .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
//                                    .overlay(
//                                        LinearGradient(colors: [
//                                            Color("PersonCellColor").opacity(0.3),
//                                            Color("PersonCellColor").opacity(0.6),
//                                            Color("PersonCellColor").opacity(0.8),
//                                            Color("PersonCellColor"),
//                                            Color.black
//                                        ], startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
//                                            .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
//                                    )
//
//                                    .zIndex(0)
//
//
//                                profileInfo()
//                                    .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
//                                    .frame(maxWidth:.infinity)
//                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
//                                    .zIndex(1)
//
//                            }
//                        }
//                        .frame(height:max)
//                        .offset(y:-offset)
//
//                        Section {
//                            switch tabIndex{
//                            case 0:
//                                //                                Text("Empty Post")
//                                OtherPersonPostCardGridView()
//                                    .padding(.vertical,3)
//                                    .environmentObject(userVM)
//                                    .redacted(reason: self.userVM.IsPostLoading ? .placeholder : [])
//                            case 1:
//                                OtherLikedPostCardGridView()
//                                    .environmentObject(userVM)
//                                    .environmentObject(postVM)
//                                    .padding(.vertical,3)
//                                    .onAppear{
//                                        if userVM.profile?.UserLikedMovies == nil{
//                                            userVM.getUserLikedMovie()
//                                        }
//                                    }
//                            case 2:
//                                OtherUserCustomListView(isViewMovieList:$isViewMovieList, listIndex:$listIndex)
//                                    .environmentObject(userVM)
//                                    .environmentObject(postVM)
//                                    .padding(.vertical,3)
//                                    .onAppear{
//                                        if userVM.profile?.UserCustomList == nil{
//                                            userVM.getUserList()
//                                        }
//                                    }
//                            default:
//                                EmptyView()
//                            }
//
//
//                        } header: {
//                            VStack(spacing:0){
//                                //
//                                PersonPostTabBar(tabIndex: $tabIndex)
//                                Divider()
//                            }
//                            .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
//                            .overlay(
//                                GeometryReader{proxy -> Color in
//                                    let minY = proxy.frame(in: .global).minY
//
//                                    DispatchQueue.main.async {
//                                        self.menuOffset = minY
//                                    }
//                                    return Color.clear
//                                }
//                            )
//                        }
//
//
//
//                    }
//                    .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
//                    .frame(alignment:.top)
//                }
//                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
//                .zIndex(0)
//
//            }
//
//        }
//
//        .background(
//            NavigationLink(destination:ViewMovieList(index: listIndex, isViewList: $isViewMovieList)
//                            .environmentObject(userVM)
//                            .environmentObject(postVM)
//                            .navigationTitle("")
//                            .navigationBarTitle("")
//                            .navigationBarHidden(true)
//                            .navigationBarBackButtonHidden(true)
//                           ,isActive:$isViewMovieList){
//                               EmptyView()
//                           }
//        )
//
//
//    }
//    func updateData() async{
//        do {
//            try await Task.sleep(nanoseconds: 2_000_000_000) //API instead
//            self.refersh.started = false
//            self.refersh.released = false
//            print("done")
//        }catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    @ViewBuilder
//    func profileInfo() -> some View{
//        VStack(alignment:.leading){
//            Spacer()
//            if self.refersh.started && self.refersh.released{
//                HStack{
//                    Spacer()
//                    ActivityIndicatorView()
//                    Spacer()
//                }
//            }else if self.refersh.offset > self.refersh.startOffset {
//                HStack{
//                    Spacer()
//                    Image(systemName: "arrow.down")
//                        .imageScale(.medium)
//                        .foregroundColor(.gray)
//                        .rotationEffect(Angle(degrees: self.refersh.started ? 180 : 0))
//                        .animation(.easeInOut)
//                    Spacer()
//                }
//            }
//            HStack(alignment:.center){
//                WebImage(url: ((userVM.profile?.UserPhotoURL)))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 80, alignment: .center)
//                    .clipShape(Circle())
//                    .overlay(
//                        Circle()
//                            .stroke(lineWidth: 2)
//                            .foregroundColor(.white)
//                    )
//
//                VStack(alignment:.leading){
//                    Text(userVM.profile?.name ?? "").bold()
//                        .font(.title2)
//                        .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
//
//                    Text("@\(userVM.profile?.name ?? "")")
//                        .font(.caption)
//                        .foregroundColor(Color.gray)
//                        .redacted(reason: self.userVM.isLoadingProfile ? .placeholder : [])
//
//                }
//
//                Spacer()
//            }
//                .padding(.bottom)
//
//            VStack(alignment:.leading,spacing: 8){
//                Text("個人喜好電影🎬")
//                    .font(.footnote)
//                    .bold()
//
//                if !userVM.isLoadingProfile && userVM.PostError == nil{
//                    if self.userVM.profile != nil && self.userVM.profile!.UserGenrePrerences != nil{
//                        if self.userVM.profile!.UserGenrePrerences!.isEmpty{
//                            Text("使用者沒有特定喜好的電影項目~")
//                                .font(.footnote)
//                        }else{
//
//                            HStack{
//                                ForEach(0..<userVM.profile!.UserGenrePrerences!.count){i in
//                                        Text(userVM.profile!.UserGenrePrerences![i].name)
//                                            .font(.caption)
//                                            .padding(8)
//                                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//
//
//                                }
//                            }
//                            .padding(.top,5)
//                        }
//                    }
//                }
//            }
//
//
//            HStack(spacing:8){
//                VStack{
//                    Text(self.posts == -1 ? "--" : self.posts.description)
//                        .bold()
//                    Text("文章")
//                }
//                VStack{
//                    Text(self.friends == -1 ? "--" : self.friends.description)
//                        .bold()
//                    Text("朋友")
//                }
//
//                Spacer()

//                if isFriendInfo != nil {
//                    if isFriendInfo!.is_friend{
//                        HStack(spacing:8){
//                            Text("朋友")
//                                .foregroundColor(.gray )
//                                .font(.system(size: 12))
//                                .fontWeight(.semibold)
//                                .padding(8)
//                                .padding(.horizontal,5)
//                                .background(Color.clear.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                                .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(Color.gray))
//                        }
//                    }
//                    else if isFriendInfo!.is_sent_request {
//                        if isFriendInfo!.request!.sender_id == userVM.userID!{
//                            HStack(spacing:8){
//                                Button(action:{
//                                    accecpt(id: isFriendInfo!.request!.request_id)
//                                }){
//                                    Text("確認")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 12))
//                                        .fontWeight(.semibold)
//                                        .padding(8)
//                                        .padding(.horizontal,5)
//                                        .background( Color.blue.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                    //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
//                                }.buttonStyle(.plain)
//
//                                Button(action:{
//    //                                decline(id: info.request_id)
//                                    decline(id: isFriendInfo!.request!.request_id)
//                                }) {
//                                    Text("拒絕")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 12))
//                                        .fontWeight(.semibold)
//                                        .padding(8)
//                                        .padding(.horizontal,5)
//                                        .background( Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                                }.buttonStyle(.plain)
//
//                            }
//                        } else {
//
//                            Button(action:{
//                                cancel(id: isFriendInfo!.request!.request_id)
//                            }){
//                                Text("取消交友邀請")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 12))
//                                    .fontWeight(.semibold)
//                                    .padding(8)
//                                    .padding(.horizontal,5)
//                                    .background( Color.red.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                            }.buttonStyle(.plain)
//
//                        }
//
//                    }
//                    else {
//                        Button(action:{
//                            addFriend()
//                        }){
//                            Text("加為好友")
//                                .foregroundColor(.white)
//                                .font(.system(size: 12))
//                                .fontWeight(.semibold)
//                                .padding(8)
//                                .padding(.horizontal,5)
//                                .background( Color.blue.clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//            //                    .overlay(RoundedRectangle(cornerRadius: 25).stroke().fill(info.isFriend ? Color.gray : Color.clear))
//                        }.buttonStyle(.plain)
//
//                    }
//    //
//                }
//
//
//            }
//            .font(.footnote)
//            .padding(.vertical)
//
//        }
//        .padding(.horizontal)
//
//    }
//
//    private func addFriend(){
//
//        let req = AddFriendReq(user_id: self.userVM.userID!)
//        APIService.shared.AddFriend(req: req){ result in
//            switch result{
//            case .success(let data):
////                print(data.message)
//                if var info = self.isFriendInfo {
//                    info.is_sent_request = true
//                    info.request?.sender_id = data.sender
//                    info.request?.request_id = data.request_id
//                    self.isFriendInfo = info
//                }
//
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    private func accecpt(id : Int){
//        let req = FriendRequestAccecptReq(request_id: id)
//        APIService.shared.AccepctFriendRequest(req: req){ result in
//            switch result{
//            case .success(let data):
//                print(data.message)
//                if var info = self.isFriendInfo {
//                    info.is_sent_request = false
//                    info.is_friend = true
//                    self.isFriendInfo = info
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    private func decline(id : Int){
//        let req = FriendRequestDeclineReq(request_id: id)
//        APIService.shared.DeclineFriendRequest(req: req){ result in
//            switch result{
//            case .success(let data):
//                print(data.message)
//                if var info = self.isFriendInfo {
//                    info.is_sent_request = false
//                    info.is_friend = false
//                    self.isFriendInfo = info
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    private func cancel(id : Int){
//        let req = FriendRequestCancelReq(request_id: id)
//        APIService.shared.CancelFriendRequest(req: req){ result in
//            switch result{
//            case .success(let data):
//                print(data.message)
//                if var info = self.isFriendInfo {
//                    info.is_sent_request = false
//                    info.is_friend = false
//                    self.isFriendInfo = info
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    private func getHeaderHigth() -> CGFloat{
//        //setting the height of the header
//
//        let top = max + offset
//        //constrain is set to 80 now
//        // < 60 + topEdge not at the top yet
//        return top > (40 + topEdge) ? top : 40 + topEdge
//    }
//
//    private func getOpacity() -> CGFloat{
//        let progress = -(offset + 40 ) / 70
//        return -offset > 40  ?  progress : 0
//    }
//}

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
                        .font(.system(size:15,weight: .bold))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(height:UIScreen.main.bounds.height / 2)
            }else{
                FlowLayoutWithLoadMoreView(isLoading: $userVM.IsPostLoading, list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10,isScrollable: $userVM.isAllowToScroll){ info in
                        profileCardCell(Id : userVM.GetPostIndex(postId: info.id)){
                            DispatchQueue.main.async {
                                self.postVM.selectedPostInfo = info
                                self.postVM.selectedPostFrom = .Profile
                                withAnimation{
                                    self.postVM.isShowPostDetail.toggle()
                                }
                            }
                        }
                        .task {
                            if self.userVM.isLastPost(postID: info.id){
                                await self.userVM.AsyncGetMorePost(userID: self.userVM.userID!)
                            }
                        }
                }

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
                ScrollView(.vertical,showsIndicators: false){
                    if userVM.profile!.UserLikedMovies!.isEmpty{
                        HStack {
                            Spacer()
                            Text("無喜歡電影")
                                .font(.system(size:15,weight: .bold))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                    }else{
                        LazyVStack(spacing:0){
                            LazyVGrid(columns: gridItem){
                                ForEach(userVM.profile!.UserLikedMovies!,id:\.id){info in
                                    
                                    LikedCardCell(movieInfo: info)
                                        .onTapGesture {
                                            self.movieId = info.id
                                            withAnimation{
                                                self.isShowMovieDetail = true
                                            }
                                        }
                                        .task {
                                            if self.userVM.isLastLikedMovie(movieID: info.id){
                                                await self.userVM.AsyncGetMoreUserLikedMoive(userID: self.userVM.userID!)
                                            }
                                        }
                                }
                                
                            }
                            
                            if self.userVM.IsLikedMovieLoading {
                                ActivityIndicatorView()
                                    .padding(.bottom,15)
                            }

                        }
                    }
                }.introspectScrollView{ scroll in
                    scroll.isScrollEnabled = userVM.isAllowToScroll
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
                ScrollView {
                    if self.userVM.profile!.UserCustomList!.isEmpty {
                        HStack {
                            Spacer()
                            Text("無收藏專輯")
                                .font(.system(size:15,weight: .bold))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        
                    } else {
                        ListInfo()
                        
                        if self.userVM.IsListLoading {
                            ActivityIndicatorView()
                                .padding(.bottom,15)
                        }
                    }
                }
                .introspectScrollView{ scroll in
                    scroll.isScrollEnabled = userVM.isAllowToScroll
                }
                
            }
        }
//        .padding(8)
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
                        
                        Text("收藏電影: \(self.userVM.profile!.UserCustomList![i].total_movies)")
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
                .task {
                    if self.userVM.isLastList(listID: self.userVM.profile!.UserCustomList![i].id){
                        await self.self.userVM.AsyncGetMoreUserLikedMoive(userID: self.userVM.userID!)
                    }
                }
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
