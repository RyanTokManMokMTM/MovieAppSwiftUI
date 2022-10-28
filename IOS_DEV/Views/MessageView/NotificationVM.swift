//
//  File.swift
//  IOS_DEV
//
//  Created by Jackson on 23/10/2022.
//

import Foundation

class NotificationVM : ObservableObject{
    @Published var friendRequest : [FriendRequest] = []
    
    init(){}
    
    func GetFriendRequests(){
        APIService.shared.GetFriendRequest{ result in
            switch result{
            case .success(let data):
                print(data.requests)
                self.friendRequest = data.requests
            case .failure(let err):
                print("err \(err.localizedDescription)")
            }
        }
    }
    
    
}
