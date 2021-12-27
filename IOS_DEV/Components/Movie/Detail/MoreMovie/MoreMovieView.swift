//
//  MoreMovieView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//


import SwiftUI
import SDWebImageSwiftUI

struct GetMoreMovie: View{
    let movieID: Int
    @ObservedObject private var recommendState = RecommendState()
 
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.recommendState.isLoading, error: self.recommendState.error) {
                self.recommendState.RecommendMovies(id: movieID)
            }
            
            if recommendState.movies != nil {
                MoreMovieView(movies: self.recommendState.movies!)
            }
            
        }
        .onAppear {
            self.recommendState.RecommendMovies(id: movieID)
            
        }
    }
}

struct MoreMovieView: View {

    var columns = Array(repeating: GridItem(.flexible(),spacing:15), count: 3)
    let movies : [Movie]
    
    var body: some View {
        
        ScrollView(.vertical)
        {
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(self.movies ,id: \.id) { movie in
                    
                    NavigationLink(destination: MovieDetailView(movieId: movie.id, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true)))
                    {
                        MovieItem(movie: movie)
                    }
                   
                }
            }
            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            
            Spacer(minLength: 50)
            
        }
    
    
    }
    
   
}

struct MoreMovieView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Color.black.edgesIgnoringSafeArea(.all)
            GetMoreMovie(movieID: 590223)
        }
    }
}

struct MovieItem:View {
    var movie:Movie
    var body: some View {
       
        VStack{
            WebImage(url: movie.posterURL)
                .resizable()
                .aspectRatio(contentMode:.fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 1)
                )

            
            
            VStack(spacing:5){
                Text(movie.title)
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(movie.ratingText)
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
            
        }
           
            
    }
}
