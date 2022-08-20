//
//  friend.swift
//  IOS_DEV
//
//  Created by Jackson on 15/8/2022.
//

import Foundation

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
