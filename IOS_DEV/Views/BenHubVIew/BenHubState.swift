//
//  BenHubState.swift
//  IOS_DEV
//
//  Created by Jackson on 3/9/2022.
//

import Foundation
import SwiftUI

final class BenHubState : ObservableObject{
    
    //Loading or wait
    @Published var isWait : Bool = false
    
    //For API Aleart
    @Published var isPresented : Bool = false
    
    
    private(set) var message : String = ""
    private(set) var sysImg : String = ""
    
    init(){}
    
    func SetWait(message : String){
        self.message = message
        withAnimation{
            self.isWait = true
        }
    }
    
    func AlertMessage(sysImg : String,message : String ){
        self.sysImg = sysImg
        self.message = message
        
        withAnimation{
            self.isPresented = true
        }
    }
}
