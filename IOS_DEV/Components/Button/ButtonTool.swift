//
//  ButtonTool.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/5.
//

import Foundation
import SwiftUI

struct ButtonTool:View{
    @State var open = false

    var body:some View{
        
        ZStack(alignment: .trailing){
            Button(action: {
                self.open.toggle()
            })
            {
                Image(systemName: "plus")
                    .rotationEffect(.degrees(open ? 45 : 0))
                    .foregroundColor(.white)
                    .font(.system(size:22,weight: .bold))
                    .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
                    
            }
            .padding(20)
            .background(Color("ButtonRed"))
            .mask(Circle())
            .shadow(color: Color("ButtonRed"), radius: 5)
            .zIndex(10)
            
            SecondaryButton(open: $open, action:1 ,icon: "plus", color: "CustomBlue",offsetY: -90)
            SecondaryButton(open: $open, action:2 , icon: "pencil", color: "CustomPurple",offsetX: -60,offsetY: -60)
            SecondaryButton(open: $open, action:3 , icon: "trash", color: "CustomRed",offsetX: -90)
            
        }

    }

}


//struct ButtonTool_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ButtonTool()
//    }
//}


struct SecondaryButton:View{
    @Binding var open : Bool
    @State var action : Int = 0     // 1:new, 2:edit , 3:delete
    var icon = "pencil"
    var color = "blue"
    var offsetX = 0
    var offsetY = 0
    var delay = 0.0

    var body:some View{
        Button(action: {
            if action == 1 {    //new
                print("new")
            }
            else if action == 2 {   //edit
                print("edit")
            }
            else if action == 3 {   //delete
                print("delete")
            }
            
        })
        {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size:16,weight: .bold))
        }
        .padding()
        .background(Color(color))
        .mask(Circle())
        .offset(x: open ? CGFloat(offsetX) : 0 , y: open ? CGFloat(offsetY) : 0 )
        //.scaleEffect(open ? 1 : 0)
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
    }

}
