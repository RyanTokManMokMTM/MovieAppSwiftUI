//
//  LargeButton.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI

struct LargeButton: View {
    let screen = UIScreen.main.bounds
    var text:String = "Something"
    var textColor:Color = Color.white
    var button:Color = Color.white
    
    var action :()-> Void
    
    var body: some View {
        Button(action: action){
            HStack{
                Text(text)
                    .foregroundColor(textColor)
                    .font(.headline)
            }
            .padding(.horizontal,screen.width / 3)
            .padding(.vertical)
            .background(button)
            .cornerRadius(25)
        }
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            LargeButton(text: "Sign Up", textColor: .black, button: .white){
                print("test")
            }
            
        }
    }
}
