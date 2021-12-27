//
//  smallButton.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI

struct smallButton: View {
    let screen = UIScreen.main.bounds
    var text:String = "Something"
    var textColor:Color = Color.white
    var button:Color = Color.white
    var image:String = ""
    
    var action : ()->()
    var body: some View {
        Button(action: action){
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(textColor)
                    .font(.headline)
                Image(systemName: image)
                    .font(.system(size: 20))
                
                Spacer()
            }
            .padding(.vertical,15)
            .background(button)
            .cornerRadius(30)
        }
    }
}

struct smallButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            smallButton(text: "Sign Up", textColor:.white, button: Color("ButtonBlue")){
                print("test")
            }
        }
    }
}
