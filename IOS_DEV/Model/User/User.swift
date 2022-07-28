//
//  User.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//

import Foundation


struct User: Decodable{
    var id: UUID
    var UserName: String
    var Email: String
    var Password: String
//    var UserPhoto: String
    var UserPhoto: String?
//
    var UserPhotoURL: URL {
        return URL(string:"\(baseUrl)/UserPhoto/\(UserPhoto ?? "")" )!
    }
}




class UserViewModel : ObservableObject{
    @Published var user : Me?//???
    @Published var profile : UserProfile?
    @Published var IsPostLoading : Bool = false
    @Published var IsLikedMovieLoading : Bool = false
    @Published var IsListLoading : Bool = false
    
    @Published var ListError : Error?
    @Published var PostError : Error?
    @Published var LikedError : Error?
    init(){
    }

    //set The UserInfo
    func setUserInfo(info userInfo : UserProfile){
        DispatchQueue.main.async {
            self.profile = userInfo
            self.profile!.UserGenrePrerences = []
        }
    }
    
    func getUserPosts() {
//        if self.profile!.UserCollection == nil {
//            self.profile!.UserCollection = []
//        }
        self.IsPostLoading = true
        APIService.shared.GetUserPostByUserID(userID: self.profile!.id){ result in
            DispatchQueue.main.async {
                self.IsPostLoading = false
                switch result{
                case .success(let data):
                    self.profile!.UserCollection = []
                    for var info in data.post_info{
                        info.comments = []
                        self.profile!.UserCollection!.append(info)
                    }
              
                case .failure(let err):
                    print("USER POST DATA")
                    print("USER ERR:\(err.localizedDescription)")
                    self.PostError = err
                }
            }
        }
    }
    
    func getUserLikedMovie() {
        self.IsLikedMovieLoading = true
        APIService.shared.GetAllUserLikedMoive(userID: self.profile!.id){ (result) in
            self.IsLikedMovieLoading = false
            switch result{
            case .success(let data):
                print(data)
                if data.liked_movies == nil{
                    self.profile!.UserLikedMovies = []
                }else{
                    self.profile!.UserLikedMovies = data.liked_movies!
                }
                self.ListError = nil
            case .failure(let err):
                print(err.localizedDescription)
                self.LikedError = err
            }
        }
    }

    func getUserList() {
        self.IsListLoading = true
        APIService.shared.GetAllCustomLists(userID: profile!.id){ (result) in
            self.IsListLoading = false
            switch result{
            case .success(let data):
                if data.lists == nil{
                    self.profile!.UserCustomList = []
                }else{
                    self.profile!.UserCustomList = data.lists!
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.ListError = err
            }
        }
    }
    

}


//
//struct UserInfo : Decodable{
//    var UID: UUID
//    var UserName: String
//    var Email: String
//    var Password: String
//    var UserPhoto: String?
//    var UserBackGround : String?
////
//    var UserPhotoURL: URL {
//        return URL(string:"\(baseUrl)/UserPhoto/\(UserPhoto ?? "")" )!
//    }
//
//    var UserBackGroundURL: URL {
//        return URL(string:"\(baseUrl)/UserPhoto/\(UserBackGround ?? "")" )!
//    }
//}
