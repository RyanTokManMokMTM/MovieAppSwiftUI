//
//  NetworkConnectionService.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 30/11/2021.
//

import SwiftUI
import Network

final class NetworkConnectionService : ObservableObject{
   private let monitor = NWPathMonitor()
   private let monitor_Queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected : Bool = true
    init(){
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        
        monitor.start(queue: monitor_Queue)
    }
}
