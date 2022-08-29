//
//  HotTopicView.swift
//  IOS_DEV
//
//  Created by Jackson on 30/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
//
//struct HotTopicView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct CardPlaying : View{
//    var body : some View{
//        GeometryReader{proxy in
//            VStack(){
//                HStack{
//                    Text("MOVIE DETAILS")
//                        .bold()
//                        .font(.title)
//                        .ConcertOneRegularFont()
//                    Spacer()
//                }
//                    WebImage(url:  URL(string: "https://paintable.cc/wp-content/uploads/2020/07/Alan-DW-the-grudge-720x1024.jpg")!)
//                        .placeholder(Image(systemName: "photo")) //
//                        .resizable()
//                        .indicator(.activity)
//                        .transition(.fade(duration: 0.5))
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: UIScreen.main.bounds.height / 1.8)
//                        .clipShape(CustomeConer(width: 10, height: 10, coners: [.allCorners]))
//                        .padding(.top)
//                        .shadow(color: .gray, radius: 10)
//                        .overlay(
//                            VStack{
//                                Spacer()
//                                HStack{
//                                    Spacer()
//                                    Button(action:{
//
//                                    }){
//                                        HStack{
//                                            Text("Detail")
//                                                .foregroundColor(.white)
//                                        }
//                                        .padding(8)
//                                        .background(Color.blue)
//                                        .cornerRadius(25)
//                                    }
//                                        .padding(15)
//                                }
//                            }
//                        )
//
//                VStack(spacing:15){
//                        Text("The Grudge")
//                            .bold()
//
//                            .font(.title2)
//                        HStack(spacing:5){
//                            ForEach(0..<5){i in
//                                Image(systemName:"star.fill" )
//                                    .imageScale(.small)
//                                    .foregroundColor(i < 3 ? .orange : .gray)
//                            }
//                        }
//
//                        Text("An American nurse living and working in Tokyo is exposed to a mysterious supernatural curse, one that locks a person in a powerful rage before claiming their life and spreading to another victim.")
//                        .foregroundColor(Color(UIColor.gray))
//                            .font(.footnote)
//                            .lineLimit(3)
//                    }
//                    .padding(.top,20)
//                Spacer()
//
//            }
//            .frame(maxHeight:.infinity)
//                .padding(.top,proxy.safeAreaInsets.top)
//                .padding(.top,20)
//                .padding(.horizontal,20)
//                .background(
//                   WebImage(url: URL(string: "https://paintable.cc/wp-content/uploads/2020/07/Alan-DW-the-grudge-720x1024.jpg")!)
//
//                        .overlay(BlurView()  .ignoresSafeArea(.all, edges: .all)))
//                .ignoresSafeArea(.all, edges: .all)
//
//
//        }
//
//    }
//}
//
//struct HotTopicView_Previews: PreviewProvider {
//    static var previews: some View {
//        HotTopicView()
//    }
//}
