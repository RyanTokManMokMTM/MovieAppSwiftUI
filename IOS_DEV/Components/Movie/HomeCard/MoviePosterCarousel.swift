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
    @State private var isAction : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text(title)
                    .bold()
                    .font(.system(size: 25))
                    .padding(.horizontal,8)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action:{
                    print("View More\(title) movies")
                }){
                    Text("Show more")
                        .bold()
                        .padding(.horizontal,8)
                        .foregroundColor(.blue)
                        .font(.system(size:15))
                }.buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination:
                                        MovieDetailView(movieId: movie.id, navBarHidden: .constant(true), isAction: $isAction, isLoading: .constant(true))
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationTitle("")
                                        .navigationBarBackButtonHidden(true)
                                       ,isActive:$isAction
                        ) {
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
