//
//  WebImage.swift
//  IOS_DEV
//
//  Created by Jackson on 18/4/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect


    
struct MovieDetailView: View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    let movieId: Int
    @StateObject private var movieDetailState = MovieDetailState()
    @StateObject private var movieImagesState = MovieImagesState()
    @Binding var isShowDetail : Bool
    @State private var isShowSheet = false
    @State private var isAddToUserList = false
    @State private var isCreateNewMoiveList = false
    
    @State private var isUserLiked :  Bool = false
    @State private var collectedListId : Int = 0
    @State private var movieLikes : Int = 0
    @State private var movieCollectes : Int = 0
    @State private var isAddPost = false
    var body: some View {
        VStack {
            if movieDetailState.movie != nil && self.movieImagesState.movieImage != nil{
                GeometryReader{ proxy in
                    NewDetailView(movie: self.movieDetailState.movie!,movieImages: self.movieImagesState.movieImage!,isShow: $isShowDetail ,isShowSheet: $isShowSheet,isAddToList: $isAddToUserList,isUserLiked: $isUserLiked,collectedListId: $collectedListId,movieLikes: $movieLikes,movieCollected: $movieCollectes,isAddPost: $isAddPost, topEdge: proxy.safeAreaInsets.top)
                        .SheetWithDetents(isPresented: self.$isShowSheet, detents: [.medium(),.large()]){
                            self.isShowSheet = false
                            self.isAddToUserList = false
                            self.isAddPost = false
                        } content :{
                            VStack{
                                if isAddPost {
                                    AddMoviePostView(movie:self.movieDetailState.movie!, isAddNewPost: $isAddPost,isShowSheet : $isShowSheet)
                                        .environmentObject(postVM)
                                        .environmentObject(userVM)
                                } else if isCreateNewMoiveList {
                                    AddNewUserListView(movie: self.movieDetailState.movie!, isShowCustomList: $isShowSheet, isAddToUserList: $isAddToUserList, isCreateNewMoiveList: $isCreateNewMoiveList,movieCollected:$movieCollectes)
                                } else {
                                    UserListView(movieId: movieId, isShowCustomList: self.$isShowSheet, isCreateNewMoiveList: self.$isCreateNewMoiveList, isAddToUserList: $isAddToUserList,movieCollected:$movieCollectes)
                                        .environmentObject(userVM)
                                }
                            }
                        }
                        .ignoresSafeArea(.all, edges: .top)
                }
                
            }else {
                
                LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                    self.movieDetailState.loadMovie(id: self.movieId)
                }
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if self.movieImagesState.movieImage == nil {
                self.movieImagesState.loadMovieImage(id: self.movieId)
            }
            
            if self.movieDetailState.movie == nil {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            self.IsUserLiked()
            self.IsUserCollected()
            self.CountMovieCollected()
            self.CountMovieLiked()
            
        }
        
    }
    
    func IsUserLiked(){
        let req = IsLikedMovieReq(movie_id: self.movieId)
        APIService.shared.IsLikedMovie(req: req){ result in
            switch result {
            case .success(let data):
                print("user liked movie \(data.is_liked_movie)")
                self.isUserLiked = data.is_liked_movie
            case .failure(let err):
                print(err.localizedDescription)
                
            }
        }
    }
    
    func IsUserCollected(){
        let req = GetOneMovieFromUserListReq(movie_id: self.movieId)
        APIService.shared.GetOneMovieFromUserList(req: req){ result in
            switch result {
            case .success(let data):
                print("user collected info \(data.is_movie_in_list)")
                self.isAddToUserList = data.is_movie_in_list
                if data.is_movie_in_list {
                    self.collectedListId = data.list_id
                }
            case .failure(let err):
                print("GET MOVIE COLLECTED INFO ERROR")
                print(err.localizedDescription)
                
            }
        }
    }
    
    func CountMovieLiked(){
        let req = CountMovieLikesReq(movie_id: self.movieId)
        APIService.shared.GetMovieLikedCount(req: req){ result in
            switch result{
            case .success(let data):
                print("movies likes\(data.total_liked)")
                self.movieLikes = data.total_liked
            case .failure(let err):
                print("get likes err \(err.localizedDescription)")
            }
        }
    }
    
    func CountMovieCollected(){
        let req = CountMovieCollectedReq(movie_id: self.movieId)
        APIService.shared.GetMovieCollectedCount(req: req){ result in
            switch result{
            case .success(let data):
                print("movies collected \(data.total_collected)")
                self.movieCollectes = data.total_collected
            case .failure(let err):
                print("get collects err \(err.localizedDescription)")
            }
        }
    }
}

struct UserListView : View {
    @EnvironmentObject var userVM : UserViewModel
    
