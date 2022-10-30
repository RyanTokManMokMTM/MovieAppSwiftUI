//
//  request.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

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
    
    //Empty for first login
    //Get data when the first time load the personal page
    var UserCollection : [Post]? //if no datas ,is a empty list
    var UserLikedMovies : [LikedMovieCard]? //if no datas ,is a empty list
    var UserCustomList : [CustomListInfo]?
    var UserGenrePrerences :[GenreTypeInfo]? // if no datas ,is a empty list
    
    var UserPhotoURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(avatar ?? "")" )!
    }
    var UserBackGroundURL: URL {
        return URL(string:"\(SERVER_HOST)/resources\(cover ?? "")" )!
    }
    
    
}
