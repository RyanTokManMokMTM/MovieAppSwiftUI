//
//  WebImage.swift
//  IOS_DEV
//
//  Created by Jackson on 18/4/2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct MovieDetailView: View {

    let movieId: Int
    @State private var todo : Bool = false
    @StateObject private var movieDetailState = MovieDetailState()
    @StateObject private var listController = ListController()
    @StateObject private var favoriteController = FavoriteController()
    @State var isMyFavorite = false
    @Binding var navBarHidden:Bool
    @Binding var isAction : Bool
    @Binding var isLoading : Bool

    var body: some View {
        ZStack {

            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            
            if movieDetailState.movie != nil{
                MovieDetailPage(movie: movieDetailState.movie! , navBarHidden: $navBarHidden, isAction: $isAction, isLoading: $isLoading,myMovieList:listController.mylistData, isMyFavorite:isMyFavorite)
                
            }
        }
        .onAppear {
            //TODO : Ignore it now......
            self.movieDetailState.loadMovie(id: self.movieId)
//            self.listController.GetMyList(userID: NowUserID!)
//            self.favoriteController.CheckLikeMovie(movieID: movieId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if !self.favoriteController.favorite.isEmpty {
                    self.isMyFavorite = true
                }
                self.todo = true
            })
    
        }
    }
}




//struct GetMyMovieList: View {
//    @ObservedObject private var listController = ListController()
//    @State var NowUser:Me?
//    @Binding var navBarHidden:Bool
//    @Binding var isAction : Bool
//    @Binding var isLoading : Bool
//    @State var movie : Movie
//
//    var body: some View {
//        ZStack {
//
//
//
//
//        }
//        .onAppear {
//            self.listController.GetMyList(userID: (NowUser?.id)!)
//
//        }
//    }
//}



struct movieImage:View{
    let imgURL: URL
    var body : some View{
        WebImage(url:imgURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.init("navBarBlack").opacity(0.0),Color.init("navBarBlack").opacity(0.95)]), startPoint:.top, endPoint: .bottom)


            )
            .background(Color.black.edgesIgnoringSafeArea(.all))

    }
}



struct MovieDetailPage: View {
    
    @State var movie : Movie
    //MOVIE URL
    @State private var size = 0.0
    @State private var opacity = 0.0
    @State private var showMovieName = false
    @State private var showAnimation = false
    @Binding var navBarHidden:Bool
    @Binding var isAction : Bool
    @Binding var isLoading : Bool
    @State private var isAppear:Bool = false
    @State var myMovieList : [CustomList]
    @State var isMyFavorite:Bool

    var body: some View {
        
        
        ZStack(alignment:Alignment(horizontal: .center, vertical: .top)){
            
            ScrollView(.vertical, showsIndicators: false){
                GeometryReader{ proxy in
                    if proxy.frame(in:.global).minY > -480{
                        movieImage(imgURL: movie.posterURL)
                            .offset(y:-proxy.frame(in:.global).minY)
                            .frame(width: isAppear ?  0: proxy.frame(in:.global).maxX, height:
                                   isAppear ? 0 :proxy.frame(in:.global).minY  > 0 ?
                                    proxy.frame(in:.global).minY + 480 : 480   )
                            
                            .opacity((Double(proxy.frame(in:.global).minY * 0.0045 + 1)) < 0.45 ? 0.45 :(Double(proxy.frame(in:.global).minY * 0.0045 + 1)))
                            .blur(radius: CGFloat((Double(proxy.frame(in:.global).minY * 0.005 + 1)) < 0.45  ? (Double(proxy.frame(in:.global).minY) * -1 * 0.03) : 0))
                        
                    }
                }
                .frame(height: 510)
                //.frame(height:480 - 150)
                .animation(.spring(),value:showAnimation)
                //                        Detail Items
                
               
               
                MovieInfoDetail(myMovieList:myMovieList , movie: movie, isMyFavorite:isMyFavorite)
                    .padding([.bottom],UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    
                //     .offset(y:10)
                //   .background(Color.black.edgesIgnoringSafeArea(.all))
                
                
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
            .background(Color.init("navBarBlack").edgesIgnoringSafeArea(.all))
        }
        .edgesIgnoringSafeArea(.all)
        .frame(height:UIScreen.main.bounds.height)
        .navigationTitle(self.isAction ?  movie.title : "")
        .navigationBarTitle(self.isAction ?  movie.title  : "")
        .navigationBarItems(trailing:showBarItem(imgURL: movie.posterURL, name:movie.title).opacity(showMovieName ? 1 : 0).animation(.linear).transition(.flipFromBottom))
        .padding(.horizontal,10)
        .onAppear{
            isAppear = false
            loading()
            print(self.movie)
//            withAnimation(){
//                self.navBarHidden = false
//            }
//            UIScrollView.appearance().bounces = true
            
        }
        .onDisappear{
//            withAnimation(){
//                self.navBarHidden = true
//            }
            self.isLoading = true
//            UIScrollView.appearance().bounces = false
        }
        
        
    }
    
    func loading(){
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.25){
            self.isLoading = false
        }
    }
}




struct TestDetailView: View {

