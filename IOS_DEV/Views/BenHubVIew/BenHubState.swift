//
//  BenHubState.swift
//  IOS_DEV
//
//  Created by Jackson on 3/9/2022.
//

import Foundation
import SwiftUI

enum StateType {
    case normal
    case system_message
    case notification
}

final class BenHubState : ObservableObject{
    
    //Loading or wait
    @Published var isWait : Bool = false
    
    //For API Aleart
    @Published var isPresented : Bool = false
    static let shared = BenHubState()
    
    private(set) var message : String = ""
    private(set) var sysImg : String = ""
    private(set) var senderInfo : SimpleUserInfo? = nil
    private(set) var type : StateType = .normal
    
    
    private init(){}
    
    
    func SetWait(message : String){
        self.message = message
        withAnimation{
            self.isWait = true
        }
    }
    
    func AlertMessageWithUserInfo(message : String, userInfo : SimpleUserInfo,type : StateType = .normal){
        self.message = message
        self.senderInfo = userInfo
        self.type = type
        
        DispatchQueue.main.async {
            withAnimation{
                self.isPresented = true
            }
        }
        
    }
    
    func AlertMessage(sysImg : String,message : String ,type : StateType = .normal){
        self.sysImg = sysImg
        self.message = message
        self.type = type
        DispatchQueue.main.async {
            withAnimation{
                self.isPresented = true
            }
        }

    }
    
    
}
