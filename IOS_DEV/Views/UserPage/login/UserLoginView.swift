//
//  userLoginView.swift
//  IOS_DEV
//
//  Created by Jackson on 24/8/2022.
//

import SwiftUI

struct UserLoginView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    
    @FocusState private var isFocusEmail : Bool
    @FocusState private var isFocusPassword : Bool
    var body: some View {
        VStack{
            
            TextField("email", text: $email)
                .submitLabel(.next)
                .focused($isFocusEmail)
                .onSubmit {
                    self.isFocusPassword = true
                }
            
            SecureField("password", text: $password)
                .submitLabel(.done)
                .focused($isFocusPassword)

            
        }.frame(maxHeight:.infinity,alignment: .center)
    }
    
}

