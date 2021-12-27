//
//  FavoriteController.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
class FavoriteController: ObservableObject {

    let favoriteService = FavoriteService()
    @Published var MovieData:[LikeMovie] = []
    @Published var ArticleData:[LikeArticle] = []
    @Published var favorite:[CheckLike] = []
    
    //---------------------取得LikeMovie---------------------//
    func GetLikeMovie(userID : UUID){
        favoriteService.GET_likeMovie(endpoint: "/likeMovie/my/\(userID)"){ (result) in
            switch result {
            case .success(let lists):
                print("get all MovieData")
                self.MovieData = lists
                
            case .failure: print("MovieData failed")
            }
        }
    }
    //---------------------取得LikeArticle---------------------//
    func GetLikeArticle(userID : UUID){
        favoriteService.GET_likeArticle(endpoint: "/likeArticle/my/\(userID)"){ [self] (result) in
            switch result {
            case .success(let lists):
                print("get all ArticleData")
                self.ArticleData = lists
                
            case .failure(let lists):
                print("ArticleData failed")
                print(lists)
            }
        }
    }
    
    //---------------------新增LikeMovie---------------------//
    func PostLikeMovie(movie:Int,title:String,posterPath:String){
      
        let data = NewLikeMovie(userID: NowUserID!, movie: movie, title: title, posterPath: posterPath)
        
        favoriteService.POST_likeMovie(endpoint: "/likeMovie/new", RegisterObject: data){ (result) in
            switch result {
                case 200 :
                    print("post LikeMovie success")
                default:
                    print("post LikeMovie failed")
            }
            
        }
    }
    
    
    //---------------------新增LikeArticle---------------------//
    func PostLikeArticle(articleID:UUID){
      
        let data = NewLikeArticle(userID: NowUserID!, articleID: articleID)
        favoriteService.POST_likeArticle(endpoint: "/likeArticle/new", RegisterObject: data){ (result) in
            switch result {
                case 200 :
                    print("post LikeArticle success")
                default:
                    print("post LikeArticle failed")
                    print(result)
            }
            
        }
    }
    
    //---------------------刪除喜好電影---------------------//
    func deleteLikeMovie(movieID:Int){
        
        
        favoriteService.CHECK_likeMovie(endpoint: "/likeMovie/check/\(NowUserID!)/\(movieID)"){ [self] (result) in
            switch result {
                case .success(let res):
                    print("check LikeMovie success")
                    favoriteService.DELETE_like(endpoint:  "/likeMovie/delete/\((res.first?.id)!)"){ (result) in
                        switch result {
                        case 200 :
                            print("delete Favorite success")

                        default:
                            print("delete Favorite failed")
                        }
                    }
                   
                case .failure:
                    print("check LikeMovie failed")
            }

        }
        
    }
    
    
    //---------------------刪除喜好文章---------------------//
    func deleteLikeArticle(FavoriteID: UUID){
      
        favoriteService.DELETE_like(endpoint:  "/likeArticle/delete/\(FavoriteID)"){ (result) in
            switch result {
            case 200 :
                print("delete Favorite success")

            default:
                print("delete Favorite failed")
            }
            
        }
    }
    
    //---------------------檢查likeArticle---------------------//
    func CheckLikeArticle(articleID:UUID){
      
        favoriteService.CHECK_likeArticle(endpoint: "/likeArticle/check/\(NowUserID!)/\(articleID)"){ (result) in
            switch result {
                case .success(let res):
                    print("check LikeArticle success")
                    self.favorite = res
                case .failure:
                    print("check LikeArticle failed")
                    print(result)
            }
            
        }
    }
    
    //---------------------檢查likeMovie---------------------//
    func CheckLikeMovie(movieID:Int){

        favoriteService.CHECK_likeMovie(endpoint: "/likeMovie/check/\(NowUserID!)/\(movieID)"){ (result) in
            switch result {
                case .success(let res):
                    print("check LikeMovie success")
                    self.favorite = res
                case .failure:
                    print("check LikeMovie failed")
                    print(result)
            }

        }
    }


}
