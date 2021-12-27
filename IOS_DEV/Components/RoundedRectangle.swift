//
//  RoundedRectangle.swift
//  new
//
//  Created by 張馨予 on 2021/3/18.
//

//import SwiftUI
//
//struct RoundedRectangle: View
//{
//    var ImageName:String = ""
//    var TopicName:String = ""
//    var TopicTitle:String = ""
//    var Content:String = ""
//    var Date:String = ""
//    var body: some View
//    {
//
//        //Button(action: {print("test")})
//        //{
//            HStack(spacing: 0)
//            {
//
//                NavigationLink(destination: MessageBoardView())
//                {
//                    Image(ImageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 140, height: 160)
//                    .clipped()
//                    //.overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 7)
//                    //.cornerRadius(30.0)
//                Spacer()
//                Spacer()
//                VStack(alignment:.leading)
//                {
//                    Spacer()
//                    HStack()
//                    {
//
//                        Image(ImageName)
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .cornerRadius(30)
//                        Text(TopicName)
//                        Spacer()
//                    }
//                    .padding(.top,15)
//
//                    Text(TopicTitle)
//                        .font(.system(.title, design: .rounded))
//                    //Spacer()
//                    Text(Content)
//                    //Spacer()
//                    Text(Date)
//                    Spacer()
//                    HStack()
//                    {
//
//                        Image(systemName:"text.bubble")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                        Text("65")
//                        Image(systemName:"heart")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.pink)
//
//                        Text("75")
//
//                    }
//                    .padding(.bottom,25)
//                }
//
//            }
//            .frame(width: 350, height: 160, alignment: .leading)
//            .background(Color.white)
//            .cornerRadius(25)
//            .shadow(color: .gray, radius: 2, x: 1.0, y: 1.0)
//            .padding([.leading, .bottom, .trailing], 20)
//                }
//
//        //}
//        .foregroundColor(.black)
//
//    }
//}
//
//struct RoundedRectangle_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//        RoundedRectangle(ImageName: "ha", TopicName: "Name",TopicTitle: "Title",Content: "Here is content",Date: "2021-03-18")
//        }
//    }
//}
