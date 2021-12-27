//
//  CommentRes.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/3.
//

import Foundation

struct CommentRes: Decodable{
    var id: UUID
    var Text: String
    var user: usrID?
    var article: artID?
    var LikeCount: Int
    var updatedOn: String   //db is 'DATE', but here is 'STRING'
}

struct usrID: Decodable{
    var id: UUID
}

struct artID: Decodable{
    var id: UUID
}
