//
//  PostVM.swift
//  IOS_DEV
//
//  Created by Jackson on 17/7/2022.
//

import Foundation
import SwiftUI


class PostVM : ObservableObject {
    @Published var postData : [Post] = [] //set to nil for first time
    @Published var followingData : [Post] = [] //set to nil for firs time
    @Published var index : TabItem = .Explore
    @Published var isShowPostDetail : Bool = false
    @Published var selectedPost : Post?
//    
    @Published var isReadMorePostInfo : Bool = false
    @Published var selectedReadMorePost : Post? = nil
    
    @Published var isLoading : Bool = false
    @Published var err : Error?
    
    @Published var isGetPostLoading : Bool = false
    @Published var isGetPostErr : Error?
    
    @Published var isGetFollowPostLoading : Bool = false
    @Published var isGetFollowPostErr : Error?
    
    init(){
//        self.GetAllUserPost()
//        self.GetFollowUserPost()
    }

    func CreatePost(title : String, desc : String,movie: Movie,user: Profile){
        let req = CreatePostReq(post_title: title, post_desc: desc, movie_id: movie.id)
        self.isLoading = true
        self.err = nil
        APIService.shared.CreatePost(req: req) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result{
                case .success(let data):
//                    print(data)
                    
                    let newPost = Post(id: data.id, user_info: PosterOwner(id: user.id, name: user.name, avatar: user.avatar), post_title: title, post_desc: desc, post_movie_info: PostMovieInfo(id: movie.id, title: movie.title, poster_path: movie.posterPath), post_like_count: 0, post_comment_count: 0, create_at: data.create_time, comments: [])
                    
                    self.followingData.insert(newPost, at: 0)
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    self.err = err
                }
            }
        }
    }
    
    func GetAllUserPost() {
        self.isGetPostLoading = true
        self.isGetPostErr = nil
        self.postData = []
        APIService.shared.GetAllUserPost(){result in
            DispatchQueue.main.async {
                self.isGetPostLoading = false
                switch result {
                case .success(let data):
                    print("Fetched!\(data)")
                    for var info in data.post_info {
                        info.comments = [] //we will fetch the data when user press the comment
                        self.postData.append(info)
                    }
//                    self.postData = data.post_info //not fetching!
                case .failure(let err):
//                    print("POST DATA")
//                    print(err.localizedDescription)
                    self.isGetPostErr = err
                }
            }
        }
    }
    
    func GetFollowUserPost() {
        self.isGetFollowPostLoading = true
        self.isGetFollowPostErr = nil
        self.followingData = []
        APIService.shared.GetFollowUserPost(){result in
            DispatchQueue.main.async {
                self.isGetFollowPostLoading = false
                switch result {
                case .success(let data):
                    print("Fetched!\(data)")
                    for var info in data.post_info {
                        info.comments = [] //we will fetch the data when user press the comment
                        self.followingData.append(info)
                    }
//                    self.followingData = data.post_info
                case .failure(let err):
//                    print("POST DATA")
//                    print(err.localizedDescription)
                    self.isGetFollowPostErr = err
                }
            }
        }
    }
}