    let movieId: Int
    @StateObject private var movieDetailState = MovieDetailState()
    @StateObject private var movieImagesState = MovieImagesState()
    var body: some View {
        ZStack {

            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            
            if movieDetailState.movie != nil && self.movieImagesState.movieImage != nil{
                GeometryReader{ proxy in
                    NewDetailView(movie: self.movieDetailState.movie!,movieImages: self.movieImagesState.movieImage! ,topEdge: proxy.safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                }
            }
        }
        .onAppear {
            //TODO : Ignore it now......
            self.movieDetailState.loadMovie(id: self.movieId)
            self.movieImagesState.loadMovieImage(id: self.movieId)
        }
    }
}

enum MovieDetailTabItem : String,CaseIterable {
    case More = "更多資訊"
    case OnShow = "院線" // new feature
    case Online = "OTT資源" //get netfilx ... etc
    case Similar = "相似電影"
}

struct NewDetailView: View {
    var movie: Movie
    let movieImages: MovieImages
    private let max = UIScreen.main.bounds.height / 2.5
    var topEdge : CGFloat
    @State private var offset:CGFloat = 0.0
    @State private var menuOffset:CGFloat = 0.0
    @State private var isShowIcon : Bool = false
    @State private var tabBarOffset = UIScreen.main.bounds.width
    @State private var tabOffset : CGFloat = 0.0
    @State private var tabIndex : MovieDetailTabItem = .More
    @State private var topOffset : CGFloat = 0
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment:.top){
            ZStack{
                VStack(alignment:.center){
                    Spacer()
                    HStack{
                        WebImage(url: movie.posterURL)
                            .resizable()
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
            }
            .background(Color("ResultCardBlack"))
            .zIndex(1)
            .overlay(
                GeometryReader{ proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    DispatchQueue.main.async {
                        if topOffset == 0{
                            topOffset = minY
                        }
                    }
                    return Color.clear
                }
            )
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
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
                                    )
                                    .blur(radius: self.offset / 10)
                                    .zIndex(0)
                                
                                
                                MovieInfo()
                                    .frame(maxWidth:.infinity)
                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                    .zIndex(1)
                                
                            }
                        }
                        .frame(height:max)
                        .offset(y:-offset)
                    
                        
                        HStack{
                            
                            fullButton(systemImg: "plus", buttonTitle: "加入討論區", backgroundColor: .blue, fontColor: .white){
                                //TODO: JOIN THE GROUP
                            }
                            Spacer()
                            circleButton(systemImg: "bookmark.fill", background: .yellow , buttonColor: .white,width:40,height:40){
                                //TODO: ADD TO LIST OF REMOVE
                            }
                            circleButton(systemImg: "heart.fill", background: .red , buttonColor: .white,width:40,height:40){
                                //TODO: ADD TO LIST OF REMOVE
                            }
                            
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,5)
                        
                        //SrcollTabBar
                        /*
                         1.More Detail View
                         2.
                         */
                        Section{
                            switch tabIndex {
                            case .More:
                                MoreDetail()
                                  
                            case .OnShow:
                                VStack{
                                    Text("SERVICE NOT AVAILABLE YET...")
                                }
                            case .Online:
                                MovieOTT(movieTitle: movie.title)
                            case .Similar:
                                GetMoreMovie(movieID: movie.id)
                            }
                        } header: {
                            Group{
                                GeometryReader {geo -> AnyView in
                                    let minY = geo.frame(in: .global).minY
                                    print("\(self.topOffset): \(minY)")
                                    return AnyView(
                                        VStack{
                                            MovieDetailTabBar()
                                            Divider()
                                                .background(.gray)
                                        }
                                    )
                                }
                            }
//                            .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
//                            .overlay(
//                                    GeometryReader{proxy -> Color in
//                                        let minY = proxy.frame(in: .global).minY
//                                        print(minY)
//                                        DispatchQueue.main.async {
//                                            self.menuOffset = minY
//                                        }
//                                        return Color.clear
//                                    }.frame(width: 0, height: 0)
//                                )
                            
                        }
                        
    
                    }
                    .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
                    .frame(alignment:.top)
                }
                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
                .zIndex(0)
