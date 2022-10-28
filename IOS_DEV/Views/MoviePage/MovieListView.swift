//
//  MovieListView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import SwiftUI
import SDWebImageSwiftUI

//Don't change ...
struct GenreTypeRef : Identifiable {
    let id : Int //GenreID
    let ref_path : String //an image that refer to the type
    let genre_name : String
    let genre_type : GenreType
    var ref_path_URL : URL {
        return URL(string:"https://image.tmdb.org/t/p/original\(ref_path)")!
    }
}

var GenreRefsAll : [GenreTypeRef] = [
    GenreTypeRef(id : 28,ref_path : "/hb6HJLxQThNkvFu82oBaEer7B8w.jpg",genre_name:"動作",genre_type: .Action), // done
    GenreTypeRef(id : 12,ref_path : "/pgmcRSfzFlNRgwnXLTHfWLISuiM.jpg",genre_name:"冒險",genre_type: .Adventure),
    GenreTypeRef(id : 16,ref_path : "/z5uxyimSIYitt7QSopEaUheiY0H.jpg",genre_name:"動畫",genre_type: .Animation),
    GenreTypeRef(id : 35,ref_path : "/fXPmd5LRljSEHU2ld2HNA01EKUV.jpg",genre_name:"喜劇",genre_type: .Comedy),
    GenreTypeRef(id : 80,ref_path : "/h305HSAFCxI1i5Ahj1OTwAHClKu.jpg",genre_name:"犯罪",genre_type: .Crime),
    GenreTypeRef(id : 99,ref_path : "/AdDVUw5RJ7DLF1Wv4VK2BvgLB67.jpg",genre_name:"紀錄",genre_type: .Documentary),
    GenreTypeRef(id : 18,ref_path : "/bflMATCOIkLJDfABFYPbxls1m4S.jpg",genre_name:"劇情",genre_type: .Drama),
    
    GenreTypeRef(id : 10751,ref_path : "/ePuHjmIuK26U9aNJ7zNzzxjzwEB.jpg",genre_name:"家庭",genre_type: .Family ),
    GenreTypeRef(id : 14,ref_path : "/3vm7LOe7DhkiA7umBhslQy9MdkY.jpg",genre_name:"奇幻",genre_type: .Fantasy ),
    GenreTypeRef(id : 36,ref_path : "/ivzRrgKZF7n0383Fw2I0VFvhtaq.jpg",genre_name:"歷史",genre_type: .History ),
    GenreTypeRef(id : 27,ref_path : "/ftpV6LJaUTiweWKROgOHtp7tfHU.jpg",genre_name:"恐怖",genre_type: .Horror ),
    GenreTypeRef(id : 10402,ref_path : "/ePuHjmIuK26U9aNJ7zNzzxjzwEB.jpg",genre_name:"音樂",genre_type: .Music ),
    GenreTypeRef(id : 9648,ref_path : "/eYJ2P0cf6x0A1SOGt1T806D04rr.jpg",genre_name:"懸疑",genre_type: .Mystery ),
    GenreTypeRef(id : 10749,ref_path : "/xHYhxDiCaW6n1Mzaxus1ClB822L.jpg",genre_name:"愛情",genre_type: .Romance ),
    
    GenreTypeRef(id : 878,ref_path : "/rO3nV9d1wzHEWsC7xgwxotjZQpM.jpg",genre_name:"科幻",genre_type: .ScienceFiction ),
    GenreTypeRef(id : 10770,ref_path : "/vVuJmsydZzkS2aW1VTc3kwTdpxq.jpg",genre_name:"電視電影",genre_type: .TvMovie ),
    GenreTypeRef(id : 53,ref_path : "/5aiWjszOlAqE7Wo5KFCfs20bQeh.jpg",genre_name:"戰爭",genre_type: .War ),
    GenreTypeRef(id : 37,ref_path : "/g52uwPys1BOj3LiB8LBA7AkSu0v.jpg",genre_name:"西部",genre_type: .Western ),
]

