//
//  TopicFrame.swift
//
//  Created by 張馨予 on 2021/3/18.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopicFrame: View
{
    var article:Article
//    var commentData:[Comment]
    
    var body: some View
    {
        
            
            HStack(spacing: 0)
            {
            
//                    Image("ka")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 140, height: 160)
//                    .clipped()
//                    //.overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 7)
//                    //.cornerRadius(30.0)
//                    Spacer()
                    Spacer()
                    VStack(alignment:.leading)
                    {
                        Spacer()
                        HStack()
                        {
                            WebImage(url: article.user?.user_avatarURL)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(30)
                            
                            Text(article.user!.UserName)
                            Spacer()
                        }
              
                    
                        Text(article.Title)
                            .font(.system(size:20, design: .rounded))
                            .bold()
                        
                        //Spacer()
                        Text(article.Text)
                            .font(.system(size:17))
                            .foregroundColor(.gray)
                           
                        
                        Spacer()
                        HStack()
                        {
                        
//                            Image(systemName:"text.bubble")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                            Text("65")
                            Text(article.dateText)
                                .foregroundColor(.gray)
                            
                            Image(systemName:"heart")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.pink)
                            
                            Text("\(article.LikeCount)")
                        
                        }
                        .padding(.bottom,10)
                        .font(.footnote)
                    }
                    .padding(10)

        }
        .frame(width: UIScreen.main.bounds.size.width-25, height: 160, alignment: .leading)
        .foregroundColor(.white).background(Color(hue: 1.0, saturation: 0.0, brightness: 0.144, opacity: 0.329))
        .shadow(color: .gray, radius: 0.5)
        .cornerRadius(20)
        .padding([.leading, .trailing], 20)
        .padding([.bottom], 5)
   
        
            
        }
            
        
}

//struct TopicFrame_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//            TopicFrame(topicc: TList.first!)
//        }
//    }
//}
