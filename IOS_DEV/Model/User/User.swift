//
//  User.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//

import Foundation


struct User: Decodable{
    var id: UUID
    var UserName: String
    var Email: String
    var Password: String
//    var UserPhoto: String
    var UserPhoto: String?
//
    var UserPhotoURL: URL {
        return URL(string:"\(baseUrl)/UserPhoto/\(UserPhoto ?? "")" )!
    }
}