    var movieId : Int
    @Binding  var isShowCustomList : Bool
    @Binding  var isCreateNewMoiveList : Bool
    @Binding var isAddToUserList : Bool
    @Binding var movieCollected : Int
    var body: some View {
        VStack(spacing:0){
            Text("加入專輯")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        Spacer()
                        Button(action: {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // or even shorter
                                withAnimation{
                                    self.isShowCustomList = false
                                }
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
                .padding(.vertical,8)
                .padding(5)
            VStack(spacing:0){
                if userVM.IsListLoading || userVM.ListError != nil {
                    HStack{
                        LoadingView(isLoading: userVM.IsListLoading, error: userVM.ListError as NSError?){
                            //TODO: Fetch again
                        }
                    }.frame(maxHeight:.infinity,alignment: .top)
                    
                } else if userVM.profile!.UserCustomList != nil {
                    if userVM.profile!.UserCustomList!.isEmpty {
                        HStack{
                            Text("Haven't create an list yet!")
                                .font(.system(size:14))
                        }.frame(maxHeight:.infinity,alignment: .top)
                    }else {
                        List(userVM.profile!.UserCustomList!,id:\.id){  listInfo  in
                            Button(action:{
                                //TODO: ADD TO THE LIST
//
                                APIService.shared.InsertMovieToList(movieID: self.movieId, listID: listInfo.id){ result in
                                    switch result {
                                    case .success(_ ):
                                        print("success")
                                        self.movieCollected = self.movieCollected + 1
                                        withAnimation{
                                            self.isAddToUserList = true
                                            self.isShowCustomList = false
                                        }
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                        withAnimation{
                                            self.isShowCustomList  = false
                                        }
                                    }
                                }
                            }){
                                HStack{
                                    if listInfo.movie_list != nil {
                                        WebImage(url: listInfo.movie_list![0].posterURL)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35)
                                            .cornerRadius(8)
                                    }else {
                                        Rectangle()
                                            .fill(Color("DarkMode2"))
                                            .frame(width: 35,height:35 * 1.5)
                                            .cornerRadius(8)
                                        
                                    }
                                    
                                    Text(listInfo.title)
                                        .font(.system(size:14,weight:.semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listStyle(.plain)
                    }
                }
                else {
                    HStack{
                        Text("???")
                    }
                }
            }
            .frame(maxHeight:.infinity,alignment: .top)
            
           
            Divider()
            HStack{
                Text("新增專輯")
                    .font(.system(size:16,weight:.semibold))
                    .onTapGesture{
                        DispatchQueue.main.async{
                            self.isShowCustomList = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            self.isShowCustomList = true
                            self.isCreateNewMoiveList = true
                        }
                        
                    }
//                        .padding(.bottom)
            }
            .padding()
        }

    }

}

struct AddNewUserListView : View {
    @EnvironmentObject var userVM : UserViewModel
    var movie : Movie
    
    @Binding var isShowCustomList : Bool
    @Binding var isAddToUserList : Bool
    @Binding var isCreateNewMoiveList : Bool
    @Binding var movieCollected : Int
    @State private var listTitle : String  = ""
    @FocusState private var isFocus : Bool
    var body: some View {
        VStack(spacing:0){
            Text("加入專輯")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        if !listTitle.isEmpty {
                            Button(action: {
                                CreateNewList()
                            }){
                                Text("完成")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.isAddToUserList = false
                                self.isShowCustomList = false
                                self.isCreateNewMoiveList = false
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
                .padding(.vertical,8)
                .padding(5)
            VStack(spacing:0){
                HStack{
                    WebImage(url: movie.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .cornerRadius(8)
                    
                    VStack{
                        TextField("為您的專輯建立名稱", text: $listTitle)
                            .submitLabel(.done)
                            .accentColor(.white)
                            .ignoresSafeArea(.keyboard)
//                            .focused($isFocus)
                            .font(.system(size:14))
                        
                        Divider()
                    }
                    .padding(.horizontal,8)
                }
            }
            .padding(5)
        }
        .frame(maxHeight:.infinity,alignment:.top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func CreateNewList(){
        if listTitle.isEmpty { return }
        
        let req = CreateNewCustomListReq(title: self.listTitle, intro: "")
        APIService.shared.CreateCustomList(req: req){ result in
            switch result {
            case .success(let data):
                print("created")
                InsertToList(listID: data.id)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func InsertToList(listID : Int){
        APIService.shared.InsertMovieToList(movieID: self.movie.id, listID: listID){ result in
            switch result {
            case .success(_):
                print("inserted")
                self.movieCollected = self.movieCollected + 1
                withAnimation{
                    self.isAddToUserList = true
                    self.isShowCustomList = false
                    self.isCreateNewMoiveList = false
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}


enum MovieDetailTabItem : String,CaseIterable {
    case More = "更多資訊"
//    case OnShow = "院線" // new feature
    case Online = "OTT資源" //get netfilx ... etc
    case Similar = "相似電影"
    
    var name : String {
        return self.rawValue
    }
}


struct MovieDetailTab : Identifiable{
    let id : Int
    let tabName : MovieDetailTabItem
}

let movieDetailtabs : [MovieDetailTab] = [
    MovieDetailTab(id: 0, tabName: .More),
    MovieDetailTab(id: 1, tabName: .Online),
    MovieDetailTab(id: 2, tabName: .Similar),
]
struct NewDetailView: View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
//    @EnvironmentObject var movieDetailManager : MovieDetailManager
    
    var movie: Movie
    let movieImages: MovieImages
    @Binding var isShow : Bool
    @Binding var isShowSheet : Bool
    @Binding var isAddToList : Bool
    @Binding var isUserLiked :  Bool
    @Binding var collectedListId : Int
    @Binding var movieLikes : Int
    @Binding var movieCollected : Int
    @Binding var isAddPost : Bool
    
//    @Binding var isUserCollected : Bool
    private let max = UIScreen.main.bounds.height / 2.5
    var topEdge : CGFloat
    
    
    @State private var offset:CGFloat = 0.0
    @State private var isShowIcon : Bool = false
    @State private var tabIndex : MovieDetailTabItem = .More
    @State private var index = 0
    @State private var topOffset : CGFloat = 0
    @State private var isShowMore : Bool = false

    
    @State private var headerHeight : CGFloat = 0.0
    @State private var navHeigh : CGFloat = 0.0
//    @State private var follower : Int = 0
//    @State private var following : Int = 0
    @State private var menuOffset:CGFloat = 0.0
    
    @State private var headerOffset : CGFloat = 0
    @State private var headerMinY : CGFloat = 0
    @State private var height : CGFloat = 0
    @State private var isAllowToScroll = false
    @Namespace var namespace
    
    @StateObject private var movieResourceState = MovieResourceState()
    @StateObject private var recommendState = RecommendState()
    
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        GeometryReader { globalProxy in
            ZStack(alignment:.top){
                ZStack{
                    HStack{
                        Button(action:{
//                            dissmiss()
                            self.isShow = false
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
                    
                    VStack(alignment:.center){
                        Spacer()
                        HStack{
                            WebImage(url: movie.posterURL)
                                .resizable()
                                .indicator(.activity) // Activity Indicator
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30, alignment: .center)
                                .clipShape(Circle())
                            
                            Text(movie.title)
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .transition(.move(edge: .bottom))
                    .offset(y:self.isShowIcon ? 0 : 40)
                    .padding(.horizontal,20)
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
                }
                .background(Color.black.opacity(getOpacity()))
                .zIndex(1)
                
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false){
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
                            ZStack {
                                GeometryReader{ reader -> AnyView in
                                    let frame = reader.frame(in: .global)
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
                                        if isAllowToScroll != newValue {
                                            //                                            print()
                                            isAllowToScroll = newValue
                                        }
                                    }
                                    
                                    //                                    print(frame.minY)
                                    return AnyView(Color.clear)
                                    
                                    
                                }
                                
                                GeometryReader{ proxy  in
                                    ZStack(alignment:.top){
                                        WebImage(url:movie.backdropURL)
                                            .resizable()
                                            .aspectRatio( contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
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
                                            .blur(radius: self.offset / 10)
                                            .zIndex(0)
                                        
                                        
                                        MovieInfo()
                                            .frame(maxWidth:.infinity)
                                            .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                            .zIndex(2)
                                        
                                    }
                                }
                                .frame(height:max)
                                .offset(y:-offset)
                                
                                
                            }
                            
                            Section{
                                //TODO: Need to find the solution
                                tabCellItems()
                                    .frame(height: globalProxy.frame(in: .global).height - 78 - self.headerHeight)
                            } header: {
                                VStack(spacing:0){
                                    MovieDetailTabBar()
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
                        }
                        .modifier(MovieDetailPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
                        .frame(alignment:.top)
                    }
                    .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
                    .zIndex(0)
                }
                
            }
        }
        //
    }

    
    @ViewBuilder
    private func tabCellItems() -> some View{
        GeometryReader{ proxy in
            HStack(spacing:0){
                MoreDetail()
                    .padding(.horizontal,5)
                    .frame(width: UIScreen.main.bounds.width)
                
                MovieOTT(movieTitle: movie.title, isAbleToScroll: $isAllowToScroll)
                    .padding(.horizontal,5)
                    .frame(width: UIScreen.main.bounds.width)
                    .environmentObject(movieResourceState)

                
                GetMoreMovie(movieID: movie.id,isAbleToScroll: $isAllowToScroll)
                    .padding(.horizontal,5)
                    .frame(width: UIScreen.main.bounds.width)
                    .environmentObject(recommendState)

            }
            .offset(x : CGFloat(self.index) * -UIScreen.main.bounds.width)
            .onChange(of: self.index){ index in
                if index == 1 {
                    print("??")
                    if movieResourceState.resource == nil{
                        movieResourceState.fetchMovieResource(query: movie.title)
                    }
                }else if index == 2{
                    if self.recommendState.movies == nil{
                        self.recommendState.RecommendMovies(id: movie.id)
                    }
                }
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width,alignment:.top)
        .gesture(DragGesture().onEnded{ t in
            let cur = t.translation.width
            var curInd = self.index
            print(cur)
            if cur > 50 {
                curInd -= 1
            } else if cur < -50 {
                curInd += 1
            }
            
            curInd = Swift.max(min(curInd,4),0)
            withAnimation(.spring()){
                self.index = curInd
            }
        })
    }
    
    @ViewBuilder
    func MovieInfo() -> some View{
        VStack(alignment:.leading){
            Spacer()
            HStack(alignment:.center){
                WebImage(url: movie.posterURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, alignment: .center)
                    .cornerRadius(10)
//                    .overlay(
//                        circleButton(systemImg: "play.fill",imageScale: .medium ,background: .red, buttonColor: .white,width: 35,height: 35){
//                            //TODO: play trailer!!
//                        }
//                            .shadow(color: .red, radius: 10, x: 0, y: 0)
//                    )

                VStack(alignment:.leading){
                    Text(movie.title)
                        .bold()
                        .font(.system(size: 18))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    VStack(spacing:5){
                        HStack(spacing:5){
                            Text("類型:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            if movie.genres == nil{
                                Text("N/A")
                            }else {
                                VStack(alignment:.trailing,spacing:5){
                                    HStack(spacing:5){
                                        ForEach(0..<(movie.genres!.count < 3 ? movie.genres!.count : 3)){i in
                                            Text(movie.genres![i].name)
                                            if i < ((movie.genres!.count < 3 ? movie.genres!.count : 3) - 1){
                                                Circle()
                                                    .fill(.red)
                                                    .frame(width: 5, height: 5)
                                            }
                                        }
                                    }
                                    
                                    if movie.genres!.count > 3 {
                                        HStack(spacing:5){
                                            ForEach(3..<movie.genres!.count){i in
                                                Text(movie.genres![i].name)
                                                if i < movie.genres!.count - 1 {
                                                    Circle()
                                                        .fill(.red)
                                                        .frame(width: 5, height: 5)
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        .font(.system(size: 14))
                        
                        HStack{
                            Text("上映日期:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            if movie.releaseDate == nil {
                                Text("N/A")
                            }else {
                                Text(movie.releaseDate!)
                            }
                        }
                        .font(.system(size: 14))
                        
                        HStack{
                            Text("片長:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Text(movie.durationText)
                        }
                        .font(.system(size: 14))
                        
                        HStack{
                            Text("語言:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Text(movie.originalLanguage)
                        }
                        .font(.system(size: 14))
                        
                        HStack{
                            Text("均分:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            HStack(spacing:3){
                                if (movie.voteAverage)/2 == 0{
                                    Text("N/A")
                                        .font(.caption)
                                }else{
                                    ForEach(1...5,id:\.self){index in
                                        Image(systemName: "star.fill")
                                            .imageScale(.small)
                                            .foregroundColor(index <= Int(movie.voteAverage)/2 ? .yellow: .gray)
                                    }
                                }
                                
                            }
                        }
                        .font(.system(size: 14))
                        
                        
                    }
                }
                
                Spacer()
            }
            .padding(.bottom)
            
            
            HStack{
                
                BackgroundButton(systemImg: "plus", buttonTitle: "發表文章", backgroundColor: .blue, fontColor: .white){
                    //TODO: JOIN THE GROUP
                    withAnimation{
                        self.isShowSheet.toggle()
                        self.isAddPost.toggle()
                    
                    }
                }
                Spacer()
                
                HStack(spacing:3){
                    circleButton(systemImg:self.isAddToList ? "star.fill" : "star", imageScale: .large,background: .clear , buttonColor: self.isAddToList  ? .yellow : .white,width:40,height:40){
                        //TODO: ADD TO LIST OF REMOVE
                        //                                withAnimation{
                        
                        if isAddToList{
                            //Remove From List
                            withAnimation{
                                self.isAddToList.toggle()
                                self.movieCollected = self.movieCollected - 1
                            }
                            
                            self.RemoveMovieFromList()
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                self.isShowSheet.toggle()
                                userVM.getUserList()
                            }
                        }
                        //                                }
                    }
                    
                    Text(self.movieCollected > 0 ?  self.movieCollected.description : "收藏")
                        .font(.system(size: 14,weight:.semibold))
                }
                
                HStack(spacing:3){
                    circleButton(systemImg: self.isUserLiked ? "heart.fill" : "heart",imageScale: .large, background: .clear , buttonColor: self.isUserLiked ? .red : .white,width:40,height:40){
                        //TODO: ADD TO LIST OF REMOVE
                        //                                print(self.isUserLiked)
                        withAnimation{
                            self.isUserLiked.toggle()
                        }
                        
                        if self.isUserLiked {
                            self.movieLikes = self.movieLikes + 1
                            AddikedMovie()
                        }else {
                            self.movieLikes = self.movieLikes - 1
                            RemoveLikedMovie()
                        }
                        
                    }
                    Text(self.movieLikes > 0 ?  self.movieLikes.description : "點讚")
                        .font(.system(size: 14,weight:.semibold))
                }
                //Share to social page?
                
            }
            .padding(.vertical,5)
            .padding(.horizontal,5)
        }
        .padding(.horizontal)
        
    }
    
    @ViewBuilder
    func MoreDetail() -> some View {
        ScrollView(.vertical){
//            ForEach(0..<50){ i in
//                Text("\(i)")
//            }
            VStack(alignment:.leading,spacing:25){
                //More Detail
                VStack(alignment:.leading,spacing:10){
                    Text("簡介")
                        .font(.system(size: 16,weight: .semibold))

                    //Need to be expand the test

                    if movie.overview.isEmpty {
                        Text("抱歉,沒有相關電影簡介")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))

                    }else {
                        Button(action:{
                            withAnimation{
                                self.isShowMore.toggle()
                            }
                        }){
                            VStack(alignment:.leading,spacing:10){
                                Text(movie.overview)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .lineLimit(self.isShowMore ? nil : 3)
                                    .multilineTextAlignment(.leading)

                                Text(self.isShowMore ? "顯示更少" : "顯示更多")
                                    .foregroundColor(Color(uiColor: UIColor.white))
                                    .font(.system(size: 12))
                            }
                        }
                    }

                }


                if self.movie.credits != nil && self.movie.credits!.cast.count > 0{
                    VStack(alignment:.leading,spacing:10){
                        HStack{
                            Text("演員")
                                .font(.system(size: 16,weight: .semibold))

                            Spacer()
                        }


                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack{
                                ForEach(0..<(self.movie.credits!.cast.count < 10 ? self.movie.credits!.cast.count :10 ),id:\.self){i in
                                    if self.movie.credits!.cast[i].profilePath != nil{
                                        VStack(alignment:.center){
                                            WebImage(url: self.movie.credits!.cast[i].posterURL)
                                                .resizable()
                                                .indicator(.activity) // Activity Indicator
                                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80)
                                                .cornerRadius(8)

                                            Text(self.movie.credits!.cast[i].name)
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .frame(width:120)
                                                .lineLimit(1)

                                            Text(self.movie.credits!.cast[i].character)
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                                .frame(width:120)
                                                .lineLimit(1)
                                        }

                                    }
                                }
                            }


                        }
                      


                    }
                }

                if self.movie.credits != nil && self.movie.credits!.crew.count > 0{
                    VStack(alignment:.leading,spacing:10){
                        HStack{
                            Text("團隊")
                                .font(.system(size: 16,weight: .semibold))

                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack{
                                ForEach(0..<(self.movie.credits!.crew.count < 10 ? self.movie.credits!.crew.count :10 ),id:\.self){i in
                                    if self.movie.credits!.crew[i].profilePath != nil{
                                        VStack(alignment:.center){
                                            WebImage(url: self.movie.credits!.crew[i].posterURL)
                                                .resizable()
                                                .indicator(.activity) // Activity Indicator
                                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80)
                                                .cornerRadius(8)

                                            Text(self.movie.credits!.crew[i].name)
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .frame(width:120)
                                                .lineLimit(1)

                                            Text(self.movie.credits!.crew[i].job)
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                                .frame(width:120)
                                                .lineLimit(1)
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
//
                VStack(alignment:.leading,spacing:10){
                    HStack{
                        Text("劇情")
                            .font(.system(size: 16,weight: .semibold))
                        Spacer()
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(){
                            ForEach(0..<(self.movieImages.backdrops.count < 20 ? self.movieImages.backdrops.count : 20),id:\.self){ i in
                                WebImage(url: self.movieImages.backdrops[i].MovieImageURL)
                                    .resizable()
                                    .indicator(.activity) // Activity Indicator
                                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                                    .frame(width: UIScreen.main.bounds.width / 1.2)
                            }
                            
                            
                        }
                        
                    }
                }
//
                VStack(alignment:.leading, spacing:8) {
                    if movie.videos != nil && movie.videos!.results.count > 0 {
                        HStack{
                            Text("宣傳片")
                                .font(.system(size: 16,weight: .semibold))
                            Spacer()
                        }

                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing:10){
                                ForEach(0..<(self.movie.videos!.results.count < 10 ? self.movie.videos!.results.count : 10),id:\.self) { i in
                                    YoutubeView(video_id: self.movie.videos!.results[i].key)
                                        .frame(width:UIScreen.main.bounds.width - 20,height:UIScreen.main.bounds.height * 0.3)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .padding(5)
        }
        .introspectScrollView{scroll in
            scroll.isScrollEnabled = self.isAllowToScroll
        }
        
    }
    
    @ViewBuilder
    func circleButton(systemImg: String,imageScale:Image.Scale,background:Color,buttonColor : Color,width:CGFloat,height:CGFloat,action: @escaping ()->()) -> some View{
        Button(action: action){
            ZStack(alignment:.center){
                Circle()
                    .fill(background)
                    .frame(width: width, height: height)
                
                Image(systemName: systemImg)
                    .imageScale(imageScale)
                    .foregroundColor(buttonColor)
            }
        }
        
    }

    @ViewBuilder
    func BackgroundButton(systemImg: String,buttonTitle: String,backgroundColor:Color,fontColor : Color,action: @escaping ()->()) -> some View{
        Button(action:action){
            HStack(spacing:5){
                Image(systemName: systemImg)
                    .imageScale(.medium)
                Text(buttonTitle)
                    .font(.system(size:16,weight:.semibold))
            }
            .padding(.horizontal,5)
            .foregroundColor(fontColor)
            .frame(height: 40)
            .cornerRadius(10)
            .background(backgroundColor            .cornerRadius(10))
        }
        .padding(.horizontal,5)

    }
    
    @ViewBuilder
    func MovieDetailTabBar() -> some View {
        HStack(spacing:10){
            ForEach(movieDetailtabs,id:\.id){ tab in
                VStack(spacing:12){
                    Text(tab.tabName.name)
                        .fontWeight(.semibold)
                        .foregroundColor(index == tab.id ? .white : .gray)
                    
                    ZStack{
                        if index == tab.id {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.white)
                                .matchedGeometryEffect(id: "TAB", in: namespace)
                        } else {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.clear)
                        }
                    }
                    .padding(.horizontal,8)
                    .frame(height: 4)
                }
                .contentShape(Rectangle())
                .onTapGesture(){
                    withAnimation(.easeInOut){
//                        tabIndex = tab
                        index = tab.id
                        
                    }
                }
            }
        }
        .frame(height:50,alignment: .bottom)
        .padding(.bottom,5)
        .background(Color.black)
    }

    private func getHeaderHigth() -> CGFloat {
        //setting the height of the header
        
        let top = max + offset
        //constrain is set to 80 now
        // < 60 + topEdge not at the top yet
        return top > (40 + topEdge) ? top : 40 + topEdge
    }
    
    private func getOpacity() -> CGFloat {
        let progress = -(offset + 40 ) / 70
        return -offset > 40  ?  progress : 0
    }
    
    private func AddikedMovie(){
        let req = NewUserLikeMoviedReq(movie_id: self.movie.id)
        APIService.shared.PostLikedMovie(req: req){(result ) in
            switch result {
            case .success(_):
                print("LIKED MOVIE")
                
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isUserLiked.toggle()
                    self.movieLikes  = self.movieLikes - 1
                }
//                HubState.AlertMessage(sysImg: "xamrk.circle.fill", message: err.localizedDescription)
            }
        }
    }
    
    private func RemoveLikedMovie() {
        let req = DeleteUserLikedMovie(movie_id: self.movie.id)
        APIService.shared.DeleteLikedMovie(req: req){ (result ) in
            switch result {
            case .success(_):
                print("UNLIKED MOVIE")
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isUserLiked.toggle()
                    self.movieLikes =  self.movieLikes + 1
                }
            }
        }
    }
    
    private func RemoveMovieFromList(){
        if self.collectedListId == 0 {return}
        
        let req = RemoveMovieFromListReq(list_id: self.collectedListId, movie_id: self.movie.id)
        APIService.shared.RemoveMovieFromList(req: req){ result in
            switch result {
            case .success(_):
                print("Removed movie from list")
            case .failure(let err):
                print(err.localizedDescription)
                withAnimation{
                    self.isAddToList.toggle()
                    self.movieCollected = self.movieCollected + 1
                }
            }
        }
    }
    
}

//struct NewDetailView: View {
//    @EnvironmentObject var postVM : PostVM
//    @EnvironmentObject var userVM : UserViewModel
////    @EnvironmentObject var movieDetailManager : MovieDetailManager
//
//    var movie: Movie
//    let movieImages: MovieImages
//    @Binding var isShow : Bool
//    @Binding var isShowSheet : Bool
//    @Binding var isAddToList : Bool
//    @Binding var isUserLiked :  Bool
//    @Binding var collectedListId : Int
//    @Binding var movieLikes : Int
//    @Binding var movieCollected : Int
//    @Binding var isAddPost : Bool
//
////    @Binding var isUserCollected : Bool
//    private let max = UIScreen.main.bounds.height / 2.5
//    var topEdge : CGFloat
//
//
//    @State private var offset:CGFloat = 0.0
//    @State private var isShowIcon : Bool = false
//    @State private var tabIndex : MovieDetailTabItem = .More
//    @State private var topOffset : CGFloat = 0
//    @State private var isShowMore : Bool = false
//
//
//
//    @Namespace var namespace
//
//    @Environment(\.dismiss) private var dissmiss
//    var body: some View {
//        ZStack(alignment:.top){
//            ZStack{
//                HStack{
//                    Button(action:{
//                        dissmiss()
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
//                VStack(alignment:.center){
//                    Spacer()
//                    HStack{
//                        WebImage(url: movie.posterURL)
//                            .resizable()
//                            .indicator(.activity) // Activity Indicator
//                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .clipShape(Circle())
//
//                        Text(movie.title)
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                .transition(.move(edge: .bottom))
//                .offset(y:self.isShowIcon ? 0 : 40)
//                .padding(.horizontal,20)
//                .frame(width:UIScreen.main.bounds.width ,height: topEdge)
//                .padding(.top,30)
//                .zIndex(10)
//                .clipped()
//            }
//            .background(Color.black.opacity(getOpacity()))
//            .zIndex(1)
//            .overlay(
//                GeometryReader{ proxy -> Color in
//                    let maxY = proxy.frame(in: .global).maxY
//                    DispatchQueue.main.async {
//                        if topOffset == 0{
//                            topOffset = maxY
//                        }
//                    }
//                    return Color.clear
//                }
//            )
//
//
//
//            GeometryReader { proxy in
//                ScrollView(showsIndicators: false){
//                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
//                        GeometryReader{ proxy  in
//                            ZStack(alignment:.top){
//                                WebImage(url:movie.backdropURL)
//                                    .resizable()
//                                    .aspectRatio( contentMode: .fill)
//                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
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
//                                    .blur(radius: self.offset / 10)
//                                    .zIndex(0)
//
//
//                                MovieInfo()
//                                    .frame(maxWidth:.infinity)
//                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
//                                    .zIndex(1)
//
//                            }
//                        }
//                        .frame(height:max)
//                        .offset(y:-offset)
//
//
//                        HStack{
//
//                            BackgroundButton(systemImg: "plus", buttonTitle: "發表文章", backgroundColor: .blue, fontColor: .white){
//                                //TODO: JOIN THE GROUP
//                                withAnimation{
//                                    self.isShowSheet.toggle()
//                                    self.isAddPost.toggle()
//
//                                }
//                            }
//                            Spacer()
//
//                            HStack(spacing:3){
//                                circleButton(systemImg:self.isAddToList ? "star.fill" : "star", imageScale: .large,background: .clear , buttonColor: self.isAddToList  ? .yellow : .white,width:40,height:40){
//                                    //TODO: ADD TO LIST OF REMOVE
//                                    //                                withAnimation{
//
//                                    if isAddToList{
//                                        //Remove From List
//                                        withAnimation{
//                                            self.isAddToList.toggle()
//                                            self.movieCollected = self.movieCollected - 1
//                                        }
//
//                                        self.RemoveMovieFromList()
//                                    } else {
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                                            self.isShowSheet.toggle()
//                                            userVM.getUserList()
//                                        }
//                                    }
//                                    //                                }
//                                }
//
//                                Text(self.movieCollected > 0 ?  self.movieCollected.description : "收藏")
//                                    .font(.system(size: 14,weight:.semibold))
//                            }
//
//                            HStack(spacing:3){
//                                circleButton(systemImg: self.isUserLiked ? "heart.fill" : "heart",imageScale: .large, background: .clear , buttonColor: self.isUserLiked ? .red : .white,width:40,height:40){
//                                    //TODO: ADD TO LIST OF REMOVE
//                                    //                                print(self.isUserLiked)
//                                    withAnimation{
//                                        self.isUserLiked.toggle()
//                                    }
//
//                                    if self.isUserLiked {
//                                        self.movieLikes = self.movieLikes + 1
//                                        AddikedMovie()
//                                    }else {
//                                        self.movieLikes = self.movieLikes - 1
//                                        RemoveLikedMovie()
//                                    }
//
//                                }
//                                Text(self.movieLikes > 0 ?  self.movieLikes.description : "點讚")
//                                    .font(.system(size: 14,weight:.semibold))
//                            }
//                            //Share to social page?
//
//                        }
//                        .padding(.vertical,5)
//                        .padding(.horizontal,5)
//
//                        Section{
//                            //TODO: Need to find the solution
//                            switch tabIndex {
//                            case .More:
//                                MoreDetail()
//                                    .padding(.horizontal,5)
//
//                            case .Online:
//                                MovieOTT(movieTitle: movie.title)
//                                    .padding(.horizontal,5)
//                            case .Similar:
//                                GetMoreMovie(movieID: movie.id)
//                                    .padding(.horizontal,5)
//                            }
//                        } header: {
//
//                            GeometryReader {geo -> AnyView in
//                                let minY = geo.frame(in: .global).minY
//                                let offset  = minY - self.topOffset
//                                return AnyView(
//                                    VStack(spacing:0){
//                                        MovieDetailTabBar()
//                                        Divider()
//                                            .background(.gray)
//                                    }
//                                        .frame(height: 60,alignment: .bottom)
//                                        .background(Color.black.edgesIgnoringSafeArea(.all))
//                                        .offset(y : offset < 0 ? -offset : 0)
//                                )
//                            } .frame(height: 60)
//                        }
//                    }
//                    .modifier(MovieDetailPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
//                    .frame(alignment:.top)
//                }
//                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
//                .zIndex(0)
////                .background(Color("appleDark"))
//            }
//
//        }
////
//    }
//
//    @ViewBuilder
//    func MovieInfo() -> some View{
//        VStack(alignment:.leading){
//            Spacer()
//            HStack(alignment:.center){
//                WebImage(url: movie.posterURL)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 120, alignment: .center)
//                    .cornerRadius(10)
////                    .overlay(
////                        circleButton(systemImg: "play.fill",imageScale: .medium ,background: .red, buttonColor: .white,width: 35,height: 35){
////                            //TODO: play trailer!!
////                        }
////                            .shadow(color: .red, radius: 10, x: 0, y: 0)
////                    )
//
//                VStack(alignment:.leading){
//                    Text(movie.title)
//                        .bold()
//                        .font(.system(size: 18))
//                        .lineLimit(3)
//                        .multilineTextAlignment(.leading)
//
//                    VStack(spacing:5){
//                        HStack(spacing:5){
//                            Text("類型:")
//                                .foregroundColor(.gray)
//                            Spacer()
//
//                            if movie.genres == nil{
//                                Text("N/A")
//                            }else {
//                                VStack(alignment:.trailing,spacing:5){
//                                    HStack(spacing:5){
//                                        ForEach(0..<(movie.genres!.count < 3 ? movie.genres!.count : 3)){i in
//                                            Text(movie.genres![i].name)
//                                            if i < ((movie.genres!.count < 3 ? movie.genres!.count : 3) - 1){
//                                                Circle()
//                                                    .fill(.red)
//                                                    .frame(width: 5, height: 5)
//                                            }
//                                        }
//                                    }
//
//                                    if movie.genres!.count > 3 {
//                                        HStack(spacing:5){
//                                            ForEach(3..<movie.genres!.count){i in
//                                                Text(movie.genres![i].name)
//                                                if i < movie.genres!.count - 1 {
//                                                    Circle()
//                                                        .fill(.red)
//                                                        .frame(width: 5, height: 5)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//
//                            }
//                        }
//                        .font(.system(size: 14))
//
//                        HStack{
//                            Text("上映日期:")
//                                .foregroundColor(.gray)
//                            Spacer()
//
//                            if movie.releaseDate == nil {
//                                Text("N/A")
//                            }else {
//                                Text(movie.releaseDate!)
//                            }
//                        }
//                        .font(.system(size: 14))
//
//                        HStack{
//                            Text("片長:")
//                                .foregroundColor(.gray)
//                            Spacer()
//
//                            Text(movie.durationText)
//                        }
//                        .font(.system(size: 14))
//
//                        HStack{
//                            Text("語言:")
//                                .foregroundColor(.gray)
//                            Spacer()
//
//                            Text(movie.originalLanguage)
//                        }
//                        .font(.system(size: 14))
//
//                        HStack{
//                            Text("均分:")
//                                .foregroundColor(.gray)
//                            Spacer()
//
//                            HStack(spacing:3){
//                                if (movie.voteAverage)/2 == 0{
//                                    Text("N/A")
//                                        .font(.caption)
//                                }else{
//                                    ForEach(1...5,id:\.self){index in
//                                        Image(systemName: "star.fill")
//                                            .imageScale(.small)
//                                            .foregroundColor(index <= Int(movie.voteAverage)/2 ? .yellow: .gray)
//                                    }
//                                }
//
//                            }
//                        }
//                        .font(.system(size: 14))
//
//
//                    }
//                }
//
//                Spacer()
//            }
//            .padding(.bottom)
//        }
//        .padding(.horizontal)
//
//    }
//
//    @ViewBuilder
//    func MoreDetail() -> some View {
//        VStack(alignment:.leading,spacing:25){
//            //More Detail
//            VStack(alignment:.leading,spacing:10){
//                Text("簡介")
//                    .font(.system(size: 16,weight: .semibold))
//
//                //Need to be expand the test
//
//                if movie.overview.isEmpty {
//                    Text("抱歉,沒有相關電影簡介")
//                        .foregroundColor(.gray)
//                        .font(.system(size: 14))
//
//                }else {
//                    Button(action:{
//                        withAnimation{
//                            self.isShowMore.toggle()
//                        }
//                    }){
//                        VStack(alignment:.leading,spacing:10){
//                            Text(movie.overview)
//                                .foregroundColor(.gray)
//                                .font(.system(size: 14))
//                                .lineLimit(self.isShowMore ? nil : 3)
//                                .multilineTextAlignment(.leading)
//
//                            Text(self.isShowMore ? "顯示更少" : "顯示更多")
//                                .foregroundColor(Color(uiColor: UIColor.white))
//                                .font(.system(size: 12))
//                        }
//                    }
//                }
//
//            }
//
//
//            if self.movie.credits != nil && self.movie.credits!.cast.count > 0{
//                VStack(alignment:.leading,spacing:10){
//                    HStack{
//                        Text("演員")
//                            .font(.system(size: 16,weight: .semibold))
//
//                        Spacer()
////                        Button(action:{
////
////                        }){
////                            Text("顯示更多")
////                                .font(.system(size: 14,weight: .semibold))
////                                .foregroundColor(Color(uiColor: UIColor.darkGray))
////                        }
//                    }
//
//
//                    ScrollView(.horizontal, showsIndicators: false){
//                        LazyHStack{
//                            ForEach(0..<(self.movie.credits!.cast.count < 10 ? self.movie.credits!.cast.count :10 )){i in
//                                if self.movie.credits!.cast[i].profilePath != nil{
//                                    VStack(alignment:.center){
//                                        WebImage(url: self.movie.credits!.cast[i].posterURL)
//                                            .resizable()
//                                            .indicator(.activity) // Activity Indicator
//                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 80)
//                                            .cornerRadius(10)
//
//                                        Text(self.movie.credits!.cast[i].name)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                            .frame(width:120)
//                                            .lineLimit(1)
//
//                                        Text(self.movie.credits!.cast[i].character)
//                                            .foregroundColor(.gray)
//                                            .font(.caption)
//                                            .frame(width:120)
//                                            .lineLimit(1)
//                                    }
//
//                                }
//                            }
//                        }
//
//
//                    }
//
//
//                }
//            }
//
//            if self.movie.credits != nil && self.movie.credits!.crew.count > 0{
//                VStack(alignment:.leading,spacing:10){
//                    HStack{
//                        Text("團隊")
//                            .font(.system(size: 16,weight: .semibold))
//
//                        Spacer()
////                        Button(action:{
////
////                        }){
////                            Text("顯示更多")
////                                .font(.system(size: 14,weight: .semibold))
////                                .foregroundColor(Color(uiColor: UIColor.darkGray))
////                        }
//                    }
//
//
//                    ScrollView(.horizontal, showsIndicators: false){
//                        LazyHStack{
//                            ForEach(0..<(self.movie.credits!.crew.count < 10 ? self.movie.credits!.crew.count :10 )){i in
//                                if self.movie.credits!.crew[i].profilePath != nil{
//                                    VStack(alignment:.center){
//                                        WebImage(url: self.movie.credits!.crew[i].posterURL)
//                                            .resizable()
//                                            .indicator(.activity) // Activity Indicator
//                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 80)
//                                            .cornerRadius(10)
//
//                                        Text(self.movie.credits!.crew[i].name)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                            .frame(width:120)
//                                            .lineLimit(1)
//
//                                        Text(self.movie.credits!.crew[i].job)
//                                            .foregroundColor(.gray)
//                                            .font(.caption)
//                                            .frame(width:120)
//                                            .lineLimit(1)
//                                    }
//
//                                }
//                            }
//                        }
//
//
//                    }
//
//
//                }
//            }
//
//            VStack(alignment:.leading,spacing:10){
//                HStack{
//                    Text("劇情")
//                        .font(.system(size: 16,weight: .semibold))
//                    Spacer()
////                    Button(action:{
////
////                    }){
////                        Text("顯示更多")
////                            .font(.system(size: 14,weight: .semibold))
////                            .foregroundColor(Color(uiColor: UIColor.darkGray))
////                    }
//                }
//
//
//                ScrollView(.horizontal, showsIndicators: false){
//                    LazyHStack(){
//                        ForEach(0..<(self.movieImages.backdrops.count < 20 ? self.movieImages.backdrops.count : 20)){ i in
//                            WebImage(url: self.movieImages.backdrops[i].MovieImageURL)
//                                .resizable()
//                                .indicator(.activity) // Activity Indicator
//                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                                .aspectRatio(contentMode: .fit)
//                                .cornerRadius(5)
//                        }
//
//
//                    }
//
//                }.frame(height: 150)
//            }
//
//            VStack(alignment:.leading, spacing:8) {
//                if movie.videos != nil && movie.videos!.results.count > 0 {
//                    HStack{
//                        Text("宣傳片")
//                            .font(.system(size: 16,weight: .semibold))
//                        Spacer()
////
////                        if self.movie.videos!.results.count >= 10 {
////                            Button(action:{
////                                //TODO: Load More Video
////                            }){
////                                Text("顯示更多")
////                                    .font(.system(size: 14,weight: .semibold))
////                                    .foregroundColor(Color(uiColor: UIColor.darkGray))
////                            }
////                        }
//                    }
//
//                    ScrollView(.horizontal, showsIndicators: false){
//                        HStack(spacing:10){
//                            ForEach(0..<(self.movie.videos!.results.count < 10 ? self.movie.videos!.results.count : 10)) { i in
//                                YoutubeView(video_id: self.movie.videos!.results[i].key)
//                                    .frame(width:UIScreen.main.bounds.width - 20,height:UIScreen.main.bounds.height * 0.3)
//                                    .cornerRadius(10)
////                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .padding(5)
//    }
//
//    @ViewBuilder
//    func circleButton(systemImg: String,imageScale:Image.Scale,background:Color,buttonColor : Color,width:CGFloat,height:CGFloat,action: @escaping ()->()) -> some View{
//        Button(action: action){
//            ZStack(alignment:.center){
//                Circle()
//                    .fill(background)
//                    .frame(width: width, height: height)
//
//                Image(systemName: systemImg)
//                    .imageScale(imageScale)
//                    .foregroundColor(buttonColor)
//            }
//        }
//
//    }
//
//    @ViewBuilder
//    func BackgroundButton(systemImg: String,buttonTitle: String,backgroundColor:Color,fontColor : Color,action: @escaping ()->()) -> some View{
//        Button(action:action){
//            HStack(spacing:5){
//                Image(systemName: systemImg)
//                    .imageScale(.medium)
//                Text(buttonTitle)
//                    .font(.system(size:16,weight:.semibold))
//            }
//            .padding(.horizontal,5)
//            .foregroundColor(fontColor)
//            .frame(height: 40)
//            .cornerRadius(10)
//            .background(backgroundColor            .cornerRadius(10))
//        }
//        .padding(.horizontal,5)
//
//    }
//
//    @ViewBuilder
//    func MovieDetailTabBar() -> some View {
//        HStack(spacing:10){
//            ForEach(MovieDetailTabItem.allCases,id:\.self){ tab in
//                VStack(spacing:12){
//                    Text(tab.rawValue)
//                        .fontWeight(.semibold)
//                        .foregroundColor(tabIndex == tab ? .white : .gray)
//
//                    ZStack{
//                        if tabIndex == tab {
//                            RoundedRectangle(cornerRadius: 4, style: .continuous)
//                                .fill(.white)
//                                .matchedGeometryEffect(id: "TAB", in: namespace)
//                        } else {
//                            RoundedRectangle(cornerRadius: 4, style: .continuous)
//                                .fill(.clear)
//                        }
//                    }
//                    .padding(.horizontal,8)
//                    .frame(height: 4)
//                }
//                .contentShape(Rectangle())
//                .onTapGesture(){
//                    withAnimation(.easeInOut){
//                        tabIndex = tab
//                    }
//                }
//            }
//        }
//        .padding(.horizontal)
////        .padding(.top,25)
//        .padding(.bottom,5)
//    }
//
//    private func getHeaderHigth() -> CGFloat {
//        //setting the height of the header
//
//        let top = max + offset
//        //constrain is set to 80 now
//        // < 60 + topEdge not at the top yet
//        return top > (40 + topEdge) ? top : 40 + topEdge
//    }
//
//    private func getOpacity() -> CGFloat {
//        let progress = -(offset + 40 ) / 70
//        return -offset > 40  ?  progress : 0
//    }
//
//    private func AddikedMovie(){
//        let req = NewUserLikeMoviedReq(movie_id: self.movie.id)
//        APIService.shared.PostLikedMovie(req: req){(result ) in
//            switch result {
//            case .success(_):
//                print("LIKED MOVIE")
//
//            case .failure(let err):
//                print(err.localizedDescription)
//                withAnimation{
//                    self.isUserLiked.toggle()
//                    self.movieLikes  = self.movieLikes - 1
//                }
////                HubState.AlertMessage(sysImg: "xamrk.circle.fill", message: err.localizedDescription)
//            }
//        }
//    }
//
//    private func RemoveLikedMovie() {
//        let req = DeleteUserLikedMovie(movie_id: self.movie.id)
//        APIService.shared.DeleteLikedMovie(req: req){ (result ) in
//            switch result {
//            case .success(_):
//                print("UNLIKED MOVIE")
//            case .failure(let err):
//                print(err.localizedDescription)
//                withAnimation{
//                    self.isUserLiked.toggle()
//                    self.movieLikes =  self.movieLikes + 1
//                }
//            }
//        }
//    }
//
//    private func RemoveMovieFromList(){
//        if self.collectedListId == 0 {return}
//
//        let req = RemoveMovieFromListReq(list_id: self.collectedListId, movie_id: self.movie.id)
//        APIService.shared.RemoveMovieFromList(req: req){ result in
//            switch result {
//            case .success(_):
//                print("Removed movie from list")
//            case .failure(let err):
//                print(err.localizedDescription)
//                withAnimation{
//                    self.isAddToList.toggle()
//                    self.movieCollected = self.movieCollected + 1
//                }
//            }
//        }
//    }
//
//}
