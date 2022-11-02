//
//  like_notification.swift
//  IOS_DEV
//
//  Created by Jackson on 1/11/2022.
//

import Foundation

struct GetLikesNotificationsResq  : Decodable {
    let notifications : [LikesNotification]
}

struct LikesNotification : Decodable,Identifiable{
    let id : Int
    let liked_by : SimpleUserInfo
    let post_info : SimplePostInfo
    let comment_info : SimpleCommentInfo
    let type : Int
    let liked_at : Int
    
    
    var likedAt : Date{
        return Date(timeIntervalSince1970: TimeInterval(liked_at))
    }
}
//
struct SimplePostInfo : Decodable{
    let id : Int
    let post_movie_info : PostMovieInfo
}

struct SimpleCommentInfo : Decodable{
    let id : Int
    let comment : String
}



