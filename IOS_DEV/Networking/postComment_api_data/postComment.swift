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
struct UpdateCommentReq : Encodable {
    let comment : String
}

/// RESPONSE
struct CreateCommentResp : Decodable {
    let id : Int
    let create_at : Int
}

struct UpdateCommentResp : Decodable {
    let update_at : Int
}


struct GetPostCommentsResp : Decodable{
    let comments : [CommentInfo]
}


//Info Data
struct CommentInfo : Decodable,Identifiable{
    let id : Int
//    let post_id : Int
    let user_info : CommentUser
    let comment : String
    let update_at : Int
    
    var comment_time : Date{
        return Date(timeIntervalSince1970: TimeInterval(update_at))
    }
}

struct CommentUser : Decodable,Identifiable {
    let id : Int
    let user_name : String
    let avatar : String
    
    var UserPhotoURL : URL {
        return URL(string: avatar)!
    }
    
}
