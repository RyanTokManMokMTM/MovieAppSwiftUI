//
//  PostVM.swift
//  IOS_DEV
//
//  Created by Jackson on 17/7/2022.
//

import Foundation
import SwiftUI
//
//let initPostInfo = Post(id: 0, user_info: PosterOwner(id: 0, name: "", avatar: ""), post_title: "", post_desc: "", post_movie_info: PostMovieInfo(id: 0, title: "", poster_path: ""), post_like_count: 0, post_comment_count: 0, create_at: 0, is_post_liked: false)
@MainActor
class PostVM : ObservableObject {
    @Published var isPostUploading = false
//    @Published var uploadProgress : Double = 0
    @Published var isRefersh = false
    @Published var initAllData : Bool = true
    @Published var initFollowing : Bool = true
    @Published var postData : [Post] = [] //set to nil for first time
    @Published var followingData : [Post] = [] //set to nil for firs time
    @Published var index : TabItem = .Explore
    @Published var isShowPostDetail : Bool = false
    @Published var selectedPost : Post? // need this ?
//    @Published var selectedPostID : Int = -1
    @Published var selectedPostInfo : Post
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
        selectedPostInfo = Post(id: 0, user_info: PosterOwner(id: 0, name: "", avatar: ""), post_title: "", post_desc: "", post_movie_info: PostMovieInfo(id: 0, title: "", poster_path: ""), post_like_count: 0, post_comment_count: 0, create_at: 0, is_post_liked: false)
    }

    func CreatePost(title : String, desc : String,movie: Movie,user: Profile){
        let req = CreatePostReq(post_title: title, post_desc: desc, movie_id: movie.id)
        self.isLoading = true
        self.err = nil
        self.isPostUploading = true
        APIService.shared.CreatePost(req: req) { (result) in
            DispatchQueue.main.async { [self] in
                self.isLoading = false
                switch result{
                case .success(let data):
                    print(data)
                    Task.init{
                        await self.refershData()
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    self.err = err
                }
            }
        }
    }
    
    private func refershData() async {
        print("updateing....")
        let resp = await APIService.shared.AsyncGetFollowUserPost()
        self.isPostUploading = false
        APIService.shared.uploadProgress = 0
        switch resp {
        case .success(let data):
            self.followingData = data.post_info
            BenHubState.shared.AlertMessage(sysImg: "checkmark.circle.fill", message: "文章上傳成功")
        case .failure(let err):
            print("upload post err : \(err.localizedDescription)")
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func GetAllUserPost(onSucceed : @escaping ()->() , onFailed : @escaping  (_ errMsg : String)->()) {
        self.isGetPostLoading = true
        self.isGetPostErr = nil
        self.postData = []
        APIService.shared.GetAllUserPost(){result in
            DispatchQueue.main.async {
                self.isGetPostLoading = false
                switch result {
                case .success(let data):
                    print("Fetched!\(data)")
                    onSucceed()
                    for var info in data.post_info {
                        info.comments = [] //we will fetch the data when user press the comment
                        self.postData.append(info)
//                        self.followingData[0].post_comment_count = 0
                    }
//                    self.postData = data.post_info //not fetching!
                case .failure(let err):
//                    print("POST DATA")
//                    print(err.localizedDescription)
                    onFailed(err.localizedDescription)
                    self.isGetPostErr = err
                }
            }
        }
    }
    
    func GetFollowUserPost(onSucceed : @escaping ()->() , onFailed : @escaping  (_ errMsg : String)->()) {
        self.isGetFollowPostLoading = true
        self.isGetFollowPostErr = nil
        self.followingData = []
        APIService.shared.GetFollowUserPost(){result in
            DispatchQueue.main.async {
                self.isGetFollowPostLoading = false
                switch result {
                case .success(let data):
                    print("Fetched!\(data)")
                    onSucceed()
                    for var info in data.post_info {
                        info.comments = [] //we will fetch the data when user press the comment
                        self.followingData.append(info)
                    }
//                    self.followingData = data.post_info
                case .failure(let err):
//                    print("POST DATA")
                    print(err.localizedDescription)
                    self.isGetFollowPostErr = err
                    onFailed(err.localizedDescription)
                }
            }
        }
    }
    
    func getPostIndexFromFollowList(postId : Int) -> Int {
        let id  = self.followingData.firstIndex{
            $0.id == postId
        } ?? -1
        
        print(id)
        return id
    }
    
    func getPostIndexFromDiscoveryList(postId : Int) -> Int {
        return self.postData.firstIndex{
            $0.id == postId
        } ?? -1
    }

}
