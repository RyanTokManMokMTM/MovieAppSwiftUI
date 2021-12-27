//
//  smallNavButton.swift
//  IOS_DEV
//
//  Created by Jackson on 3/5/2021.
//

import SwiftUI

struct smallNavButton: View {
    var buttonColor:Color = .blue
    var buttonTextColor:Color = .white
    var text:String
    var action:()->()
    var body: some View {
        Button(action:action){
            HStack(spacing:0){
                Text(text)
                    .bold()
                    .foregroundColor(buttonTextColor)
            }
            .frame(width: 60, height: 30  )
            .background(buttonColor)
            .cornerRadius(20)
            .font(.system(size: 15))
        }
    }
}

struct smallNavButton_Previews: PreviewProvider {
    static var previews: some View {
        smallNavButton(buttonColor: .blue, buttonTextColor: .white, text: "CHAT"){
            print("")
        }
        
    }
}
