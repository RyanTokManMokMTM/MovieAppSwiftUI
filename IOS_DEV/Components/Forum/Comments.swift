//
//  Comments.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/3.
//

import SwiftUI
import SDWebImageSwiftUI

struct Comments: View
{
    var comment:Comment
    @ObservedObject private var forumController = ForumController()
    @State private var isMyFavorite = false
    var heartImage:String{
        if isMyFavorite{
            return "heart.fill"
        }
        else{
            return "heart"
        }
    }
    
    var heartCount:Int{
        if isMyFavorite{
            return comment.LikeCount+1
        }
        else{
            return comment.LikeCount
        }
    }
    
    var body: some View
    {
        
            HStack(spacing:0)
            {
                VStack(alignment:.leading)
                {
                    //Spacer()
                    HStack()
                    {
                
                        WebImage(url: comment.user!.user_avatarURL)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(30)
                            .padding(.leading,15)
                        Text(comment.user!.UserName)
                        Spacer()
                        
                        VStack(alignment: .trailing,spacing:5)
                        {
                            HStack(){
                                
                  
                                
                                Text(comment.dateText)
                                    .padding(5)
                                    .foregroundColor(.gray)
                                
                                Button(action:{
                                    self.isMyFavorite.toggle()
                                    forumController.PutComment(CommentID: comment.id!, LikeCount: heartCount, Text: comment.Text)
                                }){
                                    Image(systemName:heartImage)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.pink)

                                }

                                Text("\(heartCount)")
                                
                        
                            }
                            .font(.footnote)
                            .padding([.trailing],10)
                            
                        }
                        
                        
                    }
  
                    Text(comment.Text)
                        .font(.body)
                        .padding(20)
                        
                        
                        
                        
                 
                    
                    
                    Divider()//分隔線
                        .background(Color.gray)
                       
                    
                    
                    
                }
                
            }
    }
}

//struct MessageBoard_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//
//
//        MessageBoard(article: MList.first!)
//
//
//    }
//}
