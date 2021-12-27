//
//  NewArticleCard.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/28.
//


import Foundation
import SwiftUI
import SDWebImageSwiftUI



struct NewArticleCard:View{
    @ObservedObject private var forumController = ForumController()
    @Binding var createAction : Bool
    @State var title : String
    @State var text : String
    @State var movieID : Int
    let FullSize = UIScreen.main.bounds.size

    var body:some View{

        ScrollView{

            VStack{
                Text("新增文章")
                    .font(.system(size: 20).bold())
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding([.top],30)
                Spacer(minLength: 0)
            }
            .padding([.top],40)
            
            Divider()
                .padding(.horizontal)

            //--------標題---------//
            VStack(alignment: .center, spacing: 15) {
                Text("文章標題")
                    .foregroundColor(.white)
                    .font(.system(size: 18))

                TextField("your title", text: $title )
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding()
                    .background(Color(.gray).opacity(0.1))

            }
            .padding()

            Divider()
                .padding(.horizontal)
            Spacer(minLength: 0)

            //--------內文---------//
            VStack(alignment: .center, spacing: 15) {
                Text("文章內容 ")
                    .foregroundColor(.white)
                    .font(.system(size: 18))

                TextEditor(text: $text )
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding()
                    .frame(height:300)
                    .background(Color(.gray).opacity(0.1))
                

            }
            .onAppear() {
                UITextView.appearance().backgroundColor = .clear
            }.onDisappear() {
                UITextView.appearance().backgroundColor = nil
            }
            .padding()



            //--------save button---------//

            HStack(spacing: 15) {
                Button(action: {
                    forumController.postArticle(Title: self.title, Text: self.text, movieID: movieID, userID: NowUserID!)
                    self.createAction.toggle()
                })
                {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(40)

                }
                .disabled(self.title == "" || self.text == "" ? true : false)
                .opacity(self.title == "" || self.text == "" ? 0.5 : 1)

                
                Button(action: {
                    self.createAction.toggle()
                })
                {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                    
                }


            }
            .padding()

        }
        .frame(height: FullSize.height)
        .background(Color.black.opacity(0.9))
        

    }

}

