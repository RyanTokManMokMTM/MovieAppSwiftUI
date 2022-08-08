//
//  User.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//

import Foundation
import SwiftUI


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
    @Published var profile : Profile?
    @Published var IsPostLoading : Bool = false
    @Published var IsLikedMovieLoading : Bool = false
    @Published var IsListLoading : Bool = false
    @Published var IsUpdating : Bool = false
    @Published var IsUploading : Bool = false
    
    @Published var ListError : Error?
    @Published var PostError : Error?
    @Published var LikedError : Error?
    @Published var UpdateError : Error?
    @Published var UploadError : Error?
    
    @Published var isEditName : Bool = false
    @Published var isEditAvarar : Bool = false
    @Published var isEditCover : Bool = false
    
    

    init(){
    }

    //set The UserInfo
    func setUserInfo(info userInfo : Profile){
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
                    guard let posts = data.post_info else {
                        return
                    }
                   
                    for var info in posts{
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
        self.ListError = nil
        APIService.shared.GetAllCustomLists(userID: profile!.id){ (result) in
            DispatchQueue.main.async {
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
    
    func UpdateUserProfile(name : String) {
        let req = UserProfileUpdateReq(name: name)
        self.IsUpdating = true
        self.UpdateError = nil
        APIService.shared.UpdateUserProfile(req: req){ (result) in
            DispatchQueue.main.async {
                self.IsUpdating = false
                
                switch result{
                case .success( _):
                    self.profile!.name = name
                    withAnimation{
                        self.isEditName = false
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    self.UpdateError = err
                }
            }
        }
        
    }
    func UploadUserAvatar(uiImage : UIImage) {
        guard let imgData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("image to jpegData failed")
            return
        }
        
        self.IsUploading = true
        self.UpdateError = nil
        
        APIService.shared.UploadImage(imgData: imgData, uploadType: .Avatar){ result in
            self.IsUploading = false
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    self.profile!.avatar = data.path
                case .failure(let err):
                    print(err.localizedDescription)
                    self.UploadError = err
                }
            }
        }
    }
    
    func UploadUserCover(uiImage : UIImage) {
        guard let imgData = uiImage.jpegData(compressionQuality: 0.5) else {
            print("image to jpegData failed")
            return
        }
        
        self.IsUploading = true
        self.UpdateError = nil
        
        APIService.shared.UploadImage(imgData: imgData, uploadType: .Cover){ result in
            self.IsUploading = false
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    self.profile!.cover = data.path
                case .failure(let err):
                    print(err.localizedDescription)
                    self.UploadError = err
                }
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
