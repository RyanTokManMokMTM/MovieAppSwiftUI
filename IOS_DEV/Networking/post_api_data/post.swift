//
//  post.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

/// REQUEST
struct CreatePostReq : Encodable {
    let post_title: String
    let post_desc : String
    let movie_id : Int
}

struct UpdatePostReq : Encodable {
    let post_id : Int
    let post_title : String
    let post_desc : String
}

struct CountUserPostReq {
    let user_id : Int
}

/// RESPONSE

//Post
struct CreatePostResp : Identifiable,Decodable {
    let id : Int
    let create_time : Int
}

struct AllUserPostResp : Decodable {
    let post_info : [Post]
}


struct FollowingUserPostResp : Decodable {
    let post_info : [Post]
}

struct UserPostResp : Decodable {
    let post_info : [Post]? // can be empty
}

struct PostInfoReq : Decodable {
    let post_info : Post
}

struct CountUserPostResp : Decodable {
    let total_posts : Int
}
