//
//  MovieCoverStack.swift
//  IOS_DEV
//
//  Created by Jackson on 15/5/2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct MovieCoverStack: View {
    @Binding var isCardSelectedMovie:Bool
    @State var isPress = false
    var movies : [moviesTemp]
    var body: some View {
        VStack{
            
            ZStack{
                ForEach(0..<movies.count){index in
                    //at most 5 image only
                    if index >= movies.count - 8{
                        CoverCard(url: movies[index].movieCoverURL)
                            .frame(width:245)
                            .scaleEffect( 1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movies[index].id})!) * 0.03)
                            .padding(.top,1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movies[index].id})!) * 16)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 8, y: 8)
                        
                    }
                    
                }
            }
            Text("Movie genre")
                .bold()
                .font(.body)
                .padding(.vertical)
                
                
        }
        .onTapGesture {
            withAnimation(){
                isCardSelectedMovie.toggle()
            }
        }
    }
}

struct MovieCoverStack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            MovieCoverStack(isCardSelectedMovie: .constant(false), movies: coverList)
        }
    }
}

struct CoverCard:View{
    var url:String
    var body: some View{
        
        WebImage(url:URL(string: "https://image.tmdb.org/t/p/w500\(url)")!)
            .resizable()
            .aspectRatio(0.66,contentMode: .fit)
            .cornerRadius(10)
        

    }
}


struct moviesTemp :Identifiable,Codable{
    var id:String = UUID().uuidString
    let movieName:String!
    let movieCoverURL:String!
    let movieRank:Float?
}

let coverList:[moviesTemp] = [
    moviesTemp(
        movieName: "The Scientist",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/hIkKM1nlzk8DThFT4vxgW1KoofL.jpg",
        movieRank: 3.5),
    
    moviesTemp(
        movieName: "The Unholy",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/lcCKVNQKAqZlLI5qNRJK8MPahbI.jpg",
        movieRank: 4.0),
    
    moviesTemp(
        movieName: "Ava",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/qzA87Wf4jo1h8JMk9GilyIYvwsA.jpg",
        movieRank: 2.5),
    
    
    moviesTemp(
        movieName: "Those Who Wish Me Dead",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/xCEg6KowNISWvMh8GvPSxtdf9TO.jpg",
        movieRank: 5.0),
    
    moviesTemp(
        movieName: "Oxygen",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/u74DFoZGTcZ8cuHO8nvQkCqXEVP.jpg",
        movieRank: 3.5),
    moviesTemp(
        movieName: "Black Water: Abyss",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/95S6PinQIvVe4uJAd82a2iGZ0rA.jpg",
        movieRank: 4.0),
    
    moviesTemp(
        movieName: "Birds of Prey",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg",
        movieRank: 2.5),
    
    moviesTemp(
        movieName: "Wrong Turn",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/haTcYaucQkHLkuvuIoveIyQkBoB.jpg",
        movieRank: 3.0),
    
    moviesTemp(
        movieName: "Come True",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/hGPGRRz6FTIRed1zestdWrV2Iwd.jpg",
        movieRank: 3.5),
    
    moviesTemp(
        movieName: "The Scientist",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/hIkKM1nlzk8DThFT4vxgW1KoofL.jpg",
        movieRank: 3.5),
    
    moviesTemp(
        movieName: "The Unholy",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/lcCKVNQKAqZlLI5qNRJK8MPahbI.jpg",
        movieRank: 4.0),
    
    moviesTemp(
        movieName: "Ava",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/qzA87Wf4jo1h8JMk9GilyIYvwsA.jpg",
        movieRank: 2.5),
    
    
    moviesTemp(
        movieName: "Those Who Wish Me Dead",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/xCEg6KowNISWvMh8GvPSxtdf9TO.jpg",
        movieRank: 5.0),
    
    moviesTemp(
        movieName: "Oxygen",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/u74DFoZGTcZ8cuHO8nvQkCqXEVP.jpg",
        movieRank: 3.5),
    moviesTemp(
        movieName: "Black Water: Abyss",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/95S6PinQIvVe4uJAd82a2iGZ0rA.jpg",
        movieRank: 4.0),
    
    moviesTemp(
        movieName: "Birds of Prey",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg",
        movieRank: 2.5),
    
    moviesTemp(
        movieName: "Wrong Turn",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/haTcYaucQkHLkuvuIoveIyQkBoB.jpg",
        movieRank: 3.0),
    
    moviesTemp(
        movieName: "Come True",
        movieCoverURL: "https://www.themoviedb.org/t/p/original/hGPGRRz6FTIRed1zestdWrV2Iwd.jpg",
        movieRank: 3.5)
]

let morelist = [
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled(),
    coverList.shuffled()
]
