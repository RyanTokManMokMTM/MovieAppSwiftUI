//
//  likedMovie.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

/// REQUEST
struct NewUserLikeMoviedReq: Encodable{
    let movie_id : Int
}

struct DeleteUserLikedMovie : Encodable {
    let movie_id : Int
}

struct IsLikedMovieReq {
    let movie_id : Int
}



//Liked movie
struct CreateUserLikedMovieResp : Decodable {
//    var liked_movie_id : Int
//    var user_id : Int
}

struct DeleteUserLikedMovieResp : Decodable {}

struct AllUserLikedMovieResp : Decodable{
    var liked_movies : [LikedMovieCard]?
}

struct IsLikedMovieResp : Decodable {
    let is_liked_movie : Bool
}
