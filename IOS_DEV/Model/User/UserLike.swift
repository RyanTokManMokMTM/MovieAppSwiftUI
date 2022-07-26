//
//  UserLike.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation

//-----喜愛文章-----//
struct LikeArticle: Decodable {
    var like_id: UUID
    var like_user_id: UUID
    var article_id: UUID
    var article_title: String
    var article_text: String
    var user_id: UUID
    var movie_id: Int
    var article_like_count: Int
    var article_last_update: String?
    var user_name: String
    var user_avatar: String
    
    var user_avatarURL: URL {
        return URL(string: "\(baseUrl)/UserPhoto/\(user_avatar)")!
    }
}


//新增喜愛文章
struct NewLikeArticle: Encodable{
    var userID : UUID
    var articleID : UUID
}


//-----喜愛電影-----//
struct LikeMovie: Decodable, Identifiable{
    var id: UUID?
    var user: usrID
    var movie : Int
    var title : String
    var posterPath : String
    var updatedOn: String
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }

}

//新增喜愛電影
struct NewLikeMovie: Encodable{
    var userID : UUID
    var movie : Int
    var title : String
    var posterPath : String
}

//-----回傳喜愛項目的ID-----//
struct CheckLike: Decodable{
    var id : UUID?
}
