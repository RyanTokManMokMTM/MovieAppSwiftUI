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
    
    //friendNotificationCount
    //LikeNotificationCount
    //CommentNotificationCount
//    var UserPhoto: String
    var UserPhoto: String?
//
    var UserPhotoURL: URL {
        return URL(string:"\(baseUrl)/UserPhoto/\(UserPhoto ?? "")" )!
    }
}

class UserViewModel : ObservableObject{
//    @Published var user : Me?//???
    @Published var isInit = true
    @Published var isAllowToScroll = false
    @Published var isLogIn : Bool = false
    @Published var profile : Profile?
    @Published var userID : Int?
    
    @Published var postCurPage : Int = 1
    @Published var postTotalPage : Int = 1
    
    @Published var likedCurPage : Int = 1
    @Published var likedTotalPage : Int = 1
    
    @Published var listCurPage : Int = 1
    @Published var listTotalPage : Int = 1
    
    @Published var IsPostLoading : Bool = false
    @Published var IsLikedMovieLoading : Bool = false
    @Published var IsListLoading : Bool = false
    @Published var IsUpdating : Bool = false
    @Published var IsUploading : Bool = false
    @Published var isLoadingProfile : Bool = false
    @Published var isUserGenresLoading : Bool = false
    @Published var isUserGenresUpdating : Bool = false
    
    @Published var ListError : Error?
    @Published var PostError : Error?
    @Published var LikedError : Error?
    @Published var UpdateError : Error?
    @Published var UploadError : Error?
    @Published var fetchProfileError : Error?
    @Published var fetchUserGenreError : Error?
    @Published var updateUserGenreError : Error?
    
    @Published var isEditName : Bool = false
    @Published var isEditAvarar : Bool = false
    @Published var isEditCover : Bool = false

    init(){
        
    }
    
    func setUserID(userID : Int){
        self.userID = userID
    }

