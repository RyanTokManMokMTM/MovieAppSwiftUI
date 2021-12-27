//
//  UserIcon.swift
//  new
//
//  Created by Jackson on 26/2/2021.
//

import SwiftUI

struct UserIcon: View {
    var body: some View {
        Button(action:{
            //Tap to change the image
        }){
            Image(systemName:"person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.black)
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                
                )
                .clipped()
        }
    }
}

struct UserIcon_Previews: PreviewProvider {
    static var previews: some View {
        UserIcon()
    }
}
