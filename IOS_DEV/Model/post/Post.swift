//
//  Post.swift
//  IOS_DEV
//
//  Created by Jackson on 17/7/2022.
//

import SwiftUI

struct Post : Identifiable,Hashable,Decodable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id : Int
    let user_info : PosterOwner
    let post_title : String
    let post_desc : String
    let post_movie_info : PostMovieInfo
    let post_like_count : Int
    let post_comment_count : Int
    let create_at : Int
    var comments : [CommentInfo]? // if comment count != to comments.size -> fetching
    
    var post_at : Date {
        return Date(timeIntervalSince1970: TimeInterval(create_at))
    }
    
    var post_like_desc : String {
        if post_like_count > 1000 {
            let desc = post_like_count / 1000
            return desc.description + "k"
        }
        return post_like_count.description
    }
}

struct PosterOwner : Identifiable,Decodable {
    let id : Int
    let name : String
    let avatar : String?
    
    var UserPhotoURL: URL {
        return URL(string:"\(avatar ?? "")" )!
    }
}

//struct PostInfo : Identifiable, Decodable {
//    let id : Int
//    let
//    let post_title : String
//    let post_desc : String
//    let post_movie_info : PostMovieInfo
//    let post_comment_count : Int
//    let post_like_count : Int
//    let create_time : Int
//    let edit_time : Int
//}

struct PostMovieInfo : Identifiable, Decodable {
    let id : Int
    let title : String
    let poster_path : String?

    var PosterURL : URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(poster_path ?? "")")!
    }
}