    //Use for other user
    func getUserProfile(){
        if self.userID == nil{
            return
        }
        
        self.isLoadingProfile = true
        self.fetchProfileError = nil
        APIService.shared.GetUserProfile(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print("GET USER PROFILE SUCCEED")
                DispatchQueue.main.async {
                    self.profile = data
    //                self.profile!.UserGenrePrerences = []
                    self.isLoadingProfile = false
                }
                print(data)
            case .failure(let err):
                print("????")
                self.fetchProfileError = err
                print(err.localizedDescription)
            }
        }
        
    }
    
    @MainActor
    func AsyncGetProfile(userID : Int) async {
        let resp = await APIService.shared.AsyncGetUserProfileById(userID: userID)
        switch resp {
        case .success(let data):

            self.profile = data
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
    }
    
    @MainActor
    func AsyncGetPost(userID : Int) async {
        self.postCurPage = 1
        let resp = await APIService.shared.AsyncGetUserPostByUserID(userID: userID,page: self.postCurPage)
        switch resp {
        case .success(let data):
//            userVM.profil
//            self.postTotalPage = dat
            print(data)
            self.postCurPage = data.meta_data.page
            self.postTotalPage = data.meta_data.total_pages
            print(data.meta_data)
            self.profile!.UserCollection = []
            guard let posts = data.post_info else {
                return
            }

            for var info in posts{
                info.comments = []
                self.profile!.UserCollection!.append(info)
            }
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
    }
    
    @MainActor
    func AsyncGetMorePost(userID : Int) async {
        if self.postCurPage >= self.postTotalPage {
            return
        }
        self.IsPostLoading = true
        self.postCurPage += 1
        let resp = await APIService.shared.AsyncGetUserPostByUserID(userID: userID,page: self.postCurPage)
        switch resp {
        case .success(let data):
            self.postCurPage = data.meta_data.page
            self.postTotalPage = data.meta_data.total_pages
            guard let posts = data.post_info else {
                return
            }
            
            if self.profile!.UserCollection != nil {
                for var info in posts{
                    info.comments = []
                    self.profile!.UserCollection!.append(info)
                }
                
            } else {
                self.profile!.UserCollection = []
            }

        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
        
        self.IsPostLoading = false
    }
    
    func getUserProfileByID(){
        if self.userID == nil{
            return
        }
        
        self.isLoadingProfile = true
        self.fetchProfileError = nil
        APIService.shared.GetUserProfileById(userID: self.userID!){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.profile = data
    //                self.profile!.UserGenrePrerences = []
                    self.isLoadingProfile = false
                    print(data)
                    self.GetUserGenresSetting()
                }
                print("GET USER PROFILE SUCCEED")
            case .failure(let err):
                print("????")
                self.fetchProfileError = err
                print(err.localizedDescription)
            }
        }
        
    }
    
    //set The UserInfo
    func setUserInfo(info userInfo : Profile){
        DispatchQueue.main.async {
            self.profile = userInfo
            self.setUserID(userID: self.profile!.id)
            self.profile!.UserGenrePrerences = []
        }
    }
    
    func getUserPosts() {
        if self.userID == nil{
            return
        }
        
        print(userID!)
        self.IsPostLoading = true
        APIService.shared.GetUserPostByUserID(userID: self.userID!){ [weak self]  result in
            guard let self = self else { return }
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
        if self.userID == nil{
            return
        }
        self.IsLikedMovieLoading = true
        APIService.shared.GetAllUserLikedMoive(userID: self.userID!){ [weak self] (result) in
            guard let self = self else { return }
            self.IsLikedMovieLoading = false
            switch result{
            case .success(let data):
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
    
    @MainActor
    func AsyncGetUserLikedMoive(userID : Int) async {
        self.listCurPage = 1
        let resp = await APIService.shared.AsyncGetAllUserLikedMoive(userID: userID,page : self.listCurPage)
        switch resp {
        case .success(let data):
            self.likedCurPage = data.meta_data.page
            self.likedTotalPage = data.meta_data.total_pages
            print(data.meta_data)
            if data.liked_movies == nil{
                self.profile!.UserLikedMovies = []
            }else{
                self.profile!.UserLikedMovies = data.liked_movies!
            }
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
    }
    
    @MainActor
    func AsyncGetMoreUserLikedMoive(userID : Int) async {
        if self.likedCurPage >= self.likedTotalPage {
            return
        }
        
        self.IsLikedMovieLoading = true
        self.listCurPage += 1
        let resp = await APIService.shared.AsyncGetAllUserLikedMoive(userID: userID,page : self.listCurPage)
        switch resp {
        case .success(let data):
            self.likedCurPage = data.meta_data.page
            self.likedTotalPage = data.meta_data.total_pages
            guard let likedMovie = data.liked_movies else {
                return
            }
            
            if self.profile!.UserLikedMovies != nil {
                self.profile!.UserLikedMovies!.append(contentsOf: likedMovie)
            }else {
                self.profile!.UserLikedMovies = likedMovie
            }

        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
        
        self.IsLikedMovieLoading = false
    }
    
    func getUserList() {
        if self.userID == nil{
            return
        }
        
        self.IsListLoading = true
        self.ListError = nil
        APIService.shared.GetAllCustomLists(userID: self.userID!){ [weak self]  (result) in
            guard let self = self else { return }
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
    
    @MainActor
    func AsyncGetUserList(userID : Int) async{
        self.listCurPage = 1
        let resp = await APIService.shared.AsyncGetAllCustomLists(userID: userID,page : self.listCurPage)
        switch resp {
        case .success(let data):
            self.listCurPage = data.meta_data.page
            self.listTotalPage = data.meta_data.total_pages
            if data.lists == nil{
                self.profile!.UserCustomList = []
            }else{
                self.profile!.UserCustomList = data.lists!
            }
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
    }
    
    @MainActor
    func AsyncGetMoreUserList(userID : Int) async{
        if self.listCurPage >= self.listTotalPage {
            return
        }
        self.IsListLoading = true
        self.listCurPage += 1
        let resp = await APIService.shared.AsyncGetAllCustomLists(userID: userID,page : self.listCurPage)
        switch resp {
        case .success(let data):
            self.listCurPage = data.meta_data.page
            self.listTotalPage = data.meta_data.total_pages
            guard let list = data.lists else {
                return
            }
            
            if self.profile!.UserCustomList != nil {
                self.profile!.UserCustomList!.append(contentsOf: list)
            }else {
                self.profile!.UserCustomList = list
            }
        case .failure(let err):
            print(err.localizedDescription)
            BenHubState.shared.AlertMessage(sysImg: "xmark", message: err.localizedDescription)
        }
        
        self.IsListLoading = false
    }
    
    
    func UpdateUserProfile(name : String) {
        let req = UserProfileUpdateReq(name: name)
        self.IsUpdating = true
        self.UpdateError = nil
        APIService.shared.UpdateUserProfile(req: req){ [weak self] (result) in
            guard let self = self else { return }
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
        
        APIService.shared.UploadImage(imgData: imgData, uploadType: .Avatar){ [weak self]result in
            guard let self = self else { return }
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
        
        APIService.shared.UploadImage(imgData: imgData, uploadType: .Cover){ [weak self] result in
            guard let self = self else { return }
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
    
    func IsOwner(userID : Int) -> Bool{
        return self.userID! == userID
    }
    
    func GetUserGenresSetting(){
        self.isUserGenresLoading = true
        self.fetchUserGenreError = nil
        
        let req = GetUserGenreReq(user_id: self.userID!)
        APIService.shared.GetUserGenres(req: req){result in
            self.isUserGenresLoading = false
            switch result{
            case .success(let data):
                if self.profile == nil{
                    print("something wrong...")
                }
                self.profile!.UserGenrePrerences = data.user_genres
            case .failure(let err):
                self.fetchUserGenreError = err
                print(err.localizedDescription)
            }
        }
    }
    
    func UpdateUserGenresSetting(genreIds : [Int],onSuccess : @escaping ()->()){
        self.isUserGenresUpdating = true
        self.updateUserGenreError = nil
        
        let req = UpdateUserGenreReq(genre_ids: genreIds)
        

        APIService.shared.UpdateUserGenre(req: req){result in
            DispatchQueue.main.async {
                self.isUserGenresUpdating = false
                switch result{
                case .success(_):
                    print("updated user genres")
                    onSuccess()
                case .failure(let err):
                    self.updateUserGenreError = err
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func GetPostIndex(postId : Int) -> Int{
//        print("collection ??\(self.profile!.UserCollection == nil)")
        if self.profile!.UserCollection == nil {
            return -1
        }
        
        return self.profile!.UserCollection!.firstIndex{$0.id == postId} ?? -1
    }
    
    func GetPreferenceIds() -> [Int]{
        if self.profile!.UserGenrePrerences == nil || self.profile!.UserGenrePrerences!.isEmpty {
            return []
        }
        
        var ids : [Int] = []
        for genre in self.profile!.UserGenrePrerences!{
            ids.append(genre.id)
        }
        
        return ids
    }
    
    
    
    
    func isLastPost(postID : Int) -> Bool {
        return self.profile?.UserCollection?.last?.id == postID
    }
    
    func isLastLikedMovie(movieID : Int) -> Bool {
        return self.profile?.UserLikedMovies?.last?.id == movieID
    }
    
    func isLastList(listID : Int) -> Bool {
        return self.profile?.UserCustomList?.last?.id == listID
    }
    
    func isLastListMovie(movieID : Int, listID : Int) -> Bool {
        return self.profile?.UserCustomList?[listID].movie_list?.last?.id == movieID
    }
    
}
