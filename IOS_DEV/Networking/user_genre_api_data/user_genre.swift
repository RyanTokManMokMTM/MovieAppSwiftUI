//
//  user_genre.swift
//  IOS_DEV
//
//  Created by Jackson on 29/8/2022.
//

import Foundation

struct UpdateUserGenreReq : Encodable {
    let genre_ids : [Int]
}

struct GetUserGenreReq : Encodable {
    let user_id : Int
}

struct GetUserGenreResp : Decodable {
    let user_genres : [GenreTypeInfo]
}


struct UpdateUserGenreResp : Decodable {
}


struct GenreTypeInfo : Decodable {
    let id : Int
    let name : String
}
