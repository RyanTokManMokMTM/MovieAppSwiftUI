//
//  MovieListView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import SwiftUI


struct MovieListView: View {
    //Manager this in a class

    @StateObject var TrailerModel = TrailerVideoVM()
    @StateObject  var nowPlayingState = MovieListState(endpoint: .nowPlaying)
    @StateObject  var upcomingState = MovieListState(endpoint: .upcoming)
    @StateObject  var topRatedState = MovieListState(endpoint: .topRated)
    @StateObject  var popularState = MovieListState(endpoint: .popular)
    
    @StateObject var actionVM = GenreTypeState(genreType: .Action)
    @StateObject var animationVM = GenreTypeState(genreType: .Animation)
    @StateObject var adventureVM = GenreTypeState(genreType: .Adventure)
    @StateObject var comedyVM = GenreTypeState(genreType: .Comedy)
    @StateObject var crimeVM = GenreTypeState(genreType: .Crime)
    
    @Binding var showHomePage:Bool
    @Binding var isLogOut : Bool
    @Binding var mainPageHeight : CGFloat

    var body: some View {
        ScrollView(.vertical, showsIndicators: false){

                LazyVStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30){
                            //one
                            Group {
                                if actionVM.isLoading && actionVM.genreMovies.count <= 0{
                                    LoadingView(isLoading: self.actionVM.isLoading, error: self.actionVM.error) {
                                        self.actionVM.getGenreCard()
                                    }
                                }else if !actionVM.isLoading {
                                    MovieCardCarousel(genreID:GenreType.Action.rawValue)
                                        .environmentObject(actionVM)
                                }
                                
                            }

                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                            
                            //two
                            Group {
                                if animationVM.isLoading && animationVM.genreMovies.count <= 0{
                                    LoadingView(isLoading: self.animationVM.isLoading, error: self.animationVM.error) {
                                        self.animationVM.getGenreCard()
                                    }
                                }else if !actionVM.isLoading {
                                    MovieCardCarousel(genreID:GenreType.Animation.rawValue)
                                        .environmentObject(animationVM)
                 
                                }
    
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                            
                            //three
                            Group {
                                
                                if adventureVM.isLoading && adventureVM.genreMovies.count <= 0{
                                    LoadingView(isLoading: self.adventureVM.isLoading, error: self.adventureVM.error) {
                                        self.adventureVM.getGenreCard()
                                    }
                                }else if !adventureVM.isLoading {
                                    MovieCardCarousel(genreID:GenreType.Adventure.rawValue)
                                        .environmentObject(adventureVM)
                 
                                }
        
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                            
                            //four
                            Group {
                                if comedyVM.isLoading && comedyVM.genreMovies.count <= 0{
                                    LoadingView(isLoading: self.comedyVM.isLoading, error: self.comedyVM.error) {
                                        self.comedyVM.getGenreCard()
                                    }
                                }else if !comedyVM.isLoading {
                                    MovieCardCarousel(genreID:GenreType.Comedy.rawValue)
                                        .environmentObject(comedyVM)
                 
                                }
      
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                            
                            //five
                            Group {
                                
                                if crimeVM.isLoading && crimeVM.genreMovies.count <= 0{
                                    LoadingView(isLoading: self.crimeVM.isLoading, error: self.crimeVM.error) {
                                        self.crimeVM.getGenreCard()
                                    }
                                }else if !crimeVM.isLoading {
                                    MovieCardCarousel(genreID:GenreType.Crime.rawValue)
                                        .environmentObject(crimeVM)
                 
                                }

                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                            
                        } //hstack
                        .padding(.vertical,50)
                        .padding(.horizontal,28)
                        .padding(.top,50)
                        
                        
                    }//scrollview
                    .frame(height:600)

                    
                    Group {
                        if nowPlayingState.movies != nil {
                            MoviePosterCarousel(title: "Now Playing", movies: nowPlayingState.movies!)
                                .padding(.bottom)
                            
                        } else {
                            LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
                                self.nowPlayingState.loadMovies()
                            }
                        }
                        
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    
                    Group {
                        if upcomingState.movies != nil {
                            MoviePosterCarousel(title: "Upcoming", movies: upcomingState.movies!)
                                .padding(.bottom)
                        } else {
                            LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
                                self.upcomingState.loadMovies()
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    
                    
                    Group {
                        if topRatedState.movies != nil {
                            MoviePosterCarousel(title: "Top Rated", movies: topRatedState.movies!)
                                .padding(.bottom)
                            
                        } else {
                            LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
                                self.topRatedState.loadMovies()
                            }
                        }
                        
                        
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    
                    Group {
                        if popularState.movies != nil {
                            MoviePosterCarousel(title: "Popular", movies: popularState.movies!)
                                .padding(.bottom)
                            
                        } else {
                            LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
                                self.popularState.loadMovies()
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                    
                    
                }

            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("\(NowUserName), \(getTime())")
        
        .toolbar{
            ToolbarItemGroup(placement:.navigationBarLeading){
                Button(action:{
                    withAnimation(){
                        //TO trailer view
                        withAnimation{
                            isLogOut.toggle()
                            UserDefaults.standard.set("", forKey: "userToken")
                        }
    
                    }
                }){
                    HStack(spacing:5){
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .resizable()
                            .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        Text("登出")
                            .bold()
                            .font(.footnote)
                        
                    }
                    .foregroundColor(.white)
            
                        
                }

            }
            
            ToolbarItemGroup(placement:.navigationBarTrailing){

                NavigationLink(destination: MovieTrailerDiscoryView(showHomePage: self.$showHomePage,mainPageHeight:$mainPageHeight).environmentObject(TrailerModel),isActive: self.$showHomePage){
                    HStack{
                        Image(systemName: "arrowtriangle.forward.square.fill")
                            .resizable()
                            .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        Text("預告片")
                            .bold()
                            .font(.footnote)
                        
                    }
                    .foregroundColor(.white)
            
                }



                        
//                }
            }
            

        }//toolbar


        
    }
    
    func getTime() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour{
        case 6..<12:
            return "早上好!"
        case 12:
            return "中午好!"
        case 13..<17:
            return "下午好!"
        case 17..<22:
            return "傍晚好!"
        default:
            return "晚上好!"
        }

    }
}

//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView(showHomePage: .constant(false))
//    }
//}
//
