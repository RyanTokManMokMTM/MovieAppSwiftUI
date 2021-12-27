//
//  Squsre1.swift
//  new
//
//  Created by 張馨予 on 2021/3/21.
//

import SwiftUI

struct Squsre1: View
{
    var ImageName:String = ""
    var TopicName:String = ""
    var TopicTitle:String = ""
    var Content:String = ""
    var Date:String = ""
    //var action :()-> Void
    var body: some View
    {
        Button(action: {print("test")})
        {
            HStack(spacing:0)
            {
                
                VStack()
                {
                        
                        Image(ImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 135)
                    //Spacer()
                    Text(Content)
                        .padding([.leading, .bottom],10)
                    
                    
                }
                
            }
            .frame(width: 170, height: 175, alignment: .leading)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 2, x: 1.0, y: 1.0)
            .padding(.horizontal, 10)
        }
        .foregroundColor(.black)
    }
}


struct Squsre1_Previews: PreviewProvider
{
    static var previews: some View
    {
        Squsre1(ImageName: "wa", Content: "'孤味'相關文章")
        
    }
}
