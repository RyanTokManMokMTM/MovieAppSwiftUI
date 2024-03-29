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

struct CreateReplyCommentReq {
    let post_id : Int
    let comment_id : Int
    let info : ReplyCommentBody
}

struct ReplyCommentBody : Encodable {
    let parent_id : Int
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

struct DeletePostCommentReq : Encodable{
    let comment_id : Int
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
    let meta_data : MetaData
}

struct GetReplyCommentResp : Decodable{
    let reply : [CommentInfo]
    let meta_data : MetaData
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
    var is_liked : Bool
    var comment_likes_count : Int
    let parent_comment_id : Int
    let reply_id : Int
    let reply_to : SimpleUserInfo
    var replys : [CommentInfo]? //can be empty //same parent comment id
    var meta_data : MetaData?  //reply comment only
    
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
