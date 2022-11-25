//
//  room.swift
//  IOS_DEV
//
//  Created by Jackson on 23/10/2022.
//

import Foundation

//MARK: Room Request for group chat
struct CreateRoomReq : Encodable{
    let name : String
    let info : String
}
struct DeleteRoomReq : Encodable{
    let room_id : Int
}
struct JoinRoomReq{
    let room_id : Int
}
struct LeaveRoomReq{
    let room_id : Int
}
struct GetRoomMembersReq{
    let room_id : Int
}
struct SetIsReadReq {
    let room_id : Int
}
struct GetRoomInfoReq {
    let roome_id : Int
}


struct CreateRoomResp : Decodable{
    let room_id : Int
    let room_name : String
    let room_info : String
    
}
struct DeleteRoomResp : Decodable{}
struct JoinRoomResp : Decodable{}
struct LeaveRoomResp : Decodable {}
struct GetRoomMembersResp : Decodable {
    let members : [SimpleUserInfo]
}

struct SetIsReadResp : Decodable {}

struct GetUserRoomsResp : Decodable{
    let rooms : [ChatData]
}

struct GetRoomInfoResp : Decodable {
    let info : ChatData
}

struct ChatData : Decodable, Identifiable{
    let id : Int
    let users : [SimpleUserInfo]
    var messages : [MessageInfo]
    var last_sender_id : Int
    var is_read : Bool
    var meta_data : MetaData
    
    var last_sent : Date? { //for sorting the chat room
        let last_message = messages.last ?? nil
//        print(last_message)
        if last_message == nil {
            return nil
        }
        
        return last_message!.SendTime
    }
}

struct MessageInfo : Decodable,Identifiable{
    let id : String
    let msg_identity : Int //msg id in sql
    let message : String
    let sender_id : Int
    let sent_time : Int
    
    var SendTime : Date{
        return Date(timeIntervalSince1970: TimeInterval(sent_time))
    }
    
    var RoomUUID : UUID {
        return UUID(uuidString: id)!
    }
}


