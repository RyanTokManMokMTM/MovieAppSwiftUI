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

struct UserSignInReq: Encodable{
    var name: String
    var email: String
    var password: String
//    var confirmPassword: String
}

/// RESPONSE
struct UserLoginResp : Decodable{
    var token: String
    var expired : Int
}


struct UserSignInResp: Decodable{
    var id: Int
    var name: String
    var email: String
}


struct UserProfile : Decodable{
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
    var UserGenrePrerences :[MovieGenreTab]? // if no datas ,is a empty list
    
    var UserPhotoURL: URL {
        return URL(string:"\(avatar ?? "")" )!
    }
    
    var UserBackGroundURL: URL {
        return URL(string:"\(cover ?? "")" )!
    }
}
