//
//  MoreMovieView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//

import SwiftUI

struct GetMoreMovie: View{
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    
    let movieID: Int
    @Binding var isAbleToScroll : Bool
    @EnvironmentObject private var recommendState : RecommendState
    @State private var isShowMovieDetail = false
    @State private var showDetailId = 0
    var body: some View {
        VStack {
            if recommendState.movies != nil {
                FlowLayoutWithLoadMoreView(isLoading: $recommendState.isLoading,list: recommendState.movies!, columns: 2,HSpacing: 5,VSpacing: 10,isScrollable: $isAbleToScroll){ info in
                    Button(action: {
                        self.showDetailId = info.id
                        self.isShowMovieDetail = true
                    }){
                        MovieCardView(movieData: info)
                            .task {
                                if self.recommendState.isLastMovie(movieID: info.id){
                                    await self.recommendState.LoadMoreRecommendMovies(id: self.movieID)
                                }
                                
                            }
                            .background(Color("appleDark").edgesIgnoringSafeArea(.all).clipShape(CustomeConer(width: 5, height: 5, coners: .allCorners)))
                    }
                    
                }
            }
        }
        .background(
            NavigationLink(destination: MovieDetailView(movieId: self.showDetailId, isShowDetail: $isShowMovieDetail)
                .environmentObject(postVM)
                .environmentObject(userVM)
                           , isActive: $isShowMovieDetail) {
                EmptyView()
            }
        
        )
    }
}
//
//struct MoreMovieView: View {
//    let movies : [Movie]
//    var body: some View {
//
//        FlowLayoutView(list: movies, columns: 2,HSpacing: 5,VSpacing: 10){ info in
//
//            MovieCardView(movieData: info)
//        }
////
////        FlowLayoutView(list: self.movies, columns: 2,HSpacing: 10,VSpacing: 15){ info in
////            Button(action:{
////                DispatchQueue.main.async {
//////                    self.movieId = info.id
//////                    self.isShowMovieDetail = true
////                }
////            }){
////                MovieCardView(movieData: info)
////            }
////        }
////        .frame(maxWidth:.infinity)
////        .background(Color("DarkMode2").frame(maxWidth:.infinity))
//
//    }
//
//
//}
//
//
//struct MovieItem:View {
//    var movie:Movie
//    var body: some View {
//
//        VStack{
//            WebImage(url: movie.posterURL)
//                .resizable()
//                .aspectRatio(contentMode:.fit)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.purple, lineWidth: 1)
//                )
//
//
//
//            VStack(spacing:5){
//                Text(movie.title)
//                    .bold()
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//                Text(movie.ratingText)
//                    .font(.caption)
//                    .foregroundColor(.yellow)
//            }
//
//        }
//
//
//    }
//}
