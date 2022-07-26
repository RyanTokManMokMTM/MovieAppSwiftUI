//
//  MovieListView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import SwiftUI


struct MovieListView: View {
    //Manager this in a class
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var TrailerModel = TrailerVideoVM()
    
    @StateObject  var nowPlayingState = MovieListState(endpoint: .nowPlaying)
    @StateObject  var upcomingState = MovieListState(endpoint: .upcoming)
    @StateObject  var topRatedState = MovieListState(endpoint: .topRated)
    @StateObject  var popularState = MovieListState(endpoint: .popular)
    @StateObject  var trendingState = MovieListState(endpoint: .trending)
    
    @StateObject var actionVM = GenreTypeState(genreType: .Action)
    @StateObject var animationVM = GenreTypeState(genreType: .Animation)
    @StateObject var adventureVM = GenreTypeState(genreType: .Adventure)
    @StateObject var comedyVM = GenreTypeState(genreType: .Comedy)
    @StateObject var crimeVM = GenreTypeState(genreType: .Crime)
    
    @Binding var showHomePage:Bool
    @Binding var isLogOut : Bool
    @Binding var mainPageHeight : CGFloat

    var body: some View {
        List{
            //Genre Type
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 30){
                    MovieGenreStateView(genreID: GenreType.Action.rawValue, GenreType: "Action")
                        .environmentObject(actionVM)
                    MovieGenreStateView(genreID : GenreType.Animation.rawValue, GenreType: "Animation")
                        .environmentObject(animationVM)
                    MovieGenreStateView(genreID: GenreType.Adventure.rawValue, GenreType: "Adventure")
                        .environmentObject(adventureVM)
                    MovieGenreStateView(genreID: GenreType.Comedy.rawValue, GenreType: "Comedy")
                        .environmentObject(comedyVM)
                    MovieGenreStateView(genreID: GenreType.Comedy.rawValue, GenreType: "Crime")
                        .environmentObject(crimeVM)
                }
            }
//            .frame(height:300)

            MoviesStateList()
        }
        .listStyle(PlainListStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
//        .navigationBarTitle("\(self.userVM.profile!.name), \(getTime())")
        .navigationBarTitle("Movies")
        .toolbar{
            ToolbarItemGroup(placement:.navigationBarTrailing){
            Image(systemName: "exclamationmark.bubble")
                .resizable()
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }//toolbar
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
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
            MovieStateView(Title: "Upcoming")
                .environmentObject(upcomingState)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
           
            MovieStateView(Title: "Top Rated")
                .environmentObject(topRatedState)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
            MovieStateView(Title: "Popular")
                .environmentObject(popularState)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
        
            MovieStateView(Title:"Trending")
                .environmentObject(trendingState)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
        
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
                self.State.getGenreCard()
            }
        }else if !State.isLoading {
            MovieGenreCard(genreCard: State.genreMovies[0], genreTitle: GenreType, isPress: $isCardSelectedMovie)
                .fullScreenCover(isPresented: $isCardSelectedMovie, content: {
                    MovieCardGesture( movies: State.genreMovies,currentMovie: State.genreMovies.last, backHomePage: $isCardSelectedMovie,genreID:genreID)
                        .environmentObject(State)
                })
        }
    }
}

//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView(showHomePage: .constant(false))
//    }
//}
//
