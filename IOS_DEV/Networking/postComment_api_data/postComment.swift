//
//  postComment.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

/// REQUEST
struct CreateCommentReq : Encodable {
    let comment : String
}

struct CreateReplyCommentReq : Encodable {
    let post_id : Int
    let comment_id : Int
    let comment : String
}

struct UpdateCommentReq : Encodable {
    let comment : String
}

struct GetReplyCommentReq {
    let comment_id : Int
}

struct CountPostCommentReq {
    let post_id : Int
}

/// RESPONSE
struct CreateCommentResp : Decodable {
    let id : Int
    let create_at : Int
}

struct CreateReplyCommentResp : Decodable {
    let id : Int
    let create_at : Int
}




struct UpdateCommentResp : Decodable {
    let update_at : Int
}


struct GetPostCommentsResp : Decodable{
    let comments : [CommentInfo]
}

struct GetReplyCommentResp : Decodable{
    let reply : [CommentInfo]
}

struct DeletePostCommentResp : Decodable {}

struct CountPostCommentsResp : Decodable {
    let total_comment : Int
}

//Info Data
struct CommentInfo : Decodable,Identifiable{
    let id : Int
//    let post_id : Int
    let user_info : CommentUser
    let comment : String
    let update_at : Int
    var reply_comments : Int
    var replys : [Comment]? //can be empty
    
    var comment_time : Date{
        return Date(timeIntervalSince1970: TimeInterval(update_at))
    }
}

struct CommentUser : Decodable,Identifiable {
    let id : Int
    let name : String
    let avatar : String
    
    var UserPhotoURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(avatar)" )!
    }
}
