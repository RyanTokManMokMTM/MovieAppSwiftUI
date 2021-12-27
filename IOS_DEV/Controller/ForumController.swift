//
//  ForumController.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//

import Foundation

class ForumController: ObservableObject {
    
    let commentService = CommentService()   //post comment
    let articleService = ArticleService() //get
    @Published var commentData:[Comment] = []
    @Published var articleData:[Article] = []
   
    //--------------------------------get某電影的討論區文章--------------------------------//
    func GetAllArticle(movieID:Int){
        articleService.GET_allArticle(endpoint: "/article/\(movieID)"){(result) in
            //print(result)
            switch result {
            case .success(let res):
                print("article success")
                self.articleData = res

            case .failure:
                print("article failed")
            }
        }
    }
    
    //--------------------------------get我發的討論區文章--------------------------------//
    func GetMyArticle(userID:UUID){
        articleService.GET_allArticle(endpoint: "/article/my/\(userID)"){ [self](result) in
            //print(result)
            switch result {
            case .success(let res):
                print("my article success")
                self.articleData = res

            case .failure:
                print("my article failed")
            }
        }
    }
    
    //---------------------新增討論區的文章---------------------//
    func postArticle(Title:String, Text: String, movieID: Int, userID: UUID){
      
        let new = NewArticle(Title: Title, Text: Text, movieID: movieID, userID: userID)
        articleService.POST_Article(endpoint: "/article/new",RegisterObject: new ){ (result) in
            switch result {
            case .success(let result):
                print("post article success")
                print(result)

            case .failure:
                print("post article failed")
            }
            
        }

    }
    //---------------------更新文章---------------------//
    func PutArticle(articleID: UUID, Title: String, Text: String,LikeCount:Int){
      
        let update = UpdateArticle(articleID: articleID, Title: Title, Text: Text, LikeCount: LikeCount)
        articleService.PUT_Article(endpoint: "/article/update",RegisterObject: update ){ (result) in
            switch result {
            case 200 :
                print("put article success")

            default:
                print("put article failed")
            }
            
        }

    }
    
    //---------------------刪除文章---------------------//
    func DeleteArticle(articleID: UUID){
      
        articleService.DELETE_Article(endpoint: "/article/delete/\(articleID)"){ (result) in
            switch result {
            case 200 :
                print("delete article success")

            default:
                print("delete article failed")
            }
            
        }
    }
    
    
    
    //---------------------get留言---------------------//
    func articleDetails(articleID:UUID){
        commentService.GETrequest(endpoint: "/comment/\(articleID)"){(result) in
            //print(result)
            switch result {
            case .success(let comments):
                print("comment success")
                self.commentData = comments

            case .failure(let comments):
                print("comment failed")
                print(comments)
            }
        }
    }
    
    
    //---------------------編輯留言---------------------//
    func PutComment(CommentID: UUID, LikeCount: Int, Text: String){
      
        let update = UpdateComment(CommentID: CommentID, Text: Text, LikeCount: LikeCount)
        commentService.PUT_Comments(endpoint: "/comment/update",RegisterObject: update ){ (result) in
            switch result {
            case 200 :
                print("put comment success")

            default:
                print("put comment failed")
            }
            
        }

    }
    
    //---------------------刪除留言---------------------//
    func DeleteComment(commentID: UUID){
      
        commentService.DELETE_Comments(endpoint: "/comment/delete/\(commentID)"){ (result) in
            switch result {
            case 200 :
                print("delete comment success")

            default:
                print("delete comment failed")
            }
            
        }
    }
}

