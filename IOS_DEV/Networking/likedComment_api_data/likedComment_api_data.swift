//
//  likedComment_api_data.swift
//  IOS_DEV
//
//  Created by Jackson on 29/8/2022.
//

import Foundation

struct CreateCommentLikesReq : Encodable {
    let comment_id : Int
}

struct RemoveCommentLikesReq : Encodable {
    let comment_id : Int
}

struct IsCommentLikedReq {
    let comment_id : Int
}

struct CountCommentLikesReq {
    let comment_id : Int
}


struct CreateCommentLikesResp : Decodable {
}

struct RemoveCommentLikesResp : Decodable {
}

struct IsCommentLikedResp : Decodable {
    let is_liked : Bool
}

struct CountCommentLikesResp : Decodable {
    let total_likes : Int
}
