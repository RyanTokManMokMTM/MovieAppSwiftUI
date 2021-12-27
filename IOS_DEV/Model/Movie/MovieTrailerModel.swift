//
//  Movie.swift
//  IOS_DEV
//
//  Created by Jackson on 7/4/2021.
//
import Foundation
import SwiftUI
import AVKit

//struct Trailer:Identifiable{
//    var id : Int
//    var title:String
//    var genres:[String]
////    var videoPlayer:AVPlayer
//=
//}

struct Trailer : Identifiable{
    let id : Int
    let videoPlayer : AVPlayer
    let info : TrailerInfo

}


struct TrailerInfo : Identifiable,Decodable{
    let id : Int //MovieID
    let title : String //Movie Title
    let genres : [String] //Movie Genres
    let poster : String //Movie Poster
    let video_titles : [String]
    let video_paths : [String] //Movie Trailer URLS

}


//struct MovieInfo:Identifiable{
//    var id = UUID().uuidString //To identify each movie
//    let movieName:String //Current  MovieName
//    let adult:Bool //18+?
//    let desscription:String
//    let movieLanguage:String
//    let releaseDate:Date
//    let movireTrainer:[Trailer]?
//    let moviePoster:[String]?
//    let movieBackDrop:[String]?
//    let movieType:[String]
//    let movieActor:[MovieActor]
//    let movieRank:Float?
//}
//
//
//
struct MovieActor{
    let actorName :String!
    let actorAvatorImage : String!
    let actorCharactorName : String!
}

//struct MovieStuff{
//    let actorName :String!
//    let actorAvatorImage : String!
//    let actorCharactorName : String!
//}


struct MovieCapture{
    let CaptureImage:String!
}
//
//struct moviesTemp :Identifiable,Codable{
//    var id:String = UUID().uuidString
//    let movieName:String!
//    let movieCoverURL:String!
//    let movieRank:Float?
//}
//
//
//
//let coverList:[moviesTemp] = [
//    moviesTemp(
//        movieName: "The Scientist",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/hIkKM1nlzk8DThFT4vxgW1KoofL.jpg",
//        movieRank: 3.5),
//    
//    moviesTemp(
//        movieName: "The Unholy",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/lcCKVNQKAqZlLI5qNRJK8MPahbI.jpg",
//        movieRank: 4.0),
//    
//    moviesTemp(
//        movieName: "Ava",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/qzA87Wf4jo1h8JMk9GilyIYvwsA.jpg",
//        movieRank: 2.5),
//    
//    
//    moviesTemp(
//        movieName: "Those Who Wish Me Dead",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/xCEg6KowNISWvMh8GvPSxtdf9TO.jpg",
//        movieRank: 5.0),
//    
//    moviesTemp(
//        movieName: "Oxygen",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/u74DFoZGTcZ8cuHO8nvQkCqXEVP.jpg",
//        movieRank: 3.5),
//    moviesTemp(
//        movieName: "Black Water: Abyss",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/95S6PinQIvVe4uJAd82a2iGZ0rA.jpg",
//        movieRank: 4.0),
//    
//    moviesTemp(
//        movieName: "Birds of Prey",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg",
//        movieRank: 2.5),
//    
//    moviesTemp(
//        movieName: "Wrong Turn",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/haTcYaucQkHLkuvuIoveIyQkBoB.jpg",
//        movieRank: 3.0),
//    
//    moviesTemp(
//        movieName: "Come True",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/hGPGRRz6FTIRed1zestdWrV2Iwd.jpg",
//        movieRank: 3.5),
//    
//    moviesTemp(
//        movieName: "The Scientist",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/hIkKM1nlzk8DThFT4vxgW1KoofL.jpg",
//        movieRank: 3.5),
//    
//    moviesTemp(
//        movieName: "The Unholy",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/lcCKVNQKAqZlLI5qNRJK8MPahbI.jpg",
//        movieRank: 4.0),
//    
//    moviesTemp(
//        movieName: "Ava",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/qzA87Wf4jo1h8JMk9GilyIYvwsA.jpg",
//        movieRank: 2.5),
//    
//    
//    moviesTemp(
//        movieName: "Those Who Wish Me Dead",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/xCEg6KowNISWvMh8GvPSxtdf9TO.jpg",
//        movieRank: 5.0),
//    
//    moviesTemp(
//        movieName: "Oxygen",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/u74DFoZGTcZ8cuHO8nvQkCqXEVP.jpg",
//        movieRank: 3.5),
//    moviesTemp(
//        movieName: "Black Water: Abyss",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/95S6PinQIvVe4uJAd82a2iGZ0rA.jpg",
//        movieRank: 4.0),
//    
//    moviesTemp(
//        movieName: "Birds of Prey",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg",
//        movieRank: 2.5),
//    
//    moviesTemp(
//        movieName: "Wrong Turn",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/haTcYaucQkHLkuvuIoveIyQkBoB.jpg",
//        movieRank: 3.0),
//    
//    moviesTemp(
//        movieName: "Come True",
//        movieCoverURL: "https://www.themoviedb.org/t/p/original/hGPGRRz6FTIRed1zestdWrV2Iwd.jpg",
//        movieRank: 3.5)
//]

//let morelist = [
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled(),
//    coverList.shuffled()
//]
