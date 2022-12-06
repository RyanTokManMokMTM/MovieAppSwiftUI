//
//  comment_notification.swift
//  IOS_DEV
//
//  Created by Jackson on 1/11/2022.
//

import Foundation

struct GetCommentNotificationsResq  : Decodable {
    let notifications : [CommentNotification]
    let meta_data : MetaData
}

struct CommentNotification : Decodable,Identifiable {
    let id : Int
    let comment_by : SimpleUserInfo
    let parent_id : Int //This comment notification belong to ?
    let post_info : SimplePostInfo
    let comment_info : SimpleCommentInfo
    let reply_comment_info : SimpleCommentInfo
    let type : Int
    let comment_at : Int
    
    var commentAt : Date {
        return Date(timeIntervalSince1970: TimeInterval(comment_at))
    }
    

}
