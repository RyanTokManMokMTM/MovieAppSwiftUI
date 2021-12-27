//
//  ErrorResponse.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/18.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    let reason: String
    
    var errorDescription: String? { return reason }
}
