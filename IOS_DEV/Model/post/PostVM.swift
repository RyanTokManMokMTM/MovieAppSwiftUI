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
    @Published var isSharePost = false
    @Published var sharedData : Post? = nil
    @Published var isPostUploading = false
    @Published var isRefersh = false
    
    //MARK: isMoreData to load?
    @Published var isFollowingLoadMore = false
    @Published var isAllLoadMore = false

//    @Published var isFetchMoreData : Bool = false
    @Published var discoverMetaData : MetaData?
    @Published var followingMetaData : MetaData?
    
    @Published var initAllData : Bool = true
    @Published var initFollowing : Bool = true
    
    @Published var postData : [Post] = [] //set to nil for first time
    @Published var followingData : [Post] = [] //set to nil for firs time
    @Published var index : TabItem = .Explore
    @Published var isShowPostDetail : Bool = false
    @Published var selectedPost : Post? // need this ?
    @Published var selectedPostInfo : Post
    @Published var selectedPostFrom : postDataFrom = .AllPost
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
                case .success(_):
                    Task.init{
                        await self.refershFollowingData()
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    self.err = err
                }
            }
        }
    }
    
    func refershFollowingData() async {
//        print("updateing....")
        let resp = await APIService.shared.AsyncGetFollowUserPost(limit:10)
        self.isPostUploading = false
        APIService.shared.uploadProgress = 0
        switch resp {
        case .success(let data):
            self.followingData = data.post_info
            self.followingMetaData = data.meta_data
        case .failure(let err):
            print("upload post err : \(err.localizedDescription)")
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func refershDiscoverData() async {
//        print("updateing....")
        let resp = await APIService.shared.AsyncGetAllUserPost(limit:10)
        switch resp {
        case .success(let data):
            self.postData = data.post_info
            self.discoverMetaData = data.meta_data
//            print(self.discoverMetaData)
        case .failure(let err):
            print("upload post err : \(err.localizedDescription)")
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
    }
    
    func LoadMoreDiscoverData() async {
        if self.discoverMetaData == nil || self.discoverMetaData!.total_pages == self.discoverMetaData!.page{
            return
        }
        self.isAllLoadMore = true
        
        let resp = await APIService.shared.AsyncGetAllUserPost(page: self.discoverMetaData!.page + 1,limit: 10)
        switch resp {
        case .success(let data):
                self.postData.append(contentsOf: data.post_info)

            self.discoverMetaData = data.meta_data
        case .failure(let err):
            print("loading more post(discovery) err : \(err.localizedDescription)")
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isAllLoadMore = false
    }
    
    func LoadMoreFollowingData() async {
        if self.followingMetaData == nil || self.followingMetaData!.total_pages == self.followingMetaData!.page{
            return
        }
//        print("loading more....")
        self.isFollowingLoadMore = true
        let resp = await APIService.shared.AsyncGetFollowUserPost(page: self.followingMetaData!.page + 1,limit: 10)
        switch resp {
        case .success(let data):
            print(data.post_info)
            self.followingData.append(contentsOf: data.post_info)
            self.followingMetaData = data.meta_data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFollowingLoadMore = data.meta_data.page < data.meta_data.total_pages
            }
        case .failure(let err):
            print("load post err : \(err.localizedDescription)")
            BenHubState.shared.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
        }
        
        self.isFollowingLoadMore = false
    }
    
    func GetAllUserPost(onSucceed : @escaping ()->() , onFailed : @escaping  (_ errMsg : String)->()) {
        self.isGetPostLoading = true
        self.isGetPostErr = nil
        self.postData = []
        APIService.shared.GetAllUserPost(limit:10){result in
            DispatchQueue.main.async {
                self.isGetPostLoading = false
                
                switch result {
                case .success(let data):
//                    print("Fetched!\(data)")
                    onSucceed()
                    for var info in data.post_info {
                        info.comments = [] //we will fetch the data when user press the comment
                        self.postData.append(info)
                    }
                    self.discoverMetaData = data.meta_data
                    print(data.meta_data)
                case .failure(let err):
                    onFailed(err.localizedDescription)
                    self.isGetPostErr = err
                    self.initAllData = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.initAllData = false
            }
        }
    }
    
    func GetFollowUserPost(onSucceed : @escaping ()->() , onFailed : @escaping  (_ errMsg : String)->()) {
        self.isGetFollowPostLoading = true
        self.isGetFollowPostErr = nil
        self.followingData = []
        APIService.shared.GetFollowUserPost(limit:10){result in
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
                    
                    self.followingMetaData = data.meta_data
//                    DispatchQueue.main
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isFollowingLoadMore = data.meta_data.page < data.meta_data.total_pages
                    }
                    
//                    print(self.followingMetaData)
                case .failure(let err):
//                    print("POST DATA")
                    print(err.localizedDescription)
                    self.isGetFollowPostErr = err
                    onFailed(err.localizedDescription)
                }
            }
        }
    }
    
    
    //TODO: Need to 2 function?
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
    
    
    func isAllPostLast(postID : Int) -> Bool {
        return self.postData.last?.id == postID
    }
    
    func isFolloingLast(postID : Int) -> Bool {
        return self.followingData.last?.id == postID
    }


}
