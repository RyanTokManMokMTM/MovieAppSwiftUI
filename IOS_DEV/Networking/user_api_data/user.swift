//
//  request.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation


struct ResetFriendNotificationResp : Decodable{}
struct ResetCommentNotificationResp : Decodable {}
struct ResetLikesNotificationResp : Decodable {}

/// RESQUEST
struct UserLoginReq: Encodable{
    var email: String
    var password: String
}

struct UserSignUpReq: Encodable{
    var name: String
    var email: String
    var password: String
//    var confirmPassword: String
}

struct UserProfileUpdateReq  : Encodable{
    let name : String
}

struct UserUpdateAvatarReq  : Encodable{}

struct UserUpdateCoverReq  : Encodable{}

//struct GetFollowingListReq {
//    let user_id : Int
//}
//
//struct GetFollowedListReq {
//    let user_id : Int
//}

struct CountFriendReq {
    let user_id : Int
}

struct GetFriendListReq {
    let user_id : Int
}

/// RESPONSE
struct UserLoginResp : Decodable{
    var token: String
    var expired : Int
}


struct UserSignUpResp: Decodable{
    var token: String
    var expired_time : Int
}

//struct GetFollowingListResp : Decodable {
//    let following : [SimpleUserInfo]
//}
//
//struct GetFollowedListResp : Decodable {
//    let followed : [SimpleUserInfo]
//}

struct CountFriendResp : Decodable {
    let total : Int
}

struct GetFriendListResp : Decodable {
    let friends : [SimpleUserInfo]
}

struct GetFriendRoomListResp : Decodable {
    let lists : [FriendInfo]
}

struct FriendInfo : Decodable,Identifiable {
    let id : Int
    let info : SimpleUserInfo
}


struct UserProfileUpdateResp  : Decodable{}

struct UploadImageResp  : Decodable{
    let path : String
}

struct SimpleUserInfo : Decodable {
    var id : Int
    var name : String
    var avatar : String
    
    var UserPhotoURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(avatar)" )!
    }
}

struct Profile : Decodable{
    var id : Int
    var name : String
    var email : String
    var avatar : String?
    var cover : String?
    var notification_info : NotificationInfo? //
    
    //Empty for first login
    //Get data when the first time load the personal page
    var UserCollection : [Post]?//if no datas ,is a empty list
    var UserLikedMovies : [LikedMovieCard]?//if no datas ,is a empty list
    var UserCustomList : [CustomListInfo]?
    var UserGenrePrerences :[GenreTypeInfo]? // if no datas ,is a empty list
    
    var UserPhotoURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(avatar ?? "")" )!
    }
    var UserBackGroundURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(cover ?? "")" )!
    }
    
    var totol_notification : Int {
        return (notification_info?.comment_notification_count ?? 0) + (notification_info?.friend_notification_count ?? 0) + (notification_info?.likes_notification_count ?? 0)
    }
    
}

struct NotificationInfo : Decodable {
    var friend_notification_count : Int
    var likes_notification_count : Int
    var comment_notification_count : Int
    
    var friend_count : String {
        if friend_notification_count <= 99 {
            return "\(friend_notification_count)"
        }else {
            return "99+"
        }
    }
    
    var comment_count : String {
        if comment_notification_count <= 99 {
            return "\(comment_notification_count)"
        }else {
            return "99+"
        }
    }
    
    var likes_count : String {
        if likes_notification_count <= 99 {
            return "\(likes_notification_count)"
        }else {
            return "99+"
        }
    }
}
