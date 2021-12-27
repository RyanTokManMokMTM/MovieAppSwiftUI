//
//  Message_Board.swift
//  IOS_DEV
//
//  Created by 張馨予 on 2021/5/1.
//

import SwiftUI
import SDWebImageSwiftUI


struct MessageBoard: View
{
    @State private var texts=""
    @State private var isMyFavorite = false
    var article:Article
    @State var comments:[Comment]
    let commentService = CommentService()
    @ObservedObject private var forumController = ForumController()
    @ObservedObject private var favoriteController = FavoriteController()
    @State private var favoriteID:UUID?
    
    var heartImage:String{
        if isMyFavorite{
            return "heart.fill"
        }
        else{
            return "heart"
        }
    }
    
    var like_heartCount:Int{    //原本已在喜愛項目
        if isMyFavorite{
            return article.LikeCount
        }
        else{
            return article.LikeCount-1
        }
    }
    
    var dislike_heartCount:Int{     //原本不在喜愛項目
        if isMyFavorite{
            return article.LikeCount+1
        }
        else{
            return article.LikeCount
        }
    }
    
    var heartCount:Int{             //判斷是否在喜愛項目
        if favoriteID != nil {
            return like_heartCount
        }
        else{
            return dislike_heartCount
        }
    }

    
    var body: some View
    {
   
        VStack(alignment:.leading)
        {
            //Spacer()
            HStack()
            {
                
                WebImage(url: article.user?.user_avatarURL)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .cornerRadius(30)
                    .padding(.leading,15)
                
                Text(article.user!.UserName)
                Spacer()
            }
         
    
            Text(article.Title)
                .font(.system(.title, design: .rounded))
                .bold()
                .padding(25)
             
         
        
            Text(article.Text)
                .font(.body)
                .padding(25)
                

            
            HStack()
            {
                Text(article.timeText)
                    .padding(25)
                    .foregroundColor(.gray)

                Button(action:{
                    self.isMyFavorite.toggle()
                    
                    if isMyFavorite == false {
                        favoriteController.deleteLikeArticle(FavoriteID: favoriteID!)
                        forumController.PutArticle(articleID: article.id!, Title: article.Title, Text: article.Text, LikeCount: article.LikeCount-1)
                    }else{
                        favoriteController.PostLikeArticle(articleID: article.id!)
                        forumController.PutArticle(articleID: article.id!, Title: article.Title, Text: article.Text, LikeCount: article.LikeCount+1)
                    }
                        
                }){
                    Image(systemName:heartImage)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.pink)

                }

                Text("\(heartCount)")
            }
            .font(.footnote)
           
            Divider()//分隔線
                .background(Color.gray)


            
            ForEach(self.comments ,id: \.id) { comment in
                Comments(comment: comment)
            }
            
            
            
            
            HStack
            {
                TextField("your contents...", text: $texts)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: { PostComment() })
                {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                        .offset(x: -10)
                }

            }
  
            
        }
        .onAppear{
            self.favoriteController.CheckLikeArticle(articleID: article.id!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if !self.favoriteController.favorite.isEmpty {
                    self.isMyFavorite = true
                    self.favoriteID = (favoriteController.favorite.first?.id)!
                }
            })
        }
            
    }
    
    
    //-----------------------------------------新增留言功能-----------------------------------------//
    func PostComment(){
        
        let com = CommentTodo(Text: self.texts, UserName: NowUserName, ArticleID: article.id!.uuidString , LikeCount: 0)
       
        print(com)
        commentService.POSTrequest(endpoint: "/comment", RegisterObject: com){(result) in
            //print(result)
            switch result {
           
            case .success: print("PostComment success")
                commentService.GETrequest(endpoint: "/comment/\(article.id!)"){(result) in
                    //print(result)
                    switch result {
                    case .success(let comments):
                        print("updated comment")
                        self.comments = comments
                        self.texts=""   //  clear textfield

                    case .failure: print("comment failed")
                    }
                }

            case .failure: print("PostComment failed")
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
