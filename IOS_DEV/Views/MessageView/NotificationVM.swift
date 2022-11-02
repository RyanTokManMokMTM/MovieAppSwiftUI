//
//  File.swift
//  IOS_DEV
//
//  Created by Jackson on 23/10/2022.
//

import Foundation

class NotificationVM : ObservableObject{
    @Published var friendRequest : [FriendRequest] = []
    @Published var likesNotification : [LikesNotification] = []
    @Published var commentNotification : [CommentNotification] = []
    
    init(){}
    
    func GetFriendRequests(){
        APIService.shared.GetFriendRequest{ result in
            switch result{
            case .success(let data):
//                print(data.requests)
                self.friendRequest = data.requests
            case .failure(let err):
               
                print("err \(err.localizedDescription)")
            }
        }
    }
    
    func GetLikesNotification(){
        APIService.shared.GetLikesNotification(){ result in
            switch result{
            case .success(let data):
                print("likes notification get")
                self.likesNotification = data.notifications
            case .failure(let err):
                print("likes notification err")
                print(err.localizedDescription)
            }
        }
    }
    
    func GetCommentNotification(){
        APIService.shared.GetCommentNotification(){ result in
            switch result{
            case .success(let data):
                print("comment notification get")
//                print(data.notifications)
                self.commentNotification = data.notifications
            case .failure(let err):
                print("comment notification err")
                print(err.localizedDescription)
            }
        }
    }
    
    
}
