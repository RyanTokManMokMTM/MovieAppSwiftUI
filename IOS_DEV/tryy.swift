//
//  tryy.swift
//  new
//
//  Created by 張馨予 on 2021/2/22.
//

import SwiftUI

let screenSize = UIScreen.main.bounds //取得螢幕尺寸
struct ErrorMessageView: View {
    var body: some View {
        VStack(spacing:10){
            HStack{
                Text("Failed")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
           
            Text("Error message")
                .lineLimit(2)
                .frame(width: screen.width - 120, height: 50)
                
            
            Button(action:{
                //cancle and back to the page
            }) {
                Text("Cancle")
                    .foregroundColor(.black)
                    .frame(width: screen.width - 120, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.top)
            
        }
        .frame(width: 300, height: 200)
        .padding(.top,10)
        .padding(.horizontal)
        .padding(.bottom,10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 10, x: 15, y: 15)
    }
}

struct tryy_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            ErrorMessageView()
        }
           
    }
}
