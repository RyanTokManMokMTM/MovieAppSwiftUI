//
//  MovieCardCarousel.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieCardCarousel: View{

    let genreID : Int
    @State private var isCardSelectedMovie:Bool = false
    @EnvironmentObject var movieListMV : GenreTypeState
    
    private func getScale(geo : GeometryProxy)->CGFloat {
       var scale:CGFloat = 1.0
       let x = geo.frame(in: .global).minX
       
       let newScale = abs(x)
       if newScale < 100{
           scale = 1 + (100 - newScale) / 500
       }
       
       return scale
   }
   
    
    var body: some View{
        HStack(){
            
            GeometryReader { proxy in
                let scaleValue = getScale(geo: proxy)
                
                MovieCoverCardStack(isCardSelectedMovie: $isCardSelectedMovie, movies: movieListMV.genreMovies, genreID: genreID)
                //                    MovieGenreCard(isCardSelectedMovie: $isCardSelectedMovie, ReferenceGenreType: movieListMV.genreMovies[0], genreID: genreID)
                    .rotation3DEffect(Angle(degrees:Double(proxy.frame(in: .global).minX - 30)  / -20), axis: (x: 0, y: 20.0, z: 0))
                    .scaleEffect(CGSize(width: scaleValue, height: scaleValue))
                    .animation(.spring())
                    .onTapGesture {
                        withAnimation(){
                            self.isCardSelectedMovie.toggle()
                        }
                    }
                    .fullScreenCover(isPresented: $isCardSelectedMovie, content: {
                        MovieCardGesture( movies: movieListMV.genreMovies,currentMovie: movieListMV.genreMovies.last, backHomePage: $isCardSelectedMovie,genreID:genreID)
                            .environmentObject(movieListMV)
                    })
                
                    .frame(width: 275)
            }
        }
    }
}

