//
//  personProfile.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 13/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreAudio
import Kingfisher
import Combine
import Refresher
private let feedBack = UIImpactFeedbackGenerator()
struct PersonProfileView : View{
    @Binding var isShowMenu : Bool
    @StateObject var HubState : BenHubState = BenHubState.shared
    @EnvironmentObject private var userVM : UserViewModel
    var body: some View{
        
        GeometryReader{proxy in
            let topEdge = proxy.safeAreaInsets.top
            personProfile(isShowMenu: $isShowMenu,topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
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
        .onAppear{
//            self.userVM.getUserPosts()
            self.userVM.GetUserGenresSetting()
            
            Task.init{
                await userVM.AsyncGetPost(userID: userVM.profile!.id)
            }
        }
    }
}

struct MovieGenreTab : Identifiable ,Codable{
    let id : Int
    let refURL : String
    let genreName : String
    var isSelected : Bool
}

class MoviePrerefencesSettingModel : ObservableObject {
    @Published var prerefencesType : [MovieGenreTab]
    @Published var isSelectedType : [MovieGenreTab] = []
    
    
    init(){
        self.prerefencesType = tempGenreTab
    }
    
    func SetUpSelected(selected: [Int]){
        
        for genreId in selected {
            let index = prerefencesType.firstIndex{$0.id == genreId}
            guard let index = index else{ return }
            self.prerefencesType[index].isSelected = true
            isSelectedType.append(self.prerefencesType[index])
        }
    }
    
    func updateSelected(preferencesID : Int){
        print(preferencesID)
        let index = prerefencesType.firstIndex{$0.id == preferencesID}
        guard let index = index else{return}
        
        if self.prerefencesType[index].isSelected{
            self.prerefencesType[index].isSelected.toggle()
            
            //find the index of the items
            let selectedInd = self.isSelectedType.firstIndex(){$0.id == preferencesID}
            self.removeSelected(i: selectedInd!)
            return
        }
        
        if checkIsMaxSelected(){
            print("max")
        }else{
            self.prerefencesType[index].isSelected.toggle()
            self.addSelected(i: index)
        }
    }
    
    private func removeSelected(i : Int){
        //not i
        self.isSelectedType.remove(at: i)
    }
    
    private func addSelected(i : Int){
        self.isSelectedType.append(self.prerefencesType[i])
    }
    
    private func checkIsMaxSelected() -> Bool{
        return isSelectedType.count < 5 ? false : true
    }
    
    
}

let tempGenreTab : [MovieGenreTab] = [
    MovieGenreTab(id: 28, refURL: "https://www.themoviedb.org/t/p/original/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg", genreName: "動作", isSelected: false),
    MovieGenreTab(id: 12, refURL: "https://www.themoviedb.org/t/p/original/5B22eed7ErxFiYAG4Ksb4eLwKNF.jpg", genreName: "冒險", isSelected: false),
    MovieGenreTab(id: 16, refURL: "https://www.themoviedb.org/t/p/original/86Bxkqz9N6zyHOAAPYETZPYCNaq.jpg", genreName: "動畫", isSelected: false),
    MovieGenreTab(id: 35, refURL: "https://www.themoviedb.org/t/p/original/ezyFE2H7vdFoK3dXK4p4ZUaTukW.jpg", genreName: "戲劇", isSelected: false),
    MovieGenreTab(id: 80, refURL: "https://www.themoviedb.org/t/p/original/54yOImQgj8i85u9hxxnaIQBRUuo.jpg", genreName: "犯罪", isSelected: false),
    MovieGenreTab(id: 99, refURL: "https://www.themoviedb.org/t/p/original/g8dafKwLfaueQ5GK0qjKTkRCBAA.jpg", genreName: "紀錄", isSelected: false),
    MovieGenreTab(id: 18, refURL: "https://www.themoviedb.org/t/p/original/tnofyiwMAQQIhUvGPTiMFcgSy0P.jpg", genreName: "劇情", isSelected: false),
    
    MovieGenreTab(id: 10751, refURL: "https://www.themoviedb.org/t/p/original/ytTQoYkdpsgtfDWrNFCei8Mfbxu.jpg", genreName: "家庭", isSelected: false),
    MovieGenreTab(id: 14, refURL: "https://www.themoviedb.org/t/p/original/mPyiNWS0upEG1mGKOKyCQSoZpnp.jpg", genreName: "奇幻", isSelected: false),
    MovieGenreTab(id: 36, refURL: "https://www.themoviedb.org/t/p/original/8o9SLJzM7dvFeInbOXk5Qnft1mk.jpg", genreName: "歷史", isSelected: false),
    MovieGenreTab(id: 27, refURL: "https://www.themoviedb.org/t/p/original/bNnNlUjf16ahEw0uv39NUeQ35YR.jpg", genreName: "恐怖", isSelected: false),
    MovieGenreTab(id: 10402, refURL: "https://www.themoviedb.org/t/p/original/qqthj8EUL4QKlDBoMcPqeWvi6Ya.jpg", genreName: "音樂", isSelected: false),
    MovieGenreTab(id: 9648, refURL: "https://www.themoviedb.org/t/p/original/amqDACUclaUhGWR2ljVIEPB2k2w.jpg", genreName: "懸疑", isSelected: false),
    MovieGenreTab(id: 10749, refURL: "https://www.themoviedb.org/t/p/original/2eMIpBLnk7QFdCyA3M4ZcP7llDt.jpg", genreName: "愛情", isSelected: false),
    MovieGenreTab(id: 878, refURL: "https://www.themoviedb.org/t/p/original/jQdjGWPXXCAxVJc0EXtBiyG3K4g.jpg", genreName: "科幻", isSelected: false),
    MovieGenreTab(id: 53, refURL: "https://www.themoviedb.org/t/p/original/wjQXZTlFM3PVEUmKf1sUajjygqT.jpg", genreName: "驚悚", isSelected: false),
    MovieGenreTab(id: 10752, refURL: "https://www.themoviedb.org/t/p/original/50VD6QU0NX0aRB6ftKCVWun80bm.jpg", genreName: "戰爭", isSelected: false),
    MovieGenreTab(id: 37, refURL: "https://www.themoviedb.org/t/p/original/hwkhL81vsCSjf3ARs6DGpMIZe8n.jpg", genreName: "西部", isSelected: false),
    
    MovieGenreTab(id: 10770, refURL: "https://www.themoviedb.org/t/p/original/kJ2srEZSlmGfAqLKGVMPhBDdr1G.jpg", genreName: "电视电影", isSelected: false)
]

struct UserSetting : View {
    @EnvironmentObject var userVM : UserViewModel
    @Binding var isSetting : Bool
    @State private var isLogout = false
    var body : some View{
        GeometryReader{proxy in
            let top = proxy.safeAreaInsets.top
            VStack(spacing : 0){
                ZStack(){
                    Text("Edit Profiles")
                        .bold()
                        .font(.system(size: 14))
                        .padding(.bottom)

                    HStack(alignment: .bottom){
                        Button(action:{
                            withAnimation(){
                                self.isSetting.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                                .imageScale(.small)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        Spacer()
                    }
                }
                .padding(.top,top + 10)
                .ignoresSafeArea(.all, edges: .top)

                List(){
                    Section(header:Text("")){
                        
                            fieldCellButton(fieldName: "Help Center", fieldData: "",action: {
                                
                            })
                        
                        fieldCellButton(fieldName: "About App", fieldData: "",action: {
                            
                        })
                    }
                    
                    Section(header:Text("")){
                        Button(action:{
                            withAnimation{
                                self.isLogout = true
                            }
                        }){
                            HStack{
                                Spacer()
                                Text("登出")
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }

                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationTitle("")
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
        .onAppear { UITableView.appearance().isScrollEnabled = false }
        .onDisappear{ UITableView.appearance().isScrollEnabled = true }
        .alert(isPresented: self.$isLogout){
            withAnimation(){
                Alert(title: Text("用戶登出"), message: Text("確定要登出當前帳戶?"),
                      primaryButton: .default(Text("取消")){
                        //
                      },
                      secondaryButton: .default(Text("確定")){
                        withAnimation{
                            self.userVM.isLogIn = false
                        }
                      })
            }
            
        }
        
    }
    
    @ViewBuilder
    private func fieldCellButton(fieldName : String,fieldData : String,dataFieldColor : Color = .white,isImageType:Bool = false,action : @escaping ()->()) -> some View{
        Group{
            Button(action:action){
                HStack(alignment:.center,spacing:0){
                    Text(fieldName)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing,20)
                    Spacer()
                    
                    if isImageType{
                        Image(fieldData)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(10)
                            .clipped()
                    }else{
                        Text(fieldData)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(dataFieldColor)
                        
                    }
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .padding(.horizontal,5)
                }
                .frame(maxWidth:.infinity)
                .font(.system(size: 15))
                .padding(.vertical,8)
                .padding(.horizontal,0)
            }
            .foregroundColor(.gray)

        }

//        .background(Color("appleDark"))
    }
}


//currently just allow user to edit the name
enum EditType {
    case Name
}

struct EditUserName : View {
    @EnvironmentObject var userVM : UserViewModel
    var editType : EditType
    var settingHeader : String = "設定"
    var placeHolder : String = "請輸入您的暱稱"
    var maxSize : Int
    var warningMessage : String = ""
    var defaultValue : String
    @Binding var isCancel : Bool
    @State private var isSave : Bool = false
    @State private var typingLength : Int = 0
    @State private var isFocus : [Bool] = [false,true]
    @State private var tempEditStr : String = ""
    var body : some View{
        
        GeometryReader{ proxy in
            ZStack{
                VStack(alignment:.leading){
                    VStack{
                        HStack(){
                            Button(action:{
                                withAnimation(){
                                    self.isCancel.toggle()
                                }
                            }){
                                Text("取消")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            Text(settingHeader)
                                .font(.system(size: 14))
                            Spacer()
                            
                            Button(action:{
                                self.isSave = true
                                self.userVM.UpdateUserProfile(name: self.tempEditStr)

                            }){
                                Text("完成")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    
                            }
                            .opacity(self.tempEditStr != self.defaultValue && !self.checkIsEmpty() ? 1 : 0 )
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal,10)
                        .padding(.bottom,10)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                    Divider()
                    
                    HStack{
                        CustomTextView(focuse:$isFocus,text: $tempEditStr, maxSize: maxSize,placeholder: placeHolder, keybooardType: .default, returnKeytype: .default, tag: 1)
                            .frame(height: 20)
                         
                        Spacer()
                        Text("\(updateTextCount())/\(maxSize)")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }
                    .padding()
                    .background(Color("appleDark"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture {
                        self.isFocus = [false,true]
                    }
                    
                    Text(warningMessage)
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.horizontal,15)
                        .padding(.top,5)
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear(){
                    self.tempEditStr = defaultValue
                }
                
                if self.userVM.IsUpdating{
                    LoadingView(isLoading: self.userVM.IsUpdating, error: self.userVM.UpdateError as NSError?){
                        self.userVM.UpdateUserProfile(name: tempEditStr)
                    }
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                
            }
        }
    }
    
    func checkIsEmpty() -> Bool{
        return self.tempEditStr.isEmpty
    }
    
    func updateTextCount() -> Int{
        
        return self.tempEditStr.count
    }
    
    func updateValue(){
        switch editType{
        case .Name:
            self.userVM.profile!.name = tempEditStr
        }
    }
    
}
//TODO - TO UPDATE USER MoviePreferences
struct MoviePreferenceSetting : View {
    @EnvironmentObject var userVM : UserViewModel
    @State private var offset : CGFloat = 0.0
    var selectedIds : [Int]
    @StateObject var preferencesMv : MoviePrerefencesSettingModel = MoviePrerefencesSettingModel()
    @Binding var isPreferences : Bool
    var body : some View{
        GeometryReader{proxy in
            VStack(spacing:0){
                VStack{
                    HStack(){
                        Button(action:{
                            withAnimation(){
                                self.isPreferences.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .imageScale(.medium)
                        }
                        Spacer()
                        Text("專屬設定")
                        Spacer()
                        
                        Button(action:{
                            var ids : [Int] = []
                            
                            for info in self.preferencesMv.isSelectedType {
                                ids.append(info.id)
                            }
                            
                            self.userVM.UpdateUserGenresSetting(genreIds: ids){
                                withAnimation{
                                    self.isPreferences.toggle()
                                }
                            }
//
//
//
//                            withAnimation(){
////                              self.userInfo.UserGenrePrerences.append(contentsOf: self.preferencesMv.isSelectedType.map{$0})
//
//                                self.isPreferences.toggle()
//                            }
                        }){
                            Text("完成")
                                .foregroundColor(.white)
                                .imageScale(.medium)
                            
                        }
                    }
                    .font(.system(size:15))
                    .padding(.horizontal,5)
                    .padding(.bottom,10)
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)

              
            
                Divider()
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment:.leading){
                        Text("嗨,\(self.userVM.profile!.name)")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size:15))
                        
                        Text("填寫電影喜好項目,推薦將更符合你的喜好.")
                            .foregroundColor(.gray)
                            .font(.system(size:13))
                            .padding(.bottom,30)
                        
                        
                        HStack{
                            Text("你喜歡的電影類型")
                                .font(.system(size:16))
                                .bold()
                                .foregroundColor(.white)
                            Text("(最多選擇5個類型)")
                                .font(.system(size:13))
                                .foregroundColor(.gray)
                        }
                        
                        SelectionView(genreInfo: $preferencesMv.prerefencesType)
                        Spacer()
                    }

                    .padding(.horizontal,5)
                    .font(.system(size:16))
                    .padding(.top)
                    
                }

                .onAppear(perform:{UIScrollView.appearance().bounces = false})
                .onDisappear(perform: {  UIScrollView.appearance().bounces = true})
                
            }
            .edgesIgnoringSafeArea(.all)
            .environmentObject(preferencesMv)
        }
        .onAppear{
            self.preferencesMv.SetUpSelected(selected: selectedIds)
        }
    }
    
}

struct SelectionView : View {
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @Binding var genreInfo : [MovieGenreTab]
    @EnvironmentObject var vm : MoviePrerefencesSettingModel
    var body : some View{
        LazyVGrid(columns: gridItem){
            ForEach(0..<self.genreInfo.count){i in
                userMoviePreferenceTab(info: self.$genreInfo[i])
                    .padding(5)
            }
        }
        
    }
}

struct userMoviePreferenceTab : View {
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @Binding var info : MovieGenreTab
    @EnvironmentObject var vm : MoviePrerefencesSettingModel
    var body : some View{
        HStack{
            WebImage(url: URL(string:info.refURL)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
            
            Text(info.genreName)
                .font(.footnote)
                .foregroundColor(info.isSelected ? Color.red : Color.gray)
                
            Spacer()
                
        }
        .padding(.horizontal,10)
        .frame(width: 175, height: 70)
        .background(Color("appleDark"))
        .cornerRadius(50)
        .overlay(RoundedRectangle(cornerRadius: 50).stroke(lineWidth: 1).fill(info.isSelected ? Color.red.opacity(0.5) : Color.white.opacity(0.25)))
        .onTapGesture {
            withAnimation(){
                self.vm.updateSelected(preferencesID: info.id)
            }
        }
    }
}

struct profileCardCell : View {
    var Id : Int
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    var action : ()->()

    var body: some View{
        VStack(alignment:.center){
            WebImage(url: userVM.profile!.UserCollection![Id].post_movie_info.PosterURL)
//                .placeholder(Color.gray) //
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))
            Group{
    
                HStack{
                    Text(self.userVM.profile!.UserCollection![Id].post_title)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.vertical,5)
                .font(.system(size: 15))
//                .frame(width:150,alignment: .center)
                
                HStack{
                    HStack(spacing:5){
                        WebImage(url: self.userVM.profile!.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25, alignment: .center)
                            .clipShape(Circle())
                            
                        VStack(alignment:.leading){
                            Text(userVM.profile!.name).bold()
                                .font(.caption)
                                .foregroundColor(Color("subTextGray"))
                            
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing:5){
                        Image(systemName: self.userVM.profile!.UserCollection![Id].is_post_liked ?  "heart.fill" : "heart" )
                            .imageScale(.small)
                            .foregroundColor(self.userVM.profile!.UserCollection![Id].is_post_liked ? .red : .gray)
                            .onTapGesture {
                                withAnimation{
                                    if self.userVM.profile!.UserCollection![Id].is_post_liked {
                                        UnLikePost()
                                    }else {
                                        LikePost()
                                    }
                                    //                                self.isLiked.toggle()
                                }
                            }
                        
                        Text(self.userVM.profile!.UserCollection![Id].post_like_desc)
                            .foregroundColor(Color("subTextGray"))
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal,8)
            
        }
        .padding(.bottom,5)
        .background(Color("MoviePostColor").cornerRadius(5))
        .padding(.horizontal,2)
        .onTapGesture {
            action()
        }

    }
    
    
    private func UnLikePost(){
        self.userVM.profile!.UserCollection![Id].is_post_liked = false
        self.userVM.profile!.UserCollection![Id].post_like_count =  self.userVM.profile!.UserCollection![Id].post_like_count - 1
        let req = RemovePostLikesReq(post_id: self.userVM.profile!.UserCollection![Id].id)
        APIService.shared.RemovePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post unliked")
            case .failure(let err):
                self.userVM.profile!.UserCollection![Id].is_post_liked = true
                self.userVM.profile!.UserCollection![Id].post_like_count =  self.userVM.profile!.UserCollection![Id].post_like_count + 1
                print(err.localizedDescription)
            
            }
        }
        
    }
    
    private func LikePost(){
        self.userVM.profile!.UserCollection![Id].is_post_liked = true
        self.userVM.profile!.UserCollection![Id].post_like_count =  self.userVM.profile!.UserCollection![Id].post_like_count + 1
        let req = CreatePostLikesReq(post_id: self.userVM.profile!.UserCollection![Id].id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                self.userVM.profile!.UserCollection![Id].is_post_liked = false
                self.userVM.profile!.UserCollection![Id].post_like_count =  self.userVM.profile!.UserCollection![Id].post_like_count - 1
                print(err.localizedDescription)
            
            }
        }
    }
}

struct PersonPostCardGridView : View{
    //    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @StateObject var state = ScrollState()
    @EnvironmentObject var userVM  : UserViewModel
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
                FlowLayoutWithLoadMoreView(isLoading:$userVM.IsPostLoading,isInit:.constant(true),list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10,isScrollable: $userVM.isAllowToScroll, content: { info in
                    
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
                    
                    
                })
            }
            
        }

    }
    
}

//is liked by user
struct LikedMovieCard : Identifiable ,Codable{
    let id : Int
    let movie_name : String
    let genres : [MovieGenre]
    let movie_poster : String
    let vote_average: Double
    
    var posterPath : URL {
        return URL(string: "https://www.themoviedb.org/t/p/original\(movie_poster)")!
    }

}

struct LikedPostCardGridView : View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @State private var isShowMovieDetail : Bool = false
    @State private var movieId : Int = -1
    
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack{
            if userVM.profile!.UserLikedMovies != nil{
                ScrollView(.vertical,showsIndicators: false){
                    if userVM.profile!.UserLikedMovies!.isEmpty{
                        //                        Spacer()
                        Text("無喜歡電影")
                            .font(.system(size:15))
                            .foregroundColor(.gray)
                            .padding(.top,10)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.5, alignment: .top)
                        //                        Spacer()
                    }else {
                        LazyVStack{
                            LazyVGrid(columns: gridItem){
                                ForEach(userVM.profile!.UserLikedMovies!,id:\.id){info in
                                    LikedCardCell(movieInfo: info)
                                        .onTapGesture {
                                            withAnimation{
                                                self.movieId = info.id
                                                withAnimation{
                                                    self.isShowMovieDetail = true
                                                }
                                            }
                                        }
                                        .task {
                                            if self.userVM.isLastLikedMovie(movieID: info.id)  {
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
                }
                .introspectScrollView{ ScrollView in
                    ScrollView.isScrollEnabled = userVM.isAllowToScroll
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

struct LikedCardCell : View {
    var movieInfo : LikedMovieCard

    var body: some View{
        VStack(alignment:.center){
            ZStack(alignment:.top){
                
                WebImage(url: movieInfo.posterPath)
//                    .placeholder(Color.gray) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
                    .overlay(Color.black.opacity(0.5))
                    .zIndex(0)
                
                VStack(alignment:.leading){
                    HStack(spacing:5){
                        ForEach(0..<(movieInfo.genres.count > 3 ? 3 : movieInfo.genres.count),id :\.self ){i in
                            Text(movieInfo.genres[i].name)
                                .foregroundColor(Color.white)
                                .font(.footnote)
                                .padding(5)
                                .background(Color("appleDark").opacity(0.7).cornerRadius(8))
                            
                        }

                        Spacer()
                    }
                    
                    Spacer()
                    
                    
                    VStack(alignment:.leading){
                        //Movie Full Name
   
                            Text(movieInfo.movie_name)
                                .foregroundColor(.white)
                                .font(.system(size:18))
                                .bold()
                                .padding(.bottom,5)
                                .lineLimit(1)
                            
                            HStack(spacing:5){
                                ForEach(0..<5){i in
                                    Image(systemName:"star.fill" )
                                        .imageScale(.small)
                                        .foregroundColor(i < Int(movieInfo.vote_average / 2) ? Color.yellow : Color.gray)
                                        .font(.system(size:12))
                                }

                            
                        }
                    
                    }

                }
                .padding(8)
            }
            
        }
        .background(Color("MoviePostColor").cornerRadius(5))

    }
}

//struct CreateNewListView : View {
//    @State private var listTitle : String = ""
//    @Binding var isAddingList : Bool
//    @EnvironmentObject var userModel : UserViewModel
//    @State private var isLoading = false
//    @State private var err : Error?
//    var body : some View {
//        ZStack{
//            VStack(alignment:.leading){
//                Text("Create a new list")
//                    .bold()
//                    .font(.system(size:35))
//                    .padding(.leading)
//
//
//                List(){
//                    Section("LIST INFORMATION"){
//                        HStack{
//                            Text("Title:")
//                            TextField("List Title", text: $listTitle)
//                        }
//                    }
//
//                    Button(action:{
//                        //Create a list
//                        CreateNewList()
//                    }){
//                        Text("Create")
//                    }
//
//                    Button(action:{
//                        //do nothing and back to the page
//                        withAnimation{
//                            self.isAddingList = false
//                        }
//                    }){
//                        Text("Cancel")
//                    }
//
//                }
//            }
//            .padding(.top,30)
//
//            if isLoading || self.err != nil {
//                LoadingView(isLoading: isLoading, error: err as NSError?){
//                    CreateNewList()
//                }
//                .background(BlurView().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            }
//
//        }
//    }
//
//    func CreateNewList() {
//        if listTitle.isEmpty{
//            return
//        }
//
//        let newList = CreateNewCustomListReq(title: listTitle)
//        self.isLoading = true
//        APIService.shared.CreateCustomList(req: newList){ (result) in
//            self.isLoading = false
//            switch result{
//            case .success(let data):
//                let listInfo = CustomListInfo(id: data.id, title: data.title, movie_list: [])
//                userModel.profile!.UserCustomList!.append(listInfo)
//                self.err = nil
//                withAnimation(){
//                    self.isAddingList = false
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                self.err = err
//            }
//        }
//    }
//}

struct CustomListView : View{
    @Binding var addList : Bool
    @Binding var isViewMovieList : Bool
    @Binding var listIndex : Int
    @EnvironmentObject var userVM : UserViewModel
//    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack(alignment:.leading){
            NavigationLink(destination: CreateMovieList(isCreateList: $addList)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(userVM)
                           ,isActive: $addList){

                Button(action:{
                    withAnimation(){
                        self.addList.toggle()
                    }
                }){
                    HStack(spacing:5){
                        Group{
                            Text("建立新專輯")
                                .font(.system(size:14,weight:.semibold))
                            Spacer()
                                Image(systemName: "chevron.right")
                                .imageScale(.medium)
                        }
                        .padding(.horizontal,5)
                    }
                    .frame(height: 40)
                    .background(Color("appleDark"))
                    .cornerRadius(8)
                }.buttonStyle(.plain)


            }

            if self.userVM.profile!.UserCustomList != nil{
                ScrollView{
                    if self.userVM.profile!.UserCustomList!.isEmpty {
                        Text("無收藏專輯")
                            .font(.system(size:15))
                            .foregroundColor(.gray)
                        
                    } else {
                        LazyVStack {
                            ListInfo()
                            if self.userVM.IsListLoading{
                                ActivityIndicatorView()
                                    .padding(.bottom,15)
                            }
                        }
                        
                    }
                }.introspectScrollView{ ScrollView in
                    ScrollView.isScrollEnabled = userVM.isAllowToScroll
                }
            }

            
        }
        .padding(8)
    }
    
    @ViewBuilder
    func ListInfo() -> some View {
        ForEach(0..<self.userVM.profile!.UserCustomList!.count,id:\.self){ i in
            
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
            .onTapGesture{
                withAnimation{
                    self.isViewMovieList.toggle()
                    self.listIndex = i
                }
            }
            .task {
                if self.userVM.isLastList(listID: self.userVM.profile!.UserCustomList![i].id) {
                    await self.userVM.AsyncGetMoreUserList(userID: self.userVM.userID!)
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

struct EditProfile : View{
    @EnvironmentObject var userVM : UserViewModel
    @Binding var isEditProfile : Bool
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var userIcon : UIImage?
//    @State private var BackGoundImg : UIImage?
    
    @State private var userIconPicker : Bool = false
    @State private var BackGoundImgPicker : Bool = false
    
    @State private var isPreference : Bool = false
    @State private var isEditName : Bool = false
    @State private var isEditeID : Bool = false
//    @State private var isEditeBIO : Bool = false
    

    var body : some View{
        GeometryReader{ proxy in
            ZStack{
                let top = proxy.safeAreaInsets.top
                VStack(spacing : 0){
                    ZStack(){
                        Text("編輯資料")
                            .bold()
                            .font(.system(size: 14))
                            .padding(.bottom)

                        HStack(alignment: .bottom){
                            Button(action:{
                                withAnimation(){
                                    self.isEditProfile.toggle()
                                }
                            }){
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .imageScale(.small)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            Spacer()
                        }
                    }
                    .padding(.top,top + 10)
                    .ignoresSafeArea(.all, edges: .top)
    //                .background(Color.red)

                    List(){
                        HStack{
                            Spacer()
                            WebImage(url: self.userVM.profile!.UserPhotoURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.white)
                                )
                                .overlay(
                                    HStack{
                                        Image(systemName: "camera")
                                            .imageScale(.small)
                                            .foregroundColor(.black)
                                    }
                                        .frame(width: 25, height: 25)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                    ,alignment: .bottomTrailing
                                )
                                .onTapGesture {
                                    //TO CHANGE PHOTO
                                    print("Change")
                                    withAnimation(){
                                        self.userIconPicker.toggle()
                                    }
                                }
                            Spacer()
                        }
                        .padding(.vertical)

                        fieldCellButton(fieldName: "名字", fieldData: userVM.profile!.name,action: {
                            withAnimation(){
                                self.userVM.isEditName.toggle()
                            }
                        })
                        
                        fieldCellButton(fieldName: "背景圖片",  fieldData: self.userVM.profile!.UserBackGroundURL,isImageType: true,action:{
                            withAnimation(){
                                self.BackGoundImgPicker.toggle()
                            }
                        })
                        
                        fieldCellButton(fieldName: "電影喜好", fieldData: "",action:{
                            withAnimation(){
                                self.isPreference.toggle()
                            }
                        })
        
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .navigationTitle("")
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.all)
                
                if self.userVM.IsUploading{
                    HStack{
                        ActivityIndicatorView()
                        Text("Uploading...")
                            .font(.system(size:14))
                    }
                    .frame(maxWidth:.infinity,maxHeight:.infinity)
                        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
            }
        }
        .onAppear { UITableView.appearance().isScrollEnabled = false }
        .onDisappear{ UITableView.appearance().isScrollEnabled = true }
        .fullScreenCover(isPresented: self.$userVM.isEditName){
            EditUserName(
                editType: .Name,
                settingHeader: "設置名字",
                placeHolder: "輸入名字",
                maxSize: 20,
                warningMessage: "設置長度為2-24個字符，不包含非法字符",
                defaultValue: self.userVM.profile!.name,
                isCancel: self.$userVM.isEditName)
        }
        
        .fullScreenCover(isPresented: $userIconPicker){
            EditableImagePickerView(sourceType: .photoLibrary, imageUploadType: .Avatar)
                .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $BackGoundImgPicker){

            EditableImagePickerView(sourceType: .photoLibrary, imageUploadType: .Cover)
                .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isPreference){
            MoviePreferenceSetting(selectedIds: self.userVM.GetPreferenceIds(), isPreferences: $isPreference)
        }
    }
    
    @ViewBuilder
    private func fieldCellButton(fieldName : String,fieldData : Any,dataFieldColor : Color = .white,isImageType:Bool = false,action : @escaping ()->()) -> some View{
        Group{
            Button(action:action){
                HStack(alignment:.center,spacing:0){
                    Text(fieldName)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing,20)
                    Spacer()
                    
                    if isImageType{
                        WebImage(url: fieldData as? URL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(10)
                            .clipped()
                    }else{
                        Text(fieldData as! String)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(dataFieldColor)
                        
                    }
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .padding(.horizontal,5)
                }
                .frame(maxWidth:.infinity)
                .font(.system(size: 15))
                .padding(.vertical,8)
                .padding(.horizontal,0)
            }
            .foregroundColor(.gray)

        }

//        .background(Color("appleDark"))
    }
}

enum ProfileTab : String {
    case Posts = "文章"
    case Likes = "喜歡"
    case MyLists = "收藏"
}

struct ProfileViewTab : Identifiable{
    let id : Int
    let tabName : ProfileTab
    let sysImg : String
}

let tabsInfo : [ProfileViewTab] = [
    ProfileViewTab(id: 0, tabName: .Posts,sysImg: "square.filled.on.square"),
    ProfileViewTab(id: 1, tabName: .Likes,sysImg: "heart.fill"),
    ProfileViewTab(id: 2, tabName: .MyLists,sysImg: "list.and.film"),
]


struct PersonPostTabBar : View{
    @Namespace var namespace
    @Binding var tabIndex : Int
    var body : some View{
        HStack(spacing:10){
            ForEach(tabsInfo,id:\.id){ tab in
                VStack(spacing:12){
                    HStack{
                        Image(systemName:tab.sysImg)
                            .imageScale(.medium)
                        Text(tab.tabName.rawValue)
                            .font(.system(size:14,weight:.semibold))
                         
                    }
                    .foregroundColor(tabIndex == tab.id ? .white : .gray)
                    
                    ZStack{
                        if tabIndex == tab.id {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.orange)
                                .matchedGeometryEffect(id: "TAB", in: namespace)
                        } else {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.clear)
                        }
                    }
                    .padding(.horizontal,8)
                    .frame(height: 4)
                }
//                .animation(.easeInOut)
//                        .transition(.slide)
                .contentShape(Rectangle())
                .onTapGesture(){
                    withAnimation(.easeInOut){
                        tabIndex = tab.id
                    }
                }
            }
        }
        .frame(height:50,alignment: .bottom)
        .padding(.bottom,5)
        .background(Color("appleDark"))
    }

}

struct RefershState {
    var startOffset : CGFloat = 0
    var offset : CGFloat = 0
    var started : Bool
    var released : Bool
    
}


struct personProfile: View {
    @Binding var isShowMenu : Bool
//    @Binding var isShowLikedMovie : Bool
    @StateObject var state = ScrollState()
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

    @State private var headerOffset : CGFloat = 0
    @State private var headerMinY : CGFloat = 0
    @State private var height : CGFloat = 0
    
    
//    @State private var isAbleToScroll = false
    @State private var friends : Int = 0
    @State private var posts : Int = 0
    @State private var collected : Int = 0

    var body: some View {
        GeometryReader { globalProxy in
            ZStack(alignment:.top){
                ZStack{
                    VStack(alignment:.center){
                        Spacer()
                        HStack{
                            WebImage(url: userVM.profile!.UserPhotoURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30, alignment: .center)
                                .clipShape(Circle())
                            
                            Text(userVM.profile!.name)
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
                    .overlay{
                        GeometryReader{ cal  -> AnyView  in
                            let frame = cal.frame(in:.global)
                            if navHeigh == 0 {
                                DispatchQueue.main.async {
                                    self.navHeigh = frame.height
                                }
                            }
                            
                            if headerMinY == 0 {
                                DispatchQueue.main.async {
                                    self.navHeigh = frame.maxY
    //                                print(self.navHeigh)
                                }
                            }
                            
                            return AnyView(Color.clear)
                        }
                        
                    }
                    
                    HStack{
                        Button(action:{
                            withAnimation{
                                self.isShowMenu = true
                            }
                        }){
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: topEdge)
                    .padding(.top,30)
                    .zIndex(1)
                }
                .background(Color("appleDark").opacity(getOpacity()))
                .zIndex(1)
                
                
                
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false){
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
                            ZStack{
                                GeometryReader{ reader -> AnyView in
                                    let frame = reader.frame(in: .global)
                                    let minY = reader.frame(in: .global).minY
                                    if state.initOffsetY == 0 {
                                        state.initOffsetY = minY
                                    }
                                    
                                    DispatchQueue.main.async {
                                        //MARK: PULL TO RELOAD
                                        state.currOffset = minY
                                        
                                        if state.currOffset - state.initOffsetY > state.progressViewHeight && state.state == .normal {
                                            feedBack.impactOccurred(intensity: 0.8)
                                            withAnimation{
                                                state.state = .PullDown
                                            }
                                        }
                                        
                                        
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
                                        WebImage(url: userVM.profile!.UserBackGroundURL)
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
                                    .frame(height: globalProxy.frame(in: .global).height - 78 - self.headerHeight)
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
                    .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
                    .zIndex(0)
                    .onChange(of: state.state){ newVal in
                        if newVal == .refershHeader {
                            Task.init{
                                await refersh()
                                self.state.state = .normal
                            }
                        }

                    }

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

       
    }
    
    private func refersh() async{
        switch self.tabIndex {
        case 0 :
            print("refershing post")
            await self.userVM.AsyncGetPost(userID: self.userVM.userID!)
        case 1:
            print("refershing liked")
            await self.userVM.AsyncGetUserLikedMoive(userID: self.userVM.userID!)
        case 2:
            print("refershing list")
            await self.userVM.AsyncGetUserList(userID: self.userVM.userID!)
        default:
            print("empty...")
        }
    }
    
    @ViewBuilder
    private func profileCellItems() -> some View{
        GeometryReader{ proxy in
            HStack(spacing:0){
                PersonPostCardGridView()
                    .padding(.vertical,3)
                    .environmentObject(userVM)
                    .frame(width: UIScreen.main.bounds.width)
//                    .disabled(!userVM.isAllowToScroll)
                
                
                LikedPostCardGridView()
                    .environmentObject(userVM)
                    .padding(.vertical,3)
                    .frame(width: UIScreen.main.bounds.width)

                
                CustomListView(addList: $isAddingList,isViewMovieList:$isViewMovieList, listIndex:$listIndex)
                    .environmentObject(userVM)
                    .padding(.vertical,3)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .offset(x : CGFloat(self.tabIndex) * -UIScreen.main.bounds.width)
            .onChange(of: self.tabIndex){index in
                if index == 1 {
                    if userVM.profile!.UserLikedMovies == nil{
//                        print("init liked movie")
//                        userVM.getUserLikedMovie()
                        Task.init {
                            await self.userVM.AsyncGetUserLikedMoive(userID:self.userVM.userID!)
                        }
                    }
                }else if index == 2{
                    if userVM.profile!.UserCustomList == nil{
                        print("init list movie")
                        userVM.getUserList()
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
//            Spacer()
            VStack(alignment:.center){
                VStack(spacing:0){
                    Spacer(minLength: 0)
                    if state.state == .refershHeader{
                        ActivityIndicatorView()
                            .frame(height: state.progressViewHeight)
                    } else {
                        Image(systemName: "arrow.down")
                            .frame(height: state.progressViewHeight)
                            .rotationEffect(.degrees(self.state.state == .normal ? 0 : 180))
                            .opacity(self.state.progressViewCurrentHeight == 0 ? 0 : 1)
                    }
                }
                .frame(height:state.progressViewCurrentHeight)
                .frame(maxWidth:.infinity)
                .clipped()
                
                
                HStack(spacing:20){
                    WebImage(url: userVM.profile!.UserPhotoURL)
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
                    Text(userVM.profile!.name).bold()
                        .font(.title2)
                    
                    Text("@\(userVM.profile!.name)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                }
                
                VStack(alignment:.leading,spacing: 8){
                    if self.userVM.profile!.UserGenrePrerences != nil && self.userVM.fetchUserGenreError == nil && !self.userVM.isUserGenresLoading{

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
//                            .padding(.top,5)
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
                        Text(self.posts.description)
                            .bold()
                    }
                    Spacer()
                    VStack{
                      
                        Text("朋友")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(self.friends.description)
                            .bold()
                    }
                    Spacer()
                    VStack{
                       
                        Text("收藏")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(self.collected.description)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.top,5)

            }
                .padding(.bottom)
//

        
        }
        .padding(.horizontal)
        .onAppear{
            getPostCount()
            getFriendCount()
            Task.init{
                await self.getCollectedMovieCount()
            }
        }
       
    }
    
    private func getPostCount(){
        let req = CountUserPostReq(user_id: self.userVM.profile!.id)
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
        let req = CountFriendReq(user_id: self.userVM.profile!.id)
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
    
    private func getCollectedMovieCount() async{
        let resp = await APIService.shared.GetCollectedMovieCount(userID: self.userVM.profile!.id)
        switch resp {
        case .success(let data):
            self.collected = data.total
        case .failure(let err):
            print(err.localizedDescription)
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

//struct personProfile: View {
//    @EnvironmentObject private var userVM : UserViewModel
//    @EnvironmentObject private var postVM : PostVM
//    @State private var isEditProfile : Bool = false
//    @State private var isSetting : Bool = false
//    @State private var isAddingList : Bool = false
//    @State private var refersh = RefershState(started: false, released: false)
//    private let max = UIScreen.main.bounds.height / 2.5
//    var topEdge : CGFloat
//
//    @State private var offset:CGFloat = 0.0
//    @State private var menuOffset:CGFloat = 0.0
//    @State private var isShowIcon : Bool = false
//    @State private var tabBarOffset = UIScreen.main.bounds.width
//    @State private var tabOffset : CGFloat = 0.0
//    @State private var tabIndex : Int = 0
//    @State private var listIndex : Int = 0
//    @State private var isViewMovieList : Bool = false
//
////    @State private var follower : Int = 0
////    @State private var following : Int = 0
//    @State private var friends : Int = 0
//    @State private var posts : Int = 0
//    @State private var viewSIze : CGSize = .zero
//    var body: some View {
//        ZStack(alignment:.top){
//            ZStack{
////                it may add in the Future
////                HStack{
////                    Button(action:{}){
////                        Image(systemName: "line.3.horizontal")
////                            .foregroundColor(.white)
////                            .font(.title2)
////                    }
////                    Spacer()
////                }
////                .padding(.horizontal)
////                .frame(height: topEdge)
////                .padding(.top,30)
////                .zIndex(1)
//
//                VStack(alignment:.center){
//                    Spacer()
//                    HStack{
//                        WebImage(url: userVM.profile!.UserPhotoURL)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .clipShape(Circle())
//
//                        Text(userVM.profile!.name)
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
//
//            GeometryReader { proxy in
//                ScrollViewReader{proxy in }
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
//                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
//                        GeometryReader{ proxy  in
//                            ZStack(alignment:.top){
//                                WebImage(url: userVM.profile!.UserBackGroundURL)
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
//
//                                profile()
//                                    .frame(maxWidth:.infinity)
//                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
//                                    .zIndex(2)
//
//                            }
//                        }
//                        .frame(height:max)
//                        .offset(y:-offset)
//
//                        Section {
//
////                            VStack(spacing:0){
//                                switch tabIndex{
//                                case 0:
//                                    PersonPostCardGridView()
//                                        .padding(.vertical,3)
//                                        .environmentObject(userVM)
//    //                                    .background(Color.red)
//                                case 1:
//                                    LikedPostCardGridView()
//                                        .environmentObject(userVM)
//                                        .padding(.vertical,3)
//                                        .onAppear{
//                                            //TODO: NEED TO BE FIXED
//
//                                            userVM.getUserLikedMovie()
//
//                                        }
//                                case 2:
//                                    CustomListView(addList: $isAddingList,isViewMovieList:$isViewMovieList, listIndex:$listIndex)
//                                        .environmentObject(userVM)
//                                        .padding(.vertical,3)
//                                        .onAppear{
//                                            //TODO: NEED TO BE FIXED
//                                            userVM.getUserList()
//
//                                        }
//                                default:
//                                    EmptyView()
//                                }
////                            }
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
//
//                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
//                .zIndex(0)
//                .onAppear{
//                    self.userVM.getUserPosts()
//                    self.userVM.GetUserGenresSetting()
//                }
//
//
//            }
//
//        }
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
//        .background(
//            ZStack{
//
//                NavigationLink(destination:   PostDetailView(postForm: .Profile, isFromProfile: true,postInfo:
//                                                                self.$postVM.selectedPostInfo)
//                    .navigationBarTitle("")
//                    .navigationTitle("")
//                    .navigationBarBackButtonHidden(true)
//                    .navigationBarHidden(true)
//                    .environmentObject(userVM)
//                    .environmentObject(postVM), isActive: self.$postVM.isShowPostDetail){
//                        EmptyView()
//
//
//                    }
//
//
//
//            }
//        )
//
//
//    }
//
//    func updateData() async{
//        do {
//            try await Task.sleep(nanoseconds: 2_000_000_000)
//            self.refersh.started = false
//            self.refersh.released = false
//            print("done")
//        }catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    @ViewBuilder
//    func profile() -> some View{
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
//
//            HStack(alignment:.center){
//                WebImage(url: userVM.profile!.UserPhotoURL)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 80, alignment: .center)
//                    .clipShape(Circle())
//                    .overlay(
//                        Circle()
//                            .stroke(lineWidth: 2)
//                            .foregroundColor(.white)
//                    )
////                    .overlay(
////                        HStack{
////                            Image(systemName: "plus")
////                                .imageScale(.small)
////                        }
////                            .frame(width: 20, height: 20)
////                            .background(Color.orange)
////                            .clipShape(Circle())
////                            ,alignment: .bottomTrailing
////                    )
//
//                VStack(alignment:.leading){
//                    Text(userVM.profile!.name).bold()
//                        .font(.title2)
//
//                    Text("@\(userVM.profile!.name)")
//                        .font(.caption)
//                        .foregroundColor(Color.gray)
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
//                if self.userVM.profile!.UserGenrePrerences != nil && self.userVM.fetchUserGenreError == nil && !self.userVM.isUserGenresLoading{
//
//                    if self.userVM.profile!.UserGenrePrerences!.isEmpty{
//                        Text("使用者沒有特定喜好的電影項目~")
//                            .font(.footnote)
//                    }else{
//
//                        HStack{
//                            ForEach(0..<userVM.profile!.UserGenrePrerences!.count){i in
//                                Text(userVM.profile!.UserGenrePrerences![i].name)
//                                        .font(.caption)
//                                        .padding(8)
//                                        .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//
//
//                            }
//                        }
//                        .padding(.top,5)
//                    }
//                }
//            }
//
//
//            HStack(spacing:8){
//
//
//                VStack{
//                    Text(self.posts.description)
//                        .bold()
//                    Text("文章")
//                }
//
//                VStack{
//                    Text(self.friends.description)
//                        .bold()
//                    Text("朋友")
//                }
//
//
////                VStack{
////                    Text(self.following.description)
////                        .bold()
////                    Text("關注")
////                }
////
////                VStack{
////                    Text(self.follower.description)
////                        .bold()
////                    Text("粉絲")
////                }
//
//                Spacer()
//
//                Button(action:{
//                    //TODO : Edite data
//                    withAnimation(){
//                        self.isEditProfile.toggle()
//                    }
//                }){
//                    NavigationLink(destination:
//                                    EditProfile(isEditProfile: $isEditProfile)
//                                    .environmentObject(userVM)
//                                   , isActive: $isEditProfile){
//                        Text("編輯資料")
//                            .navigationBarBackButtonHidden(true)
//                            .padding(8)
//                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                            .overlay(RoundedRectangle(cornerRadius: 25).stroke())
//                    }
//                }
//                .buttonStyle(StaticButtonStyle())
//                .foregroundColor(.white)
//
//                Button(action:{
//                    //TODO : Edite data
//                }){
//                    NavigationLink(destination: UserSetting(isSetting: $isSetting)
//                        .environmentObject(userVM)
//                                   , isActive: $isSetting){
//                        Image(systemName: "gearshape")
//                            .padding(.horizontal,5)
//                            .padding(8)
//                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
//                            .overlay(RoundedRectangle(cornerRadius: 25).stroke())
//                    }
//                }
//                .foregroundColor(.white)
//
//            }
//            .font(.footnote)
//            .padding(.vertical)
//
//        }
//        .padding(.horizontal)
//        .onAppear{
////            getFollowing()
////            getFollower()
//            getPostCount()
//            getFriendCount()
//        }
//
//    }
//
//    private func getPostCount(){
//        let req = CountUserPostReq(user_id: self.userVM.profile!.id)
//        APIService.shared.CountUserPosts(req: req) { result in
//            switch result{
//            case .success(let data):
//                self.posts = data.total_posts
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//
//        }
//    }
//
//    private func getFriendCount(){
//        let req = CountFriendReq(user_id: self.userVM.profile!.id)
//        APIService.shared.CountFriend(req: req) { result in
//            switch result{
//            case .success(let data):
//                print(data.total)
//                self.friends = data.total
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//
//        }
//    }
//
////    private func getFollower(){
////        let req = CountFollowedReq(user_id: self.userVM.profile!.id)
////        APIService.shared.CountFollowedUser(req: req) { result in
////            switch result{
////            case .success(let data):
////                print(data.total)
////                self.follower = data.total
////            case .failure(let err):
////                print(err.localizedDescription)
////            }
////
////        }
////    }
////    private func getFollowing(){
////            let req = CountFollowingReq(user_id: self.userVM.profile!.id)
////            APIService.shared.CountFollowingUser(req: req) { result in
////                switch result{
////                case .success(let data):
////                    print(data.total)
////                    self.following = data.total
////                case .failure(let err):
////                    print(err.localizedDescription)
////                }
////
////            }
////    }
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
//
//}


struct Size: PreferenceKey {

    typealias Value = [CGRect]
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
