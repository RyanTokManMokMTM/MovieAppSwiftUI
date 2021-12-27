//
//  MovieTrailer.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/12.
//

import SwiftUI
import SafariServices


struct GetMovieTrailer: View {

    let movieId: Int
    @ObservedObject private var movieDetailState = MovieDetailState()

    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovieWithEng(id: self.movieId)
            }

            if movieDetailState.movie != nil {
                TrailerView(movie: self.movieDetailState.movie!)
            }
        }
        .onAppear {
            self.movieDetailState.loadMovieWithEng(id: self.movieId)
        }
    }
}



struct TrailerView:View {
    
    let movie: Movie
    @State private var selectedTrailer: MovieVideo?
  
    
    var body: some View {
     
            
            VStack{

                if movie.youtubeTrailers != nil && movie.youtubeTrailers!.count > 0 {
//                    Text("Trailers").font(.headline)

                    Spacer()
                    
                    ForEach(movie.youtubeTrailers!) { trailer in
                        Button(action: {
                            self.selectedTrailer = trailer
                        }) {
                            HStack {
                                Text(trailer.name)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(Color(UIColor.systemBlue))
                            }
                            Spacer()

                            Divider()
                                .background(Color.gray)
                        }
                    }
                }
                else
                {
                    Text("目前無預告片")
                }
                
                Spacer(minLength: 80)
            
            }
            .sheet(item: self.$selectedTrailer) { trailer in
                SafariView(url: trailer.youtubeURL!)

            }
       
        
    }
}

struct MovieTrailer_Previews: PreviewProvider {
    static var previews: some View {
        GetMovieTrailer(movieId: 379686)
            .preferredColorScheme(.dark)
    }
}
