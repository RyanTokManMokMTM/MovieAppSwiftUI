//
//  MoviePosterCarousel.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import Foundation
import SwiftUI

struct MoviePosterCarousel: View {
    
    let title: String
    let movies: [Movie]
    @State private var isCardSelectedMovie:Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)

                .bold()
                .font(.title2)
                .padding(.horizontal,8)
                .foregroundColor(.red)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true))) {
                            MoviePosterCard(movie: movie)
                        }.buttonStyle(PlainButtonStyle())
                            .padding(.leading, movie.id == self.movies.first!.id ? 16 : 0)
                            .padding(.trailing, movie.id == self.movies.last!.id ? 16 : 0)
                        
  
                        
                        
                    }
                }
            }
        }
        
    }
}
//
//struct MoviePosterCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            MoviePosterCarousel(title: "Now Playing", movies: stubbedMovie)
//        }
//    }
//}
