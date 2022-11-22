//
//  MovieService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//
// Interface, endpoint, error

import Foundation
import UIKit
import SwiftUI

protocol MovieService {
    //User Service
//    func GetUserInfo(id : Int ,com)
//    func UserProfile(completion: @escaping (Result<UserProfile,Error>)->())
    
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    func fetchMovieWithEng(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    func MovieReccomend(id: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    
    func searchRecommandMovie(query: String, completion: @escaping (Result<MovieSearchResponse, MovieError>) -> ())
    func searchMovieInfo(query: String,page:Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func searchPerson(query: String, completion: @escaping (Result<PersonResponse, MovieError>) -> ())
    func GenreType(genreID: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovieImages(id: Int, completion: @escaping (Result<MovieImages, MovieError>) -> ())
    func fetchMovieResource(query: String, completion: @escaping (Result<[ResourceResponse], MovieError>) -> ())
}

protocol ServerAPIServerServiceInterface {
    //TODO: HELPER
    func serverConnection(completion : @escaping (Result<ServerStatus,Error>)->())
    func asyncServerConnection() async -> Result<ServerStatus,Error>
    
    //TODO: USER
    func UserLogin(req : UserLoginReq,completion: @escaping (Result<UserLoginResp,Error>)->())
    func UserSignUp(req : UserSignUpReq,completion : @escaping (Result<UserSignUpResp,Error>)->())
    func GetUserProfile(completion : @escaping (Result<Profile,Error>) -> ())
    func GetUserProfileById(userID : Int,completion : @escaping (Result<Profile,Error>) -> ())
    func AsyncGetUserProfileById(userID : Int) async -> Result<Profile,Error>
    func UpdateUserProfile(req : UserProfileUpdateReq, completion: @escaping (Result<UserProfileUpdateResp,Error>) -> ())
    func UploadImage(imgData : Data,uploadType: UploadImageType, completion: @escaping (Result<UploadImageResp,Error>) -> ())
        
    func CountFriend(req : CountFriendReq,completion: @escaping (Result<CountFriendResp,Error>)->())
    func GetFriendList(req : GetFriendListReq,completion: @escaping (Result<GetFriendListResp,Error>)->())
    func GetFriendRoomList(completion: @escaping (Result<GetFriendRoomListResp,Error>)->())
    
    func ResetFriendNotification(completion: @escaping (Result<ResetFriendNotificationResp,Error>)->())
    func ResetCommentNotification(completion: @escaping (Result<ResetCommentNotificationResp,Error>)->())
    func ResetLikesNotification(completion: @escaping (Result<ResetLikesNotificationResp,Error>)->())
//    func CountFollowingUser(req: CountFollowingReq, completion : @escaping (Result<CountFollowingResp,Error>) -> ())
//    func CountFollowedUser(req : CountFollowedReq, completion : @escaping (Result<CountFollowedResp,Error>) -> ())
//    func GetUserFollowingList(req: GetFollowingListReq,completion : @escaping (Result<GetFollowingListResp,Error>) -> ())
//    func GetUserFollowedList(req : GetFollowedListReq,completion : @escaping (Result<GetFollowedListResp,Error>) -> ())
    //Conennection check
    
    //TODO: USER GENRES SETTING
    func UpdateUserGenre(req : UpdateUserGenreReq, completion : @escaping (Result<UpdateUserGenreResp,Error>) -> ())
    func GetUserGenres(req : GetUserGenreReq,completion : @escaping (Result<GetUserGenreResp,Error>) -> ())
    
    //TODO: LIKED MOVIE
    func PostLikedMovie(req:NewUserLikeMoviedReq,completion : @escaping (Result<CreateUserLikedMovieResp,Error>) -> ())
    func DeleteLikedMovie(req : DeleteUserLikedMovie,completion : @escaping (Result<DeleteUserLikedMovieResp,Error>) -> ())
    func GetAllUserLikedMoive(userID : Int, completion : @escaping (Result<AllUserLikedMovieResp,Error>) -> ())
    func AsyncGetAllUserLikedMoive(userID : Int) async -> Result<AllUserLikedMovieResp,Error>
    
    func IsLikedMovie(req : IsLikedMovieReq , completion: @escaping (Result<IsLikedMovieResp,Error>) -> ())

    //TODO: CUSTOM LIST
    func CreateCustomList(req : CreateNewCustomListReq ,completion : @escaping (Result<CreateNewCustomListResp,Error>) -> ())
    func UpdateCustomList(req : UpdateCustomListReq, completion : @escaping (Result<UpdateCustomListResp,Error>) -> ())
    func DeleteCustomList(req : DeleteCustomListReq, completion : @escaping (Result<DeleteCustomListResp,Error>) -> ())
    func GetAllCustomLists(userID : Int, page : Int,limit : Int,completion : @escaping (Result<AllUserListResp,Error>) -> ())
    func AsyncGetAllCustomLists(userID : Int, page : Int,limit : Int) async -> Result<AllUserListResp,Error>
    
    func GetUserList(listID : Int , completion : @escaping (Result<UserListResp,Error> ) -> ())
    func InsertMovieToList(movieID : Int, listID : Int, completion : @escaping (Result<InsertMovieToListResp,Error>)->())
    func RemoveMovieFromList(req : RemoveMovieFromListReq , completion: @escaping (Result<RemoveMovieFromListResp,Error>)->()) //???
    func GetOneMovieFromUserList(req : GetOneMovieFromUserListReq, completion : @escaping (Result<GetOneMovieFromUserListResp,Error>) -> ())
    func GetCollectedMovieCount(userID : Int) async -> Result<GetCollectedMovieResp,Error>
    
    //TODO: POST
    func CreatePost(req : CreatePostReq,completion : @escaping (Result<CreatePostResp,Error>) -> ())
    
    func GetAllUserPost(page : Int ,limit : Int ,completion : @escaping (Result <AllUserPostResp,Error>) -> ())
    //MARK: Async Version
    func AsyncGetAllUserPost(page : Int ,limit : Int) async -> Result<AllUserPostResp,Error>
    
    func GetFollowUserPost( page : Int ,limit : Int ,completion : @escaping (Result <FollowingUserPostResp,Error>) -> ())
    //Async Version
    func AsyncGetFollowUserPost( page : Int ,limit : Int) async -> Result <FollowingUserPostResp,Error>
    func GetUserPostByUserID(userID : Int ,completion : @escaping (Result <UserPostResp,Error>) -> ())
    func AsyncGetUserPostByUserID(userID : Int) async -> Result <UserPostResp,Error>
    func CountUserPosts(req : CountUserPostReq, completion : @escaping (Result<CountUserPostResp,Error>) -> ())
    
    //TODO: POST LIKED
    func CreatePostLikes(req : CreatePostLikesReq,completion : @escaping (Result<CreatePostLikesResp,Error>) -> ())
    func RemovePostLikes(req : RemovePostLikesReq,completion : @escaping (Result<RemovePostLikesResp,Error>) -> ())
    func IsPostLiked(req : IsPostLikedReq,completion : @escaping (Result<IsPostLikedResp,Error>) -> ())
    func CountPostLikes(req : CountPostLikesReq,completion : @escaping (Result<CountPostLikesResp,Error>) -> ())
    
    //TODO: POST COMMENT
    func CreatePostComment(postId : Int,req : CreateCommentReq, completion : @escaping (Result<CreateCommentResp,Error>) -> ())
    func UpdatePostComment(commentId : Int, req : UpdateCommentReq, completion : @escaping (Result<UpdateCommentResp,Error>) -> ())
    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ())
    func GetPostComments(postId : Int, page : Int ,limit : Int ,completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    
    //TODO: REPLY COMMENT
    func CreateReplyComment(req : CreateReplyCommentReq, completion : @escaping (Result<CreateReplyCommentResp,Error>) -> ())
    func GetReplyComment(req : GetReplyCommentReq,  page : Int,limit : Int ,completion : @escaping (Result<GetReplyCommentResp,Error>) -> ())
//    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ())
//    func GetPostComments(postId : Int, completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    
    //TODO: COMMENT LIKES
    func CreateCommentLikes(req : CreateCommentLikesReq,completion : @escaping (Result<CreateCommentLikesResp,Error>) -> ())
    func RemoveCommentLikes(req : RemoveCommentLikesReq,completion : @escaping (Result<RemoveCommentLikesResp,Error>) -> ())
    func IsCommentLiked(req : IsCommentLikedReq,completion : @escaping (Result<IsCommentLikedResp,Error>) -> ())
    func CountCommentLikes(req : CountCommentLikesReq,completion : @escaping (Result<CountCommentLikesResp,Error>) -> ())
    
    //TODO: Friend -Updated
    func AddFriend(req : AddFriendReq, completion: @escaping (Result<AddFriendResp,Error>) -> ())
    func RemoveFriend(req : RemoveFriendReq, completion: @escaping (Result<RemoveFriendResp,Error>) -> ())
    func AccepctFriendRequest(req : FriendRequestAccecptReq, completion: @escaping (Result<FriendRequestAcceptResp,Error>) -> ())
    func DeclineFriendRequest(req : FriendRequestDeclineReq, completion: @escaping (Result<FriendRequestDeclineResp,Error>) -> ())
    func CancelFriendRequest(req : FriendRequestCancelReq, completion: @escaping (Result<FriendRequestCancelResp,Error>) -> ())
    func GetFriendRequest(page : Int,limit : Int,completion: @escaping (Result<GetFriendRequestListResp,Error>) -> ())
    func AsyncGetFriendRequest(page : Int,limit : Int) async -> Result<GetFriendRequestListResp,Error>
    
    //MARK: Need a api check is friend
    func IsFriend(req : IsFriendReq,completion: @escaping (Result<IsFriendResp,Error>) -> ())

    //TODO: MOVIE
    func GetMovieCardInfoByGenre(genre: GenreType, completion :@escaping (Result<MoviePageListByGenreResp, Error>) -> ())
    
    func GetMovieLikedCount(req : CountMovieLikesReq, completion: @escaping (Result<CountMovieLikesResp,Error>) -> ())
    func GetMovieCollectedCount(req : CountMovieCollectedReq,completion: @escaping (Result<CountMovieCollectedResp,Error>) -> ())
    
    
    //TODO: Group/Room
    func CreateRoom(req : CreateRoomReq,completion: @escaping (Result<CreateRoomResp,Error>) -> ())
    func DeleteRoom(req : DeleteRoomReq,completion: @escaping (Result<DeleteRoomResp,Error>) -> ())
    func JoinRoom(req : JoinRoomReq,completion: @escaping (Result<JoinRoomResp,Error>) -> ())
    func LeaveRoom(req : LeaveRoomReq,completion: @escaping (Result<LeaveRoomResp,Error>) -> ())
    func GetRoomMember(req : GetRoomMembersReq,completion: @escaping (Result<GetRoomMembersResp,Error>) -> ())
    func GetUserRooms(completion: @escaping (Result<GetUserRoomsResp,Error>) -> ())
    func GetRoomInfo(req : GetRoomInfoReq,completion: @escaping (Result<GetRoomInfoResp,Error>) -> ())
    func SetIsRead(req : SetIsReadReq,completion: @escaping (Result<SetIsReadResp,Error>) -> ())
    
    
    //TODO: Message
    func GetRoomMessage(req : GetRoomMessageReq, page : Int ,limit : Int ,completion: @escaping (Result<GetRoomMessageResp,Error>) -> ())
    
    //TODO: Notification
    func GetLikesNotification( page : Int ,limit : Int ,completion: @escaping (Result<GetLikesNotificationsResq,Error>) -> ())
    func AsyncGetLikesNotification( page : Int ,limit : Int ) async -> Result<GetLikesNotificationsResq,Error>
    
    func GetCommentNotification( page : Int ,limit : Int ,completion: @escaping (Result<GetCommentNotificationsResq,Error>) -> ())
    func AsyncGetCommentNotification( page : Int ,limit : Int) async -> Result<GetCommentNotificationsResq,Error>
    
    //Searching and playground
//    TODO - Person data format
    func fetchActors(page : Int ,completion : @escaping (Result<PersonInfoResponse,Error>) ->  ())
    func fetchDirectors(page : Int ,completion : @escaping (Result<PersonInfoResponse,Error>) -> ())
    
//    TODO - Genre with description image of a referencing movie
    func fetchGenreById(genreID id :Int, dataSize size : Int , completion : @escaping (Result<GenreInfoResponse,Error>) -> ())
    func fetchAllGenres(completion : @escaping (Result<GenreInfoResponse,Error>) -> ())
    
    //TODO -Preview API
    func getPreviewMovie(datas : [SearchRef],completion : @escaping (Result<[MoviePreviewInfo],Error>) -> ())

    func getPreviewMovieList(completion : @escaping (Result<[MoviePreviewInfo],Error>) -> ())

    //TODO -Search API
    func getRecommandtionSearch(query key: String,completion : @escaping (Result<Movie,Error>)-> ())
    func getHotSeachingList(completion : @escaping (Result<[SearchHotItem],Error>)->())

    
//    TODO -TrailerAPI
    func getMovieTrailerList(page : Int,completing : @escaping (Result<[TrailerInfo],Error>)->())
    
}

protocol AsyncServerAPIServerServiceInterface {
    //TODO: HELPER
//    func serverConnection(completion : @escaping (Result<ServerStatus,Error>)->())
    func AsyncServerConnection() async -> Result<ServerStatus,Error>
    
    //TODO: USER
//    func UserLogin(req : UserLoginReq,completion: @escaping (Result<UserLoginResp,Error>)->())
    func AsyncUserLogin(req : UserLoginReq) async -> Result<UserLoginResp,Error>
    func AsyncUserSignUp(req : UserSignUpReq) async -> Result<UserSignUpResp,Error>
    func AsyncGetUserProfile() async -> Result<Profile,Error>
    func AsyncGetUserProfileById(userID : Int) async -> Result<Profile,Error>
    func AsyncUpdateUserProfile(req : UserProfileUpdateReq) async -> Result<UserProfileUpdateResp,Error>
    func AsyncUploadImage(imgData : Data,uploadType: UploadImageType) async -> Result<UploadImageResp,Error>
        
    
    func CountFriend(req : CountFriendReq,completion: @escaping (Result<CountFriendResp,Error>)->())
    func GetFriendList(req : GetFriendListReq,completion: @escaping (Result<GetFriendListResp,Error>)->())
    func GetFriendRoomList(completion: @escaping (Result<GetFriendRoomListResp,Error>)->())
    
    func ResetFriendNotification(completion: @escaping (Result<ResetFriendNotificationResp,Error>)->())
    func ResetCommentNotification(completion: @escaping (Result<ResetCommentNotificationResp,Error>)->())
    func ResetLikesNotification(completion: @escaping (Result<ResetLikesNotificationResp,Error>)->())

    
    //TODO: USER GENRES SETTING
    func UpdateUserGenre(req : UpdateUserGenreReq, completion : @escaping (Result<UpdateUserGenreResp,Error>) -> ())
    func GetUserGenres(req : GetUserGenreReq,completion : @escaping (Result<GetUserGenreResp,Error>) -> ())
    
    //TODO: LIKED MOVIE
    func PostLikedMovie(req:NewUserLikeMoviedReq,completion : @escaping (Result<CreateUserLikedMovieResp,Error>) -> ())
    func DeleteLikedMovie(req : DeleteUserLikedMovie,completion : @escaping (Result<DeleteUserLikedMovieResp,Error>) -> ())
    func GetAllUserLikedMoive(userID : Int, completion : @escaping (Result<AllUserLikedMovieResp,Error>) -> ())
    
    func IsLikedMovie(req : IsLikedMovieReq , completion: @escaping (Result<IsLikedMovieResp,Error>) -> ())

    //TODO: CUSTOM LIST
    func CreateCustomList(req : CreateNewCustomListReq ,completion : @escaping (Result<CreateNewCustomListResp,Error>) -> ())
    func UpdateCustomList(req : UpdateCustomListReq, completion : @escaping (Result<UpdateCustomListResp,Error>) -> ())
    func DeleteCustomList(req : DeleteCustomListReq, completion : @escaping (Result<DeleteCustomListResp,Error>) -> ())
    func GetAllCustomLists(userID : Int, page : Int,limit : Int,completion : @escaping (Result<AllUserListResp,Error>) -> ())
    func GetUserList(listID : Int , completion : @escaping (Result<UserListResp,Error> ) -> ())
    func InsertMovieToList(movieID : Int, listID : Int, completion : @escaping (Result<InsertMovieToListResp,Error>)->())
    func RemoveMovieFromList(req : RemoveMovieFromListReq , completion: @escaping (Result<RemoveMovieFromListResp,Error>)->()) //???
    func GetOneMovieFromUserList(req : GetOneMovieFromUserListReq, completion : @escaping (Result<GetOneMovieFromUserListResp,Error>) -> ())
    
    //TODO: POST
    func CreatePost(req : CreatePostReq , completion : @escaping (Result<CreatePostResp,Error>) -> ())
    
    func GetAllUserPost( page : Int ,limit : Int ,completion : @escaping (Result <AllUserPostResp,Error>) -> ())
    //MARK: Async Version
    
    func GetFollowUserPost( page : Int ,limit : Int ,completion : @escaping (Result <FollowingUserPostResp,Error>) -> ())
    func GetUserPostByUserID(userID : Int ,completion : @escaping (Result <UserPostResp,Error>) -> ())
    func CountUserPosts(req : CountUserPostReq, completion : @escaping (Result<CountUserPostResp,Error>) -> ())
    
    //TODO: POST LIKED
    func CreatePostLikes(req : CreatePostLikesReq,completion : @escaping (Result<CreatePostLikesResp,Error>) -> ())
    func RemovePostLikes(req : RemovePostLikesReq,completion : @escaping (Result<RemovePostLikesResp,Error>) -> ())
    func IsPostLiked(req : IsPostLikedReq,completion : @escaping (Result<IsPostLikedResp,Error>) -> ())
    func CountPostLikes(req : CountPostLikesReq,completion : @escaping (Result<CountPostLikesResp,Error>) -> ())
    
    //TODO: POST COMMENT
    func CreatePostComment(postId : Int,req : CreateCommentReq, completion : @escaping (Result<CreateCommentResp,Error>) -> ())
    func UpdatePostComment(commentId : Int, req : UpdateCommentReq, completion : @escaping (Result<UpdateCommentResp,Error>) -> ())
    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ())
    func GetPostComments(postId : Int, page : Int ,limit : Int ,completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    func AsyncGetPostComments(postId : Int, page : Int ,limit : Int) async -> Result<GetPostCommentsResp,Error>
    
    //TODO: REPLY COMMENT
    func CreateReplyComment(req : CreateReplyCommentReq, completion : @escaping (Result<CreateReplyCommentResp,Error>) -> ())
    func GetReplyComment(req : GetReplyCommentReq,  page : Int,limit : Int ,completion : @escaping (Result<GetReplyCommentResp,Error>) -> ())
    func AsyncGetReplyComment(req : GetReplyCommentReq,  page : Int,limit : Int) async -> Result<GetReplyCommentResp,Error>
//    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ())
//    func GetPostComments(postId : Int, completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    
    //TODO: COMMENT LIKES
    func CreateCommentLikes(req : CreateCommentLikesReq,completion : @escaping (Result<CreateCommentLikesResp,Error>) -> ())
    func RemoveCommentLikes(req : RemoveCommentLikesReq,completion : @escaping (Result<RemoveCommentLikesResp,Error>) -> ())
    func IsCommentLiked(req : IsCommentLikedReq,completion : @escaping (Result<IsCommentLikedResp,Error>) -> ())
    func CountCommentLikes(req : CountCommentLikesReq,completion : @escaping (Result<CountCommentLikesResp,Error>) -> ())
    
    //TODO: Friend -Updated
    func AddFriend(req : AddFriendReq, completion: @escaping (Result<AddFriendResp,Error>) -> ())
    func RemoveFriend(req : RemoveFriendReq, completion: @escaping (Result<RemoveFriendResp,Error>) -> ())
    func AccepctFriendRequest(req : FriendRequestAccecptReq, completion: @escaping (Result<FriendRequestAcceptResp,Error>) -> ())
    func DeclineFriendRequest(req : FriendRequestDeclineReq, completion: @escaping (Result<FriendRequestDeclineResp,Error>) -> ())
    func CancelFriendRequest(req : FriendRequestCancelReq, completion: @escaping (Result<FriendRequestCancelResp,Error>) -> ())
    func GetFriendRequest(page : Int,limit : Int,completion: @escaping (Result<GetFriendRequestListResp,Error>) -> ())
    
    //MARK: Need a api check is friend
    func IsFriend(req : IsFriendReq,completion: @escaping (Result<IsFriendResp,Error>) -> ())

    //TODO: MOVIE
    func GetMovieCardInfoByGenre(genre: GenreType, completion :@escaping (Result<MoviePageListByGenreResp, Error>) -> ())
    
    func GetMovieLikedCount(req : CountMovieLikesReq, completion: @escaping (Result<CountMovieLikesResp,Error>) -> ())
    func GetMovieCollectedCount(req : CountMovieCollectedReq,completion: @escaping (Result<CountMovieCollectedResp,Error>) -> ())
    
    
    //TODO: Group/Room
    func CreateRoom(req : CreateRoomReq,completion: @escaping (Result<CreateRoomResp,Error>) -> ())
    func DeleteRoom(req : DeleteRoomReq,completion: @escaping (Result<DeleteRoomResp,Error>) -> ())
    func JoinRoom(req : JoinRoomReq,completion: @escaping (Result<JoinRoomResp,Error>) -> ())
    func LeaveRoom(req : LeaveRoomReq,completion: @escaping (Result<LeaveRoomResp,Error>) -> ())
    func GetRoomMember(req : GetRoomMembersReq,completion: @escaping (Result<GetRoomMembersResp,Error>) -> ())
    func GetUserRooms(completion: @escaping (Result<GetUserRoomsResp,Error>) -> ())
    func GetRoomInfo(req : GetRoomInfoReq,completion: @escaping (Result<GetRoomInfoResp,Error>) -> ())
    func SetIsRead(req : SetIsReadReq,completion: @escaping (Result<SetIsReadResp,Error>) -> ())
    
    
    //TODO: Message
    func GetRoomMessage(req : GetRoomMessageReq, page : Int ,limit : Int ,completion: @escaping (Result<GetRoomMessageResp,Error>) -> ())
    func AsyncGetRoomMessage(req : GetRoomMessageReq, page : Int ,limit : Int) async -> Result<GetRoomMessageResp,Error>
    //TODO: Notification
    func GetLikesNotification( page : Int ,limit : Int ,completion: @escaping (Result<GetLikesNotificationsResq,Error>) -> ())
    func GetCommentNotification( page : Int ,limit : Int ,completion: @escaping (Result<GetCommentNotificationsResq,Error>) -> ())
    
    //Searching and playground
//    TODO - Person data format
    func fetchActors(page : Int ,completion : @escaping (Result<PersonInfoResponse,Error>) ->  ())
    func fetchDirectors(page : Int ,completion : @escaping (Result<PersonInfoResponse,Error>) -> ())
    
//    TODO - Genre with description image of a referencing movie
    func fetchGenreById(genreID id :Int, dataSize size : Int , completion : @escaping (Result<GenreInfoResponse,Error>) -> ())
    func fetchAllGenres(completion : @escaping (Result<GenreInfoResponse,Error>) -> ())
    
    //TODO -Preview API
    func getPreviewMovie(datas : [SearchRef],completion : @escaping (Result<[MoviePreviewInfo],Error>) -> ())

    func getPreviewMovieList(completion : @escaping (Result<[MoviePreviewInfo],Error>) -> ())

    //TODO -Search API
    func getRecommandtionSearch(query key: String,completion : @escaping (Result<Movie,Error>)-> ())
    func getHotSeachingList(completion : @escaping (Result<[SearchHotItem],Error>)->())

    
//    TODO -TrailerAPI
    func getMovieTrailerList(page : Int,completing : @escaping (Result<[TrailerInfo],Error>)->())
    
}
enum MovieListEndpoint: String, CaseIterable, Identifiable {

    var id: String { rawValue }

    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    case trending
    
    var description: String {
        switch self {
            case .nowPlaying: return "/movie/now_playing"
            case .upcoming: return "/movie/upcoming"
            case .topRated: return "/movie/now_playing"
            case .popular: return "/movie/popular"
            case .trending: return "/trending/movie/day"
        }
    }
}

enum UploadImageType : String,CaseIterable,Identifiable {
    var id : String { rawValue }
    case Avatar
    case Cover
    
    var uploadURI: String {
        switch self{
        case .Avatar: return "/user/avatar"
        case .Cover: return "/user/cover"
        }
    }
}

//Get API URI
enum APIEndPoint : String,CaseIterable, Identifiable{
    var id : String { rawValue }
    case HealthCheck
    
    //MARK: USER API
    case UserLogin //Done
    case UserSignup //Done
    case UserProfile //Done
    case UserInfo //Haven't test yet
    case UserUpdateProfile
    case CountFriend
    case GetFriendList
    case GetFriendRoomList
    case ResetFriendNotification
    case ResetCommentNotification
    case ResetLikesNotification
//    case CountFollowingUser
//    case CountFollowedUser
//    case GetUserFollowingList
//    case GetUserFollowedList
    
    //MARK: LIKED MOVIE API
    case CreateLikedMovie
    case DeleteLikedMovie
    case GetAllLikedMovie
    case IsLikedMovie
    
    //MARK: CustomList API
    case CreateCustomList
    case UpdateCustomList
    case DeleteCustomList
    case GetAllUserLists
    case GetUserList
    case AddMovieToList
    case RemoveMovieFromList
    case GetOneMovieFromUserList
    case GetCollectedMovieCount
    
    //MARK: Create post API
    case CreatePost //Done
    case UpdatePost //Done
    case DeletPost //Done
    case GetAllPosts //Done
    case GetFollowingPosts
    case GetUserPosts // Done
    case CountUserPosts //Done
    
    //MARK: LIKED POST API
    case CreatePostLikes
    case RemovePostLikes
    case IsPostLiked
    case CountPostLikes
    
    //MARK: Movie API
    case GetMoviesInfoByGenre //Done
    case GetMovieGenrensByMovieID
    case GetMovieDetail
    case GetMovieLikedCount
    case GetMovieCollectedCount
    
    //MARK: PostComment
    case CreateComment
    case UpdateComment
    case DeleteComment
    case GetPostComment
    
    //MARK: Reply Comment
    case CreateReplyComment
    case GetReplyComment
    
    //MARK: LIKED COMMENT API
    case CreateCommentLikes
    case RemoveCommentLikes
    case IsCommentLiked
    case CountCommentLikes
    
    //MARK: Friend API
    case AddFriend
    case RemoveFriend
    case AcceptFriendRequest
    case DeclineFriendRequest
    case CancelFriendRequest
    case GetFriendRequest
    case IsFriend
    
    //MARK: USER GENRES
    case UpdateUserGenre
    case GetUserGenre
    
    //MARK: Room
    case CreateRoom
    case DeleteRoom
    case JoinRoom
    case LeaveRoom
    case GetRoomMember
    case GetUserRooms
    case GetRoomInfo
    case SetIsRead
    
    //MARK: Message
    case GetRoomMessage
    
    //MARK: Notification
    case GetLikesNotification
    case GetCommentNotification
    
    var apiUri : String{
        switch self {
        case .HealthCheck: return "/ping"
            
        //User Service
        case .UserLogin: return "/user/login"
        case .UserSignup: return "/user/signup"
        case .UserProfile: return "/user/profile"
        case .UserInfo: return "/user/info/" //"/user/info/:id"
        case .UserUpdateProfile: return "/user/profile"
        case .CountFriend: return "/user/friends/count/" //user/friends/count/:id
        case .GetFriendList: return "/user/friends/list/" //user/friends/list/:id
        case .GetFriendRoomList: return "/user/friends/room"
        case .ResetLikesNotification: return "/user/reset/likes/notification"
        case .ResetFriendNotification: return "/user/reset/friend/notification"
        case .ResetCommentNotification: return "/user/reset/comment/notification"

            
        case .GetMoviesInfoByGenre: return "/movies/list/"
        case .GetMovieGenrensByMovieID: return "/movies/genres/"
        case .GetMovieDetail: return "/movies/" //movie_id
        case .GetMovieLikedCount: return "/movie/count/liked/" //movie_id
        case .GetMovieCollectedCount: return "/movie/count/collected/" //movie_id
            
        case .CreateLikedMovie: return "/liked/movie"
        case .DeleteLikedMovie: return "/liked/movie"
        case .GetAllLikedMovie: return "/liked/movies/" //user_id
        case .IsLikedMovie: return "/liked/movie/" //movie_id
            
        case .CreateCustomList: return "/lists" //list/:list_id/movie/:movie_id
        case .UpdateCustomList: return "/lists" //list/:list_id/movie/:movie_id
        case .DeleteCustomList: return "/lists" //list/:list_id/movie/:movie_id
        case .GetAllUserLists: return "/lists/" //user_id
        case .GetUserList: return "/list/" //list_id
        case .GetOneMovieFromUserList: return "/list/movie/" //movie_id
        case .GetCollectedMovieCount: return "/list/movies/count/"
        
        case .AddMovieToList: return "/list/" // listID/movie/:movieID
        case .RemoveMovieFromList: return "/list/" // /list/:list_id/movie/:movie_id
            
        case .CreatePost: return "/posts"
        case .UpdatePost: return "/posts"
        case .DeletPost: return "/posts"
        case .GetAllPosts: return "/posts/all"
        case .GetFollowingPosts: return "/posts/follow"
        case .GetUserPosts: return "/posts/" // postID
        case .CountUserPosts: return "/posts/count/" //:user_id
            
        case .CreatePostLikes: return "/liked/post"
        case .RemovePostLikes: return "/liked/post"
        case .IsPostLiked: return "/liked/post/"
        case .CountPostLikes: return "/liked/post/count/"
            
        case .CreateComment: return "/comments/" //postID
        case .UpdateComment: return "/comments/" //postID
        case .DeleteComment: return "/comments/" //postID
        case .GetPostComment: return "/comments/" //postID
            
        case .CreateReplyComment: return "/comments/" //comments/:post_id/reply/:comment_id
        case .GetReplyComment: return "/comments/reply/" //comments/reply/:comment_id
            
        case .CreateCommentLikes: return "/liked/comment"
        case .RemoveCommentLikes: return "/liked/comment"
        case .IsCommentLiked: return "/liked/comment/"
        case .CountCommentLikes: return "/liked/comment/count/"
        

        case .AddFriend: return "/friend"
        case .RemoveFriend : return "/friend"
        case .AcceptFriendRequest: return "/friend/request/accept"
        case .DeclineFriendRequest: return "/friend/request/decline"
        case .CancelFriendRequest: return "/friend/request/cancel"
        case .GetFriendRequest: return "/friend/requests"
        case .IsFriend: return "/friend/" //friend/:id
            
        case .UpdateUserGenre: return "/user/genres"
        case .GetUserGenre: return "/user/genres/"
            
        case .CreateRoom: return "/room"
        case .DeleteRoom: return "/room"
        case .JoinRoom: return "/room/join/" //room/join/:id
        case .LeaveRoom: return "/room/leave/" //room/leave/:id
        case .GetRoomMember: return "/room/members/" //room/members/:id
        case .GetUserRooms: return "/room/rooms"
        case .SetIsRead: return "/room/" //room/:id/read
        case .GetRoomInfo: return "/room/" //room/:id
        case .GetRoomMessage: return "/message/"

        case .GetLikesNotification: return "/notification/likes"
        case .GetCommentNotification: return "/notification/comments"
        }
    }
}


//Custom error ....
enum MovieError: Error, CustomNSError {

    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }

    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }

}


enum APIError : Error,CustomNSError{
    case badUrl
    case badResponse
    case badEncoding
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .badUrl: return "Invalid URL"
        case .badResponse: return "Get a bad response"
        case .badEncoding: return "Failed to encode data"
        }
    }

    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

