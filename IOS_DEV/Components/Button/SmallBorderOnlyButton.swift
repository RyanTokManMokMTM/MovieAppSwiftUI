//
//  SmallBorderOnlyButton.swift
//  IOS_DEV
//
//  Created by Jackson on 29/4/2021.
//

import SwiftUI

struct SmallBorderOnlyButton: View {
    var title:String
    var icon:String
    var onChangeIcon : String
    var textColor : Color = .white
    var borderColor : Color = .white
    @Binding var isMylist:Bool
    
    var action : ()->()
    
    var body: some View {
        Button(action:action){
            HStack(spacing:10){
                Image(systemName: isMylist ? onChangeIcon : icon)
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(textColor)
            .frame(width:UIScreen.main.bounds.width / 3.5,height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 3)

            )
        }
    }
}

struct SmallBorderOnlyButton_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            SmallBorderOnlyButton(title: "My List", icon: "plus", onChangeIcon: "checkmark",isMylist: .constant(true)){
                print()
            }
        }
    }
}
