//
//  message.swift
//  IOS_DEV
//
//  Created by Jackson on 24/10/2022.
//

import Foundation

struct GetRoomMessageReq {
    let room_id : Int
    let last_id : Int
}

struct GetRoomMessageResp : Decodable {
    let messages : [MessageInfo]
//    let meta_data : MetaData
}

//struct MessageData  : Decodable, Identifiable {
//    let id : String
//    let users : SimpleUserInfo
//    let content :  String
//    let send_time : Int
//}
