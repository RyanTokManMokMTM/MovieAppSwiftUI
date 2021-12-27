//
//  FloatingButton.swift
//  IOS_DEV
//
//  Created by Jackson on 17/5/2021.
//

import SwiftUI

struct FloatingButton: View {
    var FloatingButtonImage:String = "film"
    var action:()->()
    var body: some View {
        Button(action:action){
            ZStack{
                Circle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 0)
                
                VStack(spacing:2){
                    
                    Image(systemName: "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .foregroundColor(.black)
                    
                    Text("Trailer")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(){
            print("")
        }
    }
}
