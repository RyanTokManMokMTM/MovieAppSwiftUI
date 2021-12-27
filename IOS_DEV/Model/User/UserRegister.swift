//
//  UserRegister.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/22.
//

import Foundation

struct UserRegister: Encodable{
    var user_name: String
    var email: String
    var password: String
    var confirm_password: String
}

