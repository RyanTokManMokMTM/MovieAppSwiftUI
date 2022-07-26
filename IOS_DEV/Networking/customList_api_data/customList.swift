//
//  customList.swift
//  IOS_DEV
//
//  Created by Jackson on 24/7/2022.
//

import Foundation

/// RESQUEST
struct CreateNewCustomListReq : Encodable{
    let title : String
}

struct UpdateCustomListReq : Encodable {
    let id : Int
    let title : String
}

struct DeleteCustomListReq : Encodable {
    let id : Int
}



/// RESPONSE
struct CreateNewCustomListResp : Decodable {
    let id : Int
    var title: String
}


struct AllUserListResp : Decodable {
    let lists : [CustomListInfo]?
}


struct UserListResp : Decodable {
    let list : CustomListInfo
}
//List
struct CustomListInfo : Identifiable,Decodable {
    let id : Int
    var title: String
    var movie_list: [MovieInfo]?// need to change
}

struct MovieInfo : Decodable,Identifiable {
    let id : Int
    let poster : String
    let title : String
    let vote_average : Float
    
    var posterURL : URL {
        return URL(string:"https://image.tmdb.org/t/p/original\(poster)")!
    }
}


struct UpdateCustomListResp : Decodable {}
struct DeleteCustomListResp : Decodable {}