struct MovieList : Identifiable {
    let id : String = UUID().uuidString
    let title : String
    let list_end_point : MovieListEndpoint
}

var MovieLists : [MovieList] = [
    MovieList(title: "熱映中", list_end_point: .nowPlaying),
    MovieList(title: "即將推出", list_end_point: .upcoming),
    MovieList(title: "評分最高", list_end_point: .topRated),
    MovieList(title: "最受歡迎", list_end_point: .popular),
    MovieList(title: "熱門", list_end_point: .trending)
]



enum HomeTabItem : String{
    case TV = "TV"
    case Moive = "電影"
    case Trailer = "預告"
}

struct HomeNavTabView : View {
    @Binding var index : HomeTabItem
    @State private var isSelectMovie : Bool = false
    @State private var isSearching : Bool = false
    
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    var body: some View {
        HStack{
            Spacer()
            Button(action:{
                //MAY BE A NAVIGATION LINK
                withAnimation{
                    self.isSearching = true
                }
            }){
                Image(systemName:"magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.white)
                    
            }
        }.overlay(
            HStack(spacing:20){
//                Spacer()
                Text("OTTSoSo")
                    .LeckerliOneRegularFont(size:22)
                Spacer()
//                HomeTabButton(index: $index,tab: .TV) //TODO: NOT AVAILABLE YET
//                HomeTabButton(index: $index,tab: .Moive)
//                HomeTabButton(index: $index,tab: .Trailer) //TODO: NOT AVAILABLE YET
            }
//                .animation(.easeInOut, value: 0.3)
//                .transition(.slide)
                .padding(.horizontal)
        )
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .background(Color("DarkMode2"))
            .background(
                NavigationLink(destination: MovieMainSearchView(isSeacrhing: $isSearching)
                                .environmentObject(userVM)
                                .environmentObject(postVM)
                               , isActive: $isSearching){
                    EmptyView()
                }
            
            )
        

    }

}

struct HomeTabButton : View {
    @Binding var index : HomeTabItem
    var tab : HomeTabItem
    var body: some View {
        Button(action:{
            withAnimation{
                self.index = tab
            }
        }){
            Text(tab.rawValue)
                .font(.system(size: 16, weight: self.index == tab ? .bold : .medium ))
                .foregroundColor(Color.white.opacity(self.index == tab ? 0.7 : 0.3))
//                .scaleEffect(self.index == tab ? 1.1 : 1)
                .padding(.horizontal,15)
            
        }
        
        
    }
}


struct MovieListView: View {
    //Manager this in a class
    @StateObject var HubState : BenHubState = BenHubState.shared
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    
//    @StateObject var TrailerModel = TrailerVideoVM()

    @Binding var showHomePage:Bool
    @Binding var mainPageHeight : CGFloat
    @State private var isCardSelected : Bool = false
    @State private var index : Int = 0
    @State private var tabIndex : HomeTabItem = .Moive
    
    @State private var showMovieDetail : Bool = false
    var body: some View {
            VStack(spacing:0){
                VStack(spacing:0){
                    HomeNavTabView(index: $tabIndex)
                    Divider()
                    
                }
                MoviePage()
            }
            .background(Color("DarkMode2"))
            .wait(isLoading: $HubState.isWait){
                BenHubLoadingView(message: HubState.message)
            }
            .alert(isAlert: $HubState.isPresented){
                switch HubState.type{
                case .normal,.system_message:
                    BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
                case .notification:
                    BenHubAlertWithFriendRequest(user: HubState.senderInfo!, message: HubState.message)
                case .message:
                    BenHubAlertWithMessage(user: HubState.senderInfo!, message: HubState.message)
                }
            }
            
    }
    
