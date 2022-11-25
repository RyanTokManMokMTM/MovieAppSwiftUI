//
//  ShowMoreStateMovie.swift
//  IOS_DEV
//
//  Created by Jackson on 3/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShowMoreStateMovieView: View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var state : MovieListState
    let endPoint : MovieListEndpoint
    var stateTitle : String
    @Binding var isShowAll : Bool
    @State private var isShowMovieDetail : Bool = false
    @State private var selectedMovieID : Int = -1
    

    var grids : [GridItem] = Array(repeating: GridItem(spacing:25), count: 2)
    var body: some View {
        GeometryReader { proxy  in
            VStack(spacing:0){
                NavBar()
                
//                ScrollView(.vertical,showsIndicators: false){
//                    LazyVStack(spacing:0){
//
////                        LazyVGrid(columns: grids,spacing:20) {
////                            ForEach(0..<self.state.movies!.count,id:\.id){ i in
////                                Button(action:{
////                                    withAnimation{
////                                        self.isShowMovieDetail.toggle()
////                                        self.selectedMovieID = self.state.movies![i].id
////                                    }
////                                }){
////                                    MovieCard(movie: self.state.movies![])
////                                }
////
////                            }
////                        }.padding(.horizontal,15).padding(.top,5)
////
////
////
////                        if self.state.page < self.state.total && self.state.total != 0{
////                            ActivityIndicatorView()
////                                .padding(.vertical)
////                                .task {
////                                    print("loading more movie")
////                                    await self.state.loadMoreMovies(endpoint: self.endPoint)
////                                }
////                        }
//                    }
//
//
//                }
                FlowLayoutWithLoadMoreView(list: state.movies!, columns: 2,HSpacing: 10,VSpacing: 20){ info in
                    Button(action: {
                        self.isShowMovieDetail.toggle()
                        self.selectedMovieID = info.id
                    }){
                        MovieCardView(movieData: info)
                    }
                } loadMoreContent: {
                    if self.state.loadMore{
                        ActivityIndicatorView()
                            .padding(.vertical)
                            .task {
                                self.state.loadMore = false //repersent loading
                                await self.state.loadMoreMovies(endpoint: self.endPoint)
                            }
                    }
                }
                .background(
                    NavigationLink(destination: MovieDetailView(movieId: self.selectedMovieID, isShowDetail: self.$isShowMovieDetail)
                                    .environmentObject(postVM)
                                    .environmentObject(userVM)
                                   ,isActive: self.$isShowMovieDetail){
                        EmptyView()
                    }
                
                )
            }
            .background(Color("DarkMode2").edgesIgnoringSafeArea(.all))

        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        VStack(spacing:0){
            HStack(){
                Button(action:{
                    withAnimation(){
                        self.isShowAll.toggle()
                    }
                }){
                   Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(stateTitle)
                    .font(.system(size: 16,weight:.semibold))
                Spacer()
            }
            .font(.system(size: 14))
            .padding(.horizontal,10)
            .padding(.bottom,10)
            
            Divider()
        }
        .padding(.top,5)
        .frame(width: UIScreen.main.bounds.width,alignment: .bottom)
        .background(Color("DarkMode2"))
//                Divider()
    }
    
    @ViewBuilder
    func MovieCard(movie : Movie) -> some View {
        VStack(spacing:8){
            WebImage(url: movie.posterURL)
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("appleDark"))
                        .aspectRatio(contentMode: .fit)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
            
            Text(movie.title)
                .font(.system(size: 16,weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            //star
            HStack(spacing:3){
                if (movie.voteAverage)/2 == 0{
                    Text("N/A")
                        .foregroundColor(.white)
                        .font(.caption)
                }else{
                    ForEach(1...5,id:\.self){index in
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(index <= Int(movie.voteAverage)/2 ? .yellow: .gray)
                    }
                    
                    Text("(\(Int(movie.voteAverage)/2).0)")
                        .foregroundColor(.white)
                        .font(.caption)
                }

            }
        }
    }
}


struct TestMovieData : Identifiable {
    let id  = UUID().uuidString
    let name : String
    let poster : String
    let vote_avaage : Float
    
    var PostURL : URL{
        return URL(string: "https://image.tmdb.org/t/p/original\(poster)")!
    }
}

var testTemoMoves : [TestMovieData] = [
    TestMovieData(name: "雷神索爾：愛與雷霆", poster: "/i1NAuDW8oOlV5dBbXPPTuPlt8sl.jpg", vote_avaage: 6.702),
    TestMovieData(name: "侏羅紀世界：統霸天下", poster: "/mC9SZcD4lNqXYZVKrB3DPvDBv3k.jpg", vote_avaage: 7.089),
    TestMovieData(name: "奇異博士2：失控多重宇宙", poster: "/hb6HJLxQThNkvFu82oBaEer7B8w.jpg", vote_avaage: 7.514),
    TestMovieData(name: "非凡公主", poster: "/87d9eaUZewedxTKgWz2b2UdFOoF.jpg", vote_avaage: 7.091),
    TestMovieData(name: "恐怖X檔案", poster: "/b5ug4LyLQFeR6azAJyIPBQz5ur9.jpg", vote_avaage: 6.739),
]
