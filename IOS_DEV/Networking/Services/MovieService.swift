//
//  MovieService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//
// Interface, endpoint, error

import Foundation
import UIKit

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
    
    //TODO: USER
    func UserLogin(req : UserLoginReq,completion: @escaping (Result<UserLoginResp,Error>)->())
    func UserSignUp(req : UserSignInReq,completion : @escaping (Result<UserSignInResp,Error>)->())
    func GetUserProfile(token : String,completion : @escaping (Result<Profile,Error>) -> ())
    func GetUserProfileById(userID : Int,completion : @escaping (Result<Profile,Error>) -> ())
    func UpdateUserProfile(req : UserProfileUpdateReq, completion: @escaping (Result<UserProfileUpdateResp,Error>) -> ())
    func UploadImage(imgData : Data,uploadType: UploadImageType, completion: @escaping (Result<UploadImageResp,Error>) -> ())
    
    func CountFollowingUser(req: CountFollowingReq, completion : @escaping (Result<CountFollowingResp,Error>) -> ())
    func CountFollowedUser(req : CountFollowedReq, completion : @escaping (Result<CountFollowedResp,Error>) -> ())
    func GetUserFollowingList(req: GetFollowingListReq,completion : @escaping (Result<GetFollowingListResp,Error>) -> ())
    func GetUserFollowedList(req : GetFollowedListReq,completion : @escaping (Result<GetFollowedListResp,Error>) -> ())
    //Conennection check
    
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
    func GetAllCustomLists(userID : Int,completion : @escaping (Result<AllUserListResp,Error>) -> ())
    func GetUserList(listID : Int , completion : @escaping (Result<UserListResp,Error> ) -> ())
    func InsertMovieToList(movieID : Int, listID : Int, completion : @escaping (Result<InsertMovieToListResp,Error>)->())
    func RemoveMovieFromList(req : RemoveMovieFromListReq , completion: @escaping (Result<RemoveMovieFromListResp,Error>)->()) //???
    func GetOneMovieFromUserList(req : GetOneMovieFromUserListReq, completion : @escaping (Result<GetOneMovieFromUserListResp,Error>) -> ())
    
    //TODO: POST
    func CreatePost(req : CreatePostReq , completion : @escaping (Result<CreatePostResp,Error>) -> ())
    func GetAllUserPost(completion : @escaping (Result <AllUserPostResp,Error>) -> ())
    func GetFollowUserPost(completion : @escaping (Result <FollowingUserPostResp,Error>) -> ())
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
    func GetPostComments(postId : Int, completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    
    //TODO: REPLY COMMENT
    func CreateReplyComment(req : CreateReplyCommentReq, completion : @escaping (Result<CreateReplyCommentResp,Error>) -> ())
    func GetReplyComment(req : GetReplyCommentReq, completion : @escaping (Result<GetReplyCommentResp,Error>) -> ())
//    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ())
//    func GetPostComments(postId : Int, completion : @escaping (Result<GetPostCommentsResp,Error>) -> ())
    
    //TODO: COMMENT LIKES
    func CreateCommentLikes(req : CreateCommentLikesReq,completion : @escaping (Result<CreateCommentLikesResp,Error>) -> ())
    func RemoveCommentLikes(req : RemoveCommentLikesReq,completion : @escaping (Result<RemoveCommentLikesResp,Error>) -> ())
    func IsCommentLiked(req : IsCommentLikedReq,completion : @escaping (Result<IsCommentLikedResp,Error>) -> ())
    func CountCommentLikes(req : CountCommentLikesReq,completion : @escaping (Result<CountCommentLikesResp,Error>) -> ())
    
    //TODO: Friend
    func CreateNewFriend(req : CreateNewFriendReq, completion: @escaping (Result<CreateNewFriendResp,Error>) -> ())
    func RemoveFriend(req : RemoveFriendReq, completion: @escaping (Result<RemoveFriendResp,Error>) -> ())
    func GetOneFriend(req :GetOneFriendReq, completion: @escaping (Result<GetOneFriendResp,Error>) -> ())
    
    //TODO: MOVIE
    func GetMovieCardInfoByGenre(genre: GenreType, completion :@escaping (Result<MoviePageListByGenreResp, Error>) -> ())
    
    func GetMovieLikedCount(req : CountMovieLikesReq, completion: @escaping (Result<CountMovieLikesResp,Error>) -> ())
    func GetMovieCollectedCount(req : CountMovieCollectedReq,completion: @escaping (Result<CountMovieCollectedResp,Error>) -> ())
    
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
    case CountFollowingUser
    case CountFollowedUser
    case GetUserFollowingList
    case GetUserFollowedList
    
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
    case CreateNewFriend
    case RemoveFriend
    case GetOneFriend
    
    //MARK: USER GENRES
    case UpdateUserGenre
    case GetUserGenre
    
    var apiUri : String{
        switch self {
        case .HealthCheck: return "/ping"
            
        //User Service
        case .UserLogin: return "/user/login"
        case .UserSignup: return "/user/signup"
        case .UserProfile: return "/user/profile"
        case .UserInfo: return "/user/info/" //"/user/info/:id"
        case .UserUpdateProfile: return "/user/profile"
        case .CountFollowingUser: return "/user/following/" //user_id
        case .CountFollowedUser: return "/user/followed/" //user_Id
        case .GetUserFollowingList : return "/user/following/list/"
        case .GetUserFollowedList : return "/user/followed/list/"
            
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
        
            
        case .CreateNewFriend: return "/friend"
        case .RemoveFriend: return "/friend"
        case .GetOneFriend: return "/friend/" //:friend_id
            
        case .UpdateUserGenre: return "/user/genres"
        case .GetUserGenre: return "/user/genres/"

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