    @ViewBuilder
    func MoviePage() -> some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(alignment:.leading){
                TabView(selection: $index){
                    ForEach(GenreRefsAll) { ref in
                        GeometryReader{proxy in
                            let minX = proxy.frame(in: .global).minX
                            MovieGenreCardSelectionView(isCardSelectedMovie: $isCardSelected, genreRef: ref)
                                .frame(width: proxy.frame(in: .global).width)
                                .rotation3DEffect(.degrees(minX / -10), axis: (x:0,y:1,z:0))
                                .padding(.vertical)
                                .onTapGesture{
                                    withAnimation{
                                        self.isCardSelected.toggle()
                                    }
                                }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 430)
                
                MoviesStateList()
            }

        }
    }
    
    @ViewBuilder
    func MoviesStateList() -> some View {
        
        VStack(spacing:15){
            ForEach(MovieLists){ listInfo in
                MovieStateView(info: listInfo)
                    .padding(.vertical,8)
            }
        }
    }
}

struct MovieStateView : View{
    //    @EnvironmentObject var State : MovieListState
    @StateObject var State = MovieListState()
    var info : MovieList
    var body : some View {
        VStack{
            if State.movies != nil {
                MoviePosterCarousel(title: info.title)
                    .environmentObject(State)
//                    .padding(.bottom)
                
            } else {
                LoadingView(isLoading: self.State.isLoading, error: self.State.error) {
                    //                self.State.loadMovies()
                    self.State.loadMovies(endpoint: info.list_end_point)
                }
            }
        }
        .onAppear{
            self.State.loadMovies(endpoint: info.list_end_point)
        }
    }

}

struct MovieGenreStateView : View{
    @EnvironmentObject var State : GenreTypeState
    @State private var isCardSelectedMovie:Bool = false
    let genreID : Int
    var GenreType : String
    var body : some View {
        if State.isLoading && State.genreMovies.count <= 0{
            LoadingView(isLoading: self.State.isLoading, error: self.State.error) {
//                self.State.getGenreCard()
            }
        }else if !State.isLoading {
            MovieGenreCard(genreCard: State.genreMovies[0], genreTitle: GenreType, isPress: $isCardSelectedMovie)
//                .fullScreenCover(isPresented: $isCardSelectedMovie, content: {
//                    MovieCardGesture( movies: State.genreMovies,currentMovie: State.genreMovies.last, backHomePage: $isCardSelectedMovie,genreID:genreID)
//                        .environmentObject(State)
//                })
        }
    }
}

struct MovieGenreCardSelectionView : View{
    @StateObject var State : GenreTypeState = GenreTypeState()
    @Binding var isCardSelectedMovie:Bool
    var genreRef : GenreTypeRef
    
    var body : some View {
        WebImage(url: genreRef.ref_path_URL)
            .resizable()
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .aspectRatio(contentMode: .fit)
            .frame(width:250)
            .cornerRadius(10)
            .overlay(
                LinearGradient(colors: [
                    Color("PersonCellColor").opacity(0.3),
                    Color("PersonCellColor").opacity(0.6),
                    Color("PersonCellColor").opacity(0.8),
                ], startPoint: .center, endPoint: .bottom)
                    .cornerRadius(10)
            )
            .overlay(
                VStack{
                    Spacer()
                    HStack (alignment:.bottom){
                        VStack(alignment:.leading){
                            Text("電影類別")
                                .font(.system(size:18))
                            Text("**\(genreRef.genre_name)**")
                                .font(.system(size:16))
                        }
                        
                        Spacer()
                        
                        Text("點擊進入")
                            .font(.system(size:14))
                    }
                }
                    .padding(5)
               

            )
        .fullScreenCover(isPresented: $isCardSelectedMovie, content: {
            MovieCardGesture(movies:self.State.genreMovies,currentMovie: State.genreMovies.last, backHomePage: $isCardSelectedMovie,name: genreRef.genre_name)
                .environmentObject(State)
             
        })
        .onAppear{
            self.State.getGenreCard(genreType: genreRef.genre_type)
        }

    }
}


//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView(showHomePage: .constant(false))
//    }
//}
//
