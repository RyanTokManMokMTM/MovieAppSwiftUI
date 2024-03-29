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
    let list_id : Int
    let title : String
    let intro : String
}

struct DeleteCustomListReq : Encodable {
    let list_id : Int
}

struct GetOneMovieFromUserListReq{
    let movie_id : Int
}

struct RemoveMovieFromListReq  {
    let list_id : Int
    let movie_id : Int
}

struct RemoveListMovieReq  : Encodable{
    let movie_ids : [Int]
}


/// RESPONSE

struct GetListMovieResp : Decodable {
    let list_movies : [ListMovieInfo]
}

struct GetCollectedMovieResp  : Decodable {
    let total : Int
}

struct CreateNewCustomListResp : Decodable {
    let id : Int
    let title: String
    let intro : String
}


struct AllUserListResp : Decodable {
    let lists : [CustomListInfo]?
    let meta_data : MetaData
}


struct UserListResp : Decodable {
    let list : CustomListInfo
}

struct GetOneMovieFromUserListResp : Decodable {
    let list_id : Int
    let is_movie_in_list : Bool
}

struct RemoveMovieFromListResp  : Decodable{
}

struct RemoveListMovieResp   : Decodable {
}

//List
struct CustomListInfo : Identifiable,Decodable {
    let id : Int
    var title: String
    var intro : String
    var total_movies : Int
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


struct ListMovieInfo : Decodable,Identifiable,Hashable {
    
    var id : Int{
        return movie_info.id
    }
    let movie_info : MovieInfo
    let created_time : Int
}

struct UpdateCustomListResp : Decodable {}
struct DeleteCustomListResp : Decodable {}

struct InsertMovieToListResp : Decodable {
    
}
