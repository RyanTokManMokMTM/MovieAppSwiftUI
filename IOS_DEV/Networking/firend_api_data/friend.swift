//
//  friend.swift
//  IOS_DEV
//
//  Created by Jackson on 15/8/2022.
//

import Foundation
import CoreGraphics

///REQUEST
struct CreateNewFriendReq : Encodable{
    let friend_id : Int
}
struct RemoveFriendReq : Encodable {
    let friend_id : Int
}
struct GetOneFriendReq{
    let friend_id : Int
} //path

struct CountFollowingReq  {
    let  user_id : Int
} //path

struct CountFollowedReq  {
    let  user_id : Int
} //path


///RESPONSE
struct CreateNewFriendResp : Decodable{}
struct RemoveFriendResp : Decodable{}
struct GetOneFriendResp : Decodable{
    let is_friend : Bool
}
struct CountFollowingResp : Decodable {
    let total : Int
}
struct CountFollowedResp : Decodable {
    let total : Int
}


//MARK: Updated
//MARK: Request
struct AddFriendReq : Encodable{
    let user_id : Int
}
struct AddFriendResp : Decodable{
    let sender : Int
    let request_id : Int
}




struct FriendRequestAccecptReq : Encodable{
    let request_id : Int
}

struct FriendRequestDeclineReq : Encodable{
    let request_id : Int
}

struct FriendRequestCancelReq : Encodable{
    let request_id : Int
}

struct IsFriendReq {
    let friend_id : Int
}


//struct GetFriendRequestListReq : Encodable{}

//MARK: Response
struct FriendRequestAcceptResp : Decodable{
    let message : String
}
struct FriendRequestDeclineResp : Decodable{
    let message : String
}
struct FriendRequestCancelResp : Decodable {
    let message : String
}
struct GetFriendRequestListResp : Decodable {
    let requests : [FriendRequest]
    let meta_data : MetaData
}

struct IsFriendResp : Decodable {
    var is_friend : Bool
    var is_sent_request : Bool
    var request : BasicRequestInfo?
}

struct BasicRequestInfo : Decodable{
    var request_id : Int
    var sender_id : Int
}

struct FriendRequest : Decodable{
    let request_id : Int
    let sender : SimpleUserInfo
    let send_time : Int
    var state : Int
    
    var sendTime : Date {
        return Date(timeIntervalSince1970: TimeInterval(send_time))
    }
}

struct GetFriendsResp : Decodable {
    let friends : [SimpleUserInfo]
}
