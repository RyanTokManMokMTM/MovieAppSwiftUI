//
//  Square.swift
//  new
//
//  Created by 張馨予 on 2021/3/21.
//

import SwiftUI

struct Square: View
{
    var ImageName:String = ""
    var TopicName:String = ""
    var TopicTitle:String = ""
    var Content:String = ""
    var Date:String = ""
    
    var action :()-> Void
    
    var body: some View
    {
        
        Button(action:action)
        {
            HStack(spacing:0)
            {
                
                VStack(alignment:.leading)
                {
                    Spacer()
                    HStack()
                    {
                        
                        Image(ImageName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(30)
                            .padding(.leading,8)
                        Text(TopicName)
                        Spacer()
                    }
                    
                    Text(TopicTitle)
                        .font(.system(.title, design: .rounded))
                        .padding(.leading,8)
                   // Spacer()
                    Text(Content)
                        .padding(.leading,8)
                    //Spacer()
                    Text(Date)
                        .padding(.leading,8)
                    Spacer()
                    HStack()
                    {
                        Image(systemName:"text.bubble")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("65")
                        Image(systemName:"heart")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.pink)
                            
                        Text("75")
                        
                    }
                    .padding([.leading, .bottom],8)
                    
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


struct Square_Previews: PreviewProvider
{
    static var previews: some View
    {
        Square(ImageName: "ka", TopicName: "Name", TopicTitle: "Title", Content: "Content", Date: "2020-05-12")
            {print("test")}
    }
}
