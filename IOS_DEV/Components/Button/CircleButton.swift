//
//  CircleButton.swift
//  new
//
//  Created by Jackson on 25/2/2021.
//

import SwiftUI

struct CircleButton: View {
    var IconName:String = ""
    var isSystemName:Bool = true
    var ButtonColor:Color = .white
    var action:()->()
    
    var body: some View {
        Button(action: action){
            if isSystemName{
                Image(systemName: IconName)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    .background(ButtonColor)
                    .cornerRadius(25)
                    .shadow(color: Color(UIColor.systemGray2), radius: 25, x: 0, y: 0)
            }
            else{
                Image(IconName)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    .background(ButtonColor)
                    .cornerRadius(25)
                    .shadow(color: Color(UIColor.systemGray2), radius: 25, x: 0, y: 0)
            }
            
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            CircleButton(IconName:"facebook",isSystemName: false,ButtonColor: .white){
                print("")
            }
        }

        
    }
}
