//
//  movie.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

struct CountMovieLikesReq : Encodable {
    let movie_id : Int
}
struct CountMovieCollectedReq : Encodable {
    let movie_id : Int
}

struct CountMovieLikesResp : Decodable {
    let total_liked : Int
}
struct CountMovieCollectedResp : Decodable {
    let total_collected : Int
}

struct MoviePageListByGenreResp : Decodable {
    let movie_infos : [MovieCardInfo]
}

struct MovieDetailResp: Decodable {
    let info : Movie
}


struct MovieCardInfo : Identifiable,Decodable{
    let id : Int
    let title : String
    let poster : String?
    let vote_average : Double
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster ?? "")")!
    }
    
    var ratingText: String {
        let rating = Int(vote_average)/2
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
            
        }
        
        return ratingText
    }
}


