//
//  File.swift
//  IOS_DEV
//
//  Created by Jackson on 23/10/2022.
//

import Foundation

@MainActor
class NotificationVM : ObservableObject{
    @Published var notificationMataData : MetaData?
    @Published var friendRequest : [FriendRequest] = []
    @Published var likesNotification : [LikesNotification] = []
    @Published var commentNotification : [CommentNotification] = []
    
    @Published var isLoadingFriendRequest : Bool = false
    @Published var isLoadingLikes : Bool = false
    @Published var isLoadingComment : Bool = false
    
    init(){}
    
    func GetFriendRequests(){
        APIService.shared.GetFriendRequest{ result in
            switch result{
            case .success(let data):
//                print(data.requests)
                self.friendRequest = data.requests
                self.notificationMataData = data.meta_data
            case .failure(let err):
               
                print("err \(err.localizedDescription)")
            }
        }
    }
    
    func RefershFriendRequest() async {
        let resp = await APIService.shared.AsyncGetFriendRequest()
        switch resp {
        case .success(let data):
            self.friendRequest = data.requests
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func LoadMoreFriendRequests() async{
        if self.notificationMataData == nil || self.notificationMataData!.page == self.notificationMataData!.total_pages{
            return
        }
        
        self.isLoadingFriendRequest = true
        let resp = await APIService.shared.AsyncGetFriendRequest(page:self.notificationMataData!.page + 1)
        switch resp {
        case .success(let data):
            self.friendRequest.append(contentsOf: data.requests)
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isLoadingFriendRequest = false
    }
    
    func GetLikesNotification(){
        APIService.shared.GetLikesNotification(){ result in
            switch result{
            case .success(let data):
                print("likes notification get")
                self.likesNotification = data.notifications
                self.notificationMataData = data.meta_data
            case .failure(let err):
                print("likes notification err")
                print(err.localizedDescription)
            }
        }
    }
    
    func RefershLikesNotification() async{

        
        let resp = await APIService.shared.AsyncGetLikesNotification()
        switch resp {
        case .success(let data):
            self.likesNotification = data.notifications
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func LoadMoreLikesNotification() async{
        if self.notificationMataData == nil || self.notificationMataData!.page == self.notificationMataData!.total_pages{
            return
        }
        
        self.isLoadingLikes = true
        let resp = await APIService.shared.AsyncGetLikesNotification(page:self.notificationMataData!.page + 1)
        switch resp {
        case .success(let data):
            self.likesNotification.append(contentsOf: data.notifications)
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isLoadingLikes = false
    }
    
    func GetCommentNotification(){
        APIService.shared.GetCommentNotification(){ result in
            switch result{
            case .success(let data):
//                print(data.notifications)
                self.commentNotification = data.notifications
                self.notificationMataData = data.meta_data
            case .failure(let err):
                print("comment notification err")
                print(err.localizedDescription)
            }
        }
    }
    
    func RefershCommentNotification() async {

        
        let resp = await APIService.shared.AsyncGetCommentNotification()
        switch resp {
        case .success(let data):
            self.commentNotification = data.notifications
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func LoadMoreCommentNotification() async {
        if self.notificationMataData == nil || self.notificationMataData!.page == self.notificationMataData!.total_pages{
            return
        }
        
        self.isLoadingComment = true
        let resp = await APIService.shared.AsyncGetCommentNotification(page:self.notificationMataData!.page + 1)
        switch resp {
        case .success(let data):
            self.commentNotification.append(contentsOf: data.notifications)
            self.notificationMataData = data.meta_data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isLoadingComment = false
    }
    
    func isLastFriendNotification(id : Int) -> Bool{
        return self.friendRequest.last?.request_id == id
    }
    
    func isLastCommentNotification(id : Int) -> Bool{
        return self.commentNotification.last?.id == id
    }
    
    func isLastLikesNotification(id : Int) -> Bool {
        return self.likesNotification.last?.id == id
    }
    
}
