//
//  Me.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/22.
//

import Foundation
import SwiftUI

//????????????????????
//try to get all information when logged in
struct Me: Decodable{
    var id : UUID?
    var UserName : String
    var UserPhoto : String?
    var UserBackground : String?
    
//    var UserCollection : [PostCard] //if no datas ,is a empty list
//    var UserLikedMovies : [LikedMovieCard] //if no datas ,is a empty list
//    var UserGenrePrerences :[MovieGenreTab] // if no datas ,is a empty list
    
    var UserPhotoURL: URL {
        return URL(string:"\(baseUrl)/avatar/\(UserPhoto ?? "")" )!
    }
    
    var UserBackGroundURL: URL {
        return URL(string:"\(baseUrl)/background/\(UserBackground ?? "")" )!
    }
}



