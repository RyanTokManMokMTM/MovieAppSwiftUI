//
//  post_liked_api_data.swift
//  IOS_DEV
//
//  Created by Jackson on 29/8/2022.
//

import Foundation

///REQ
struct CreatePostLikesReq : Encodable{
    let post_id : Int
}

struct RemovePostLikesReq : Encodable {
    let post_id : Int
}

struct IsPostLikedReq {
    let post_id : Int
}

struct CountPostLikesReq {
    let post_id : Int
}

///RESP
struct CreatePostLikesResp : Decodable{
}

struct RemovePostLikesResp : Decodable {
}

struct IsPostLikedResp : Decodable {
    let is_liked : Bool
}

struct CountPostLikesResp : Decodable{
    let total_likes : Int
}