//                .background(Color("appleDark"))
            }
        }
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
                    .overlay(
                        circleButton(systemImg: "play.fill", background: .red, buttonColor: .white,width: 35,height: 35){
                            //TODO: play trailer!!
                        }
                            .shadow(color: .red, radius: 10, x: 0, y: 0)
                    )

                VStack(alignment:.leading){
                    Text(movie.title)
                        .bold()
                        .font(.system(size: 18))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    VStack(spacing:5){
                        HStack{
                            Text("類型:")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            if movie.genres == nil{
                                Text("N/A")
                            }else {
                                ForEach(0..<movie.genres!.count){i in
                                    Text(movie.genres![i].name)
                                    if i < movie.genres!.count - 1 {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 5, height: 5)
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
        }
        .padding(.horizontal)
        
    }
    
    @ViewBuilder
    func MoreDetail() -> some View {
        VStack(alignment:.leading,spacing:25){
            //More Detail
            VStack(alignment:.leading,spacing:10){
                Text("概況")
                    .font(.system(size: 16,weight: .semibold))
                Text(movie.overview)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            
            
            if self.movie.credits != nil && self.movie.credits!.cast.count > 0{
                VStack(alignment:.leading,spacing:10){
                    HStack{
                        Text("演員")
                            .font(.system(size: 16,weight: .semibold))
                        
                        Spacer()
                        Button(action:{
                            
                        }){
                            Text("顯示更多")
                                .font(.system(size: 14,weight: .semibold))
                                .foregroundColor(Color(uiColor: UIColor.darkGray))
                        }
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack{
                            ForEach(0..<(self.movie.credits!.cast.count < 10 ? self.movie.credits!.cast.count :10 )){i in
                                if self.movie.credits!.cast[i].profilePath != nil{
                                    VStack(alignment:.center){
                                        WebImage(url: self.movie.credits!.cast[i].posterURL)
                                            .resizable()
                                            .indicator(.activity) // Activity Indicator
                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80)
                                            .cornerRadius(10)
                                    
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
            
            
            VStack(alignment:.leading,spacing:10){
                HStack{
                    Text("劇情")
                        .font(.system(size: 16,weight: .semibold))
                    Spacer()
                    Button(action:{
                        
                    }){
                        Text("顯示更多")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(Color(uiColor: UIColor.darkGray))
                    }
                }

                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(){
                        ForEach(0..<(self.movieImages.backdrops.count < 10 ? self.movieImages.backdrops.count : 10)){ i in
                            WebImage(url: self.movieImages.backdrops[i].MovieImageURL)
                                .resizable()
                                .indicator(.activity) // Activity Indicator
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                        }
                        
                        
                    }
                    
                }.frame(height: 150)
            }
            
            VStack(alignment:.leading, spacing:8) {
                if movie.videos != nil && movie.videos!.results.count > 0 {
                    Text("宣傳片")
                        .font(.system(size: 16,weight: .semibold))
                    
                    ForEach(movie.videos!.results) { trailer in
                        Button(action: {
                            //                            self.selectedTrailer = trailer
                        }) {
                            HStack {
                                Text(trailer.name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .lineLimit(1)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(Color(UIColor.systemBlue))
                            }
                        }
                    }
                }
            }
        }
        .padding(5)
    }
    
    
    @ViewBuilder
    func circleButton(systemImg: String,background:Color,buttonColor : Color,width:CGFloat,height:CGFloat,action: @escaping ()->()) -> some View{
        Button(action: action){
            ZStack(alignment:.center){
                Circle()
                    .fill(background)
                    .frame(width: width, height: height)
                
                Image(systemName: systemImg)
                    .imageScale(.medium)
                    .foregroundColor(buttonColor)
            }
        }
        
    }
    
    @ViewBuilder
    func borderButton(systemImg: String,buttonTitle: String,borderColor:Color,fontColor : Color,action: @escaping ()->()) -> some View{
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
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
                
            )
        }
        .padding(.horizontal,3)

    }
    
    @ViewBuilder
    func fullButton(systemImg: String,buttonTitle: String,backgroundColor:Color,fontColor : Color,action: @escaping ()->()) -> some View{
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
            ForEach(MovieDetailTabItem.allCases,id:\.self){ tab in
                VStack(spacing:12){
                    Text(tab.rawValue)
                        .fontWeight(.semibold)
                        .foregroundColor(tabIndex == tab ? .white : .gray)
                    
                    ZStack{
                        if tabIndex == tab {
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
                        tabIndex = tab
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top,25)
        .padding(.bottom,5)
        .background(Color.black.edgesIgnoringSafeArea(.all))
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

}



struct MovieInfoDetail: View {
    @State private var isMyList = false
    @State private var gotoChat : Bool = false
    @State var myMovieList : [CustomList]
    @State var movie : Movie
    @ObservedObject private var controller = ListDetailController()
    @ObservedObject private var favoriteController = FavoriteController()
    @ObservedObject var dramaData = dramaInfoData()
    @State var isMyFavorite: Bool 
    
    
    var body: some View {
        VStack(spacing:5){
            HStack(alignment:.center){
                
                
                Text(movie.title)
                    .bold()
                    .font(.system(size:35))
                    .foregroundColor(.red)
              //      .unredacted()
                

            
                Spacer()
                
                
                
//                Button(action:{
//                    print("MovieDetailView 220 chat")
//                   forumController.GetAllArticle()
//                }){
//                    HStack(spacing:0){
//                        Text("CHAT")
//                            .bold()
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: 60, height: 30  )
//                    .background(Color.blue)
//                    .cornerRadius(20)
//                    .font(.system(size: 15))
//                }
//                .simultaneousGesture(TapGesture().onEnded{
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                        self.gotoChat = true
//
//                    })
//
//                })
//                .fullScreenCover(isPresented: self.$gotoChat, content: {
//                    TopicView(articles: forumController.articleData, isPresented: self.$gotoChat)
//
//                })
                
                NavigationLink(destination: GetTopicView(movie:movie))
                {
                    Text("討論區")
                        .bold()
                        .frame(width: 60, height: 30  )
                        .background(Color.blue)
                        .cornerRadius(20)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal,10)
            
            Spacer()
            
            HScrollList(info: movie)
                .font(.system(size: 14))
             //   .unredacted()
            
            
            
            Spacer()
            Genre(Genres: movie.genres!)
                .padding(.horizontal,10)
              //  .unredacted()
            
            Spacer()


            
            //ScrollView for more info
            VStack(alignment:.leading,spacing:5){

                HStack(spacing:10){
//                    SmallRectButton(title: "Play", icon: "arrowtriangle.right.fill"){
//                        //To Move to Video source page
//                        print("test")
//                    }

                    //------------------------  + MY List ----------------------- -//
                    Menu {
                        ForEach(myMovieList, id:\.id){list in
                            Button(action: {
                                controller.postListMovie(listTitle: list.title, UserName: list.user!.UserName , movieID: movie.id, movietitle: movie.title, posterPath: movie.posterPath!, feeling: " ", ratetext: 0)
                            }, label: {
                                Text(list.title)
                            })
                        }
                    

                   } label: {
                        SmallBorderOnlyButton(title: "My List", icon: "plus", onChangeIcon: "checkmark",isMylist: $isMyList){
                            //To Add this movie to my List
                            isMyList.toggle()
                        }
                   }
                    
                    //------------------------  Like ? -------------------------//
                    
                    
//
                    SmallVerticalButton(IsOnImage: "heart.fill", IsOffImage: "heart", text: "Like", IsOn: $isMyFavorite){
                        isMyFavorite.toggle()

                        if isMyFavorite == true {
                            favoriteController.PostLikeMovie(movie: movie.id, title: movie.title, posterPath: movie.posterPath!)
                        } else{
                            self.favoriteController.deleteLikeMovie(movieID: movie.id)
                        }
                    }
                    .padding(.trailing)
                    
                    Spacer()

                }
                .padding(.horizontal,10)
          //      .unredacted()

                MovieDetailList(movie: movie, tabs: [.overView,.trailer,.more,.resources])
                    
//
//                VerticalButton()



            }
            .padding(.top,5)
            .font(.system(size: 14))
            .foregroundColor(Color(UIColor.systemGray3))
        }
        .font(.system(.title3))
        .foregroundColor(.white)
        .padding(.top)
       
       
    }
}

struct VerticalButton: View {
    var body: some View {
        HStack(spacing:30){
            SmallVerticalButton(IsOnImage: "paperplane.fill", IsOffImage: "paperplane.fill", text: "Share", IsOn: .constant(true)){
                //TODO
            }
            
            SmallVerticalButton(IsOnImage: "message.fill", IsOffImage: "message", text: "comment", IsOn: .constant(true)){
                //TODO
            }
            Spacer()
        }
      //  .padding(.horizontal)
    }
}

struct NavBarImage:View{
    @State var show = false
    let imgURL: URL
    var body:some View{
        
        VStack{
            WebImage(url:imgURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(5)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct showBarItem:View{
    let imgURL: URL
    let name:String
    var body:some View{
        HStack(alignment:.bottom,spacing:10){
            Spacer()
            NavBarImage(imgURL:imgURL )
                .frame(width:22,height: 22)
                .padding(.horizontal)
            
            HStack(alignment:.center,spacing:8){
                Text(name)
                    .bold()
                    .font(.system(size:12))
                    .foregroundColor(.gray)
                
                smallNavButton(buttonColor: .blue, buttonTextColor: .white, text: "CHAT"){
                    print("chat test")
                }
            }
            

        }
//
    }
    
}
//
