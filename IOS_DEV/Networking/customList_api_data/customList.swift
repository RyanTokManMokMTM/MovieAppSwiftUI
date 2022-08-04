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
    let intro : String
}

struct UpdateCustomListReq : Encodable {
    let id : Int
    let title : String
    let intro : String
}

struct DeleteCustomListReq : Encodable {
    let id : Int
}



/// RESPONSE
struct CreateNewCustomListResp : Decodable {
    let id : Int
    let title: String
    let intro : String
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
    var intro : String
    var movie_list: [MovieInfo]?// need to change
    
    var introStr : String {
        return intro.isEmpty ? "作者沒有設定專輯簡介喲~" : intro
    }
}

struct MovieInfo : Decodable,Identifiable,Hashable {
    
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
