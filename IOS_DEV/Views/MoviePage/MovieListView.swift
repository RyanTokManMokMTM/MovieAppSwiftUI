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
    GenreTypeRef(id : 28,ref_path : "/g7Ahst6SCjWVijGwJYNEjxmSMRy.jpg",genre_name:"動作",genre_type: .Action), // done
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

struct MovieListView: View {
    //Manager this in a class
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var TrailerModel = TrailerVideoVM()
    
    @StateObject  var nowPlayingState = MovieListState(endpoint: .nowPlaying)
    @StateObject  var upcomingState = MovieListState(endpoint: .upcoming)
    @StateObject  var topRatedState = MovieListState(endpoint: .topRated)
    @StateObject  var popularState = MovieListState(endpoint: .popular)
    @StateObject  var trendingState = MovieListState(endpoint: .trending)
    
//    @StateObject var actionVM = GenreTypeState(genreType: .Action)
//    @StateObject var animationVM = GenreTypeState(genreType: .Animation)
//    @StateObject var adventureVM = GenreTypeState(genreType: .Adventure)
//    @StateObject var comedyVM = GenreTypeState(genreType: .Comedy)
//    @StateObject var crimeVM = GenreTypeState(genreType: .Crime)
    
    @Binding var showHomePage:Bool
    @Binding var isLogOut : Bool
    @Binding var mainPageHeight : CGFloat
    @State private var isCardSelected : Bool = false
    @State private var index : Int = 0
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment:.leading){
                
                TabView(selection: $index){
                    
                    ForEach(GenreRefsAll) { ref in
                        GeometryReader{proxy in
                            let minX = proxy.frame(in: .global).minX
                            MovieGenreCardSelectionView(isCardSelectedMovie: $isCardSelected, genreRef: ref)
                                .frame(width: proxy.frame(in: .global).width)
//                                .animation(.easeInOut)
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
//                .animation(.easeInOut)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 430)
                
                
                
                MoviesStateList()
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("為您推薦")
        .navigationTitle("為您推薦")
//        List{
//            HStack(alignment: .center, spacing: 30) {
//                ForEach(0..<GenreRefsAll.count) { i in
//
//                    ZStack(alignment:.bottomLeading){
//                        WebImage(url: GenreRefsAll[i].ref_path_URL)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 250)
//                            .cornerRadius(10)
//                            .scaleEffect(self.index == i ? 1.1 : 0.8)
//                            .overlay(
//                                LinearGradient(colors: [
//                                    Color("PersonCellColor").opacity(0.3),
//                                    Color("PersonCellColor").opacity(0.6),
//                                    Color("PersonCellColor").opacity(0.8),
//                                ], startPoint: .center, endPoint: .bottom)
//                                    .cornerRadius(10)
//                                    .scaleEffect(self.index == i ? 1.1 : 0.8)
//                            )
//
//
//                        HStack (alignment:.bottom){
//                            VStack(alignment:.leading){
//                                Text("電影類別")
//                                    .font(.system(size:18))
//                                Text("**\(GenreRefsAll[i].genre_name)**")
//                                    .font(.system(size:16))
//                            }
//
//                            Spacer()
//
//                            Text("點擊進入")
//                                .font(.system(size:14))
//                        }
//
//                        .opacity(self.index == i ? 1 : 0)
//
//                    }
//
//                }
//            }.modifier(ScrollingHStackModifier(index:$index,items: GenreRefsAll.count, itemWidth: 250, itemSpacing: 30))
//
////            .frame(height:300)
//
//            MoviesStateList()
//        }
//        .listStyle(PlainListStyle())
//        HStack(alignment: .center, spacing: 30) {
//            ForEach(0..<GenreRefsAll.count) { i in
//
//                ZStack(alignment:.bottomLeading){
//                    WebImage(url: GenreRefsAll[i].ref_path_URL)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 250)
//                        .cornerRadius(10)
//                        .scaleEffect(self.index == i ? 1.1 : 0.8)
//                        .overlay(
//                            LinearGradient(colors: [
//                                Color("PersonCellColor").opacity(0.3),
//                                Color("PersonCellColor").opacity(0.6),
//                                Color("PersonCellColor").opacity(0.8),
//                            ], startPoint: .center, endPoint: .bottom)
//                                .cornerRadius(10)
//                                .scaleEffect(self.index == i ? 1.1 : 0.8)
//                        )
//
//
//                    HStack (alignment:.bottom){
//                        VStack(alignment:.leading){
//                            Text("電影類別")
//                                .font(.system(size:18))
//                            Text("**\(GenreRefsAll[i].genre_name)**")
//                                .font(.system(size:16))
//                        }
//
//                        Spacer()
//
//                        Text("點擊進入")
//                            .font(.system(size:14))
//                    }
//
//                    .opacity(self.index == i ? 1 : 0)
//
//                }
//
//            }
//        }.modifier(ScrollingHStackModifier(index:$index,items: GenreRefsAll.count, itemWidth: 250, itemSpacing: 30))
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.large)
//        .navigationBarTitle("Movies")
//        .toolbar{
//            ToolbarItemGroup(placement:.navigationBarTrailing){
//            Image(systemName: "exclamationmark.bubble")
//                .resizable()
//                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            }
//        }//toolbar
    }
    
//    func getTime() -> String{
//        let hour = Calendar.current.component(.hour, from: Date())
//
//        switch hour{
//        case 6..<12:
//            return "早上好!"
//        case 12:
//            return "中午好!"
//        case 13..<17:
//            return "下午好!"
//        case 17..<22:
//            return "傍晚好!"
//        default:
//            return "晚上好!"
//        }
//
//    }
    
    @ViewBuilder
    func MoviesStateList() -> some View {

            
            MovieStateView(Title: "Now Playing")
                .environmentObject(nowPlayingState)
//                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
            MovieStateView(Title: "Upcoming")
                .environmentObject(upcomingState)
//                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
           
            MovieStateView(Title: "Top Rated")
                .environmentObject(topRatedState)
//                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
            MovieStateView(Title: "Popular")
                .environmentObject(popularState)
//                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
        
            MovieStateView(Title:"Trending")
                .environmentObject(trendingState)
//                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
        
    }
}

struct MovieStateView : View{
    @EnvironmentObject var State : MovieListState
    var Title : String
    var body : some View {
        if State.movies != nil {
            MoviePosterCarousel(title: Title, movies: State.movies!)
                .padding(.bottom)
            
        } else {
            LoadingView(isLoading: self.State.isLoading, error: self.State.error) {
                self.State.loadMovies()
            }
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
                    .padding()
               

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
