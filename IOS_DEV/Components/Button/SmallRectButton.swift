//
//  SmallRectButton.swift
//  IOS_DEV
//
//  Created by Jackson on 29/4/2021.
//

import SwiftUI

struct SmallRectButton: View {
    
    var title:String
    var icon:String
    var textColor : Color = .white
    var buttonColor : Color = .red
    
    var action : ()->()
    
    var body: some View {
        Button(action:action){
            HStack(spacing:10){
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(textColor)
            .frame(width:UIScreen.main.bounds.width / 3.5,height: 40)
            .background(buttonColor)
            .cornerRadius(5)
        }
    }
}

struct SmallRectButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            SmallRectButton(title: "Play", icon: "arrowtriangle.right.fill"){
                print("")
            }
        }
    }
}
