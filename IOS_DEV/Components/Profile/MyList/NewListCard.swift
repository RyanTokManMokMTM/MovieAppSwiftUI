//
//  NewListCard.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/7.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct NewListCard: View {
    @ObservedObject private var listController = ListController()
    @Binding var cardShown: Bool
    @Binding var title:String

    var body: some View {
        VStack{
            VStack{
                Text("List Title ")
                    .font(.system(size: 20).bold())

                TextField("list title", text: $title )
                    .font(.system(size: 20))
                    .background(Color(.gray).opacity(0.1))
                    
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            HStack{
                
                Button(action: {
                    listController.postList(title: self.title)
                    self.cardShown.toggle()
                })
                {
                    Text("Save")
                        .foregroundColor(.blue)
                        .padding()
                    
                }
                .disabled(self.title == "" ? true : false)
                .opacity(self.title == "" ? 0.5 : 1)
            
                
           
                Button(action: {
                    self.cardShown.toggle()
                })
                {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                    
                }
            
            }
            
        }
        .padding()
        .frame(width: screenSize.width*0.7, height: screenSize.height*0.24)
        .background(BlurView())
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: cardShown ? 0 : screenSize.height)
        .animation(.spring())
        
       
    
    }
}

//struct NewListCard_Previews: PreviewProvider {
//    static var previews: some View {
//        NewListCard(cardShown: .constant(true), title: .constant(""))
//
//
//    }
//}


//
//struct NewListCard:View{
//    @ObservedObject private var listController = ListController()
//    @State var cardShown : Bool = false
//    @State var cardColor : Color = Color("Blue")
//    @State private var title:String = " "
//
//
//    var body:some View{
//
//        VStack{
//
//            VStack{
//                Text("ADD NEW LIST")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.black)
//                Spacer(minLength: 0)
//            }
//            .padding([.top],40)
//
//            //--------title---------//
//            VStack(alignment: .center, spacing: 15) {
//                Text("List Title ")
//                    .foregroundColor(.black)
//                    .font(.system(size: 20).bold())
//
//                TextField("your title", text: $title )
//                    .font(.system(size: 22))
//                    .padding()
//                    .background(Color(.gray).opacity(0.1))
//
//            }
//            .padding()
//
//            Divider()
//                .padding(.horizontal)
//            Spacer(minLength: 0)
//
//            //--------color---------//
//            VStack(alignment: .center){
//                Text("Card Color")
//                    .foregroundColor(.black)
//                    .font(.system(size: 20).bold())
//
//                let colors = [Color("CustomBlue"),Color("CustomYellow"),Color("CustomPurple"),Color("CustomRed"),Color("CustomOrange"),Color("Gray")]
//
//                HStack(spacing: 12){
//                    ForEach(colors,id:\.self) { color in
//                        Circle()
//                            .fill(color)
//                            .frame(width: 35, height: 35)
//                            .overlay(
//                                Image(systemName: "checkmark")
//                                    .foregroundColor(.white)
//                                    .opacity(
//                                        cardColor == color ? 1 : 0
//                                    )
//                            )
//                            .onTapGesture {
//                                cardColor = color
//                            }
//                    }
//                }
//
//                Spacer(minLength: 0)
//            }
//            .padding()
//
//
//
//            //--------save button---------//
//
//            VStack(alignment: .center, spacing: 15) {
//                Button(action: {
//                    listController.postList(title: self.title)
//                })
//                {
//                    HStack{
//                        Image(systemName: "plus")
//
//                        Text("Add to my list")
//
//                    }
//                    .foregroundColor(.white)
//                    .padding([.horizontal],100)
//                    .padding([.vertical],13)
//                    .background(Color.black)
//                    .cornerRadius(40)
//
//                }
//                .disabled(self.title == " " ? true : false)
//                .opacity(self.title == " " ? 0.5 : 1)
//
//
//
//            }
//            .padding()
//
//        }
////        .background(Color.black.opacity(0.6))
//    }
//
//}
