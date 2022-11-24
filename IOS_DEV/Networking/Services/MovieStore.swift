//
//  MovieStore.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//
// MovieService concrete implementation

import Foundation
import SwiftUI
import BottomSheet


let SERVER_HOST = "http://ec2-18-138-229-136.ap-southeast-1.compute.amazonaws.com:8000"
let SERVER_WS = "ws://ec2-18-138-229-136.ap-southeast-1.compute.amazonaws.com:8000/ws"

class MovieStore: MovieService {
    static let shared = MovieStore()
    private init() {}

    private let apiKey = "6dfbbbfc10aa0e69930a9f512c59b66d"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func searchRecommandMovie(query: String, completion: @escaping (Result<MovieSearchResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "include_adult": "false",
//            "region": "US",
            "query": query
        ], completion: completion)
    }
    
    func fetchMovies(from endpoint: MovieListEndpoint, page : Int = 1,completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)\(endpoint.description)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "page" : "\(page)"
        ], completion: completion)
    }
    
    func AsyncfetchMovies(from endpoint: MovieListEndpoint,page : Int) async -> Result<MovieResponse, MovieError> {
        guard let url = URL(string: "\(baseAPIURL)\(endpoint.description)") else {
           return .failure(.invalidEndpoint)
        }
        
        
        return await self.AsyncloadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "page" : "\(page)"
        ])
    }

    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits",
            "language": "zh-TW"
        ], completion: completion)
    }

    func fetchMovieWithEng(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits",
            "language": "en-US"
        ], completion: completion)
    }
    
    func MovieReccomend(id: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ()){
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW"
        ], completion: completion)
    }
    
    func searchMovieInfo(query: String, page : Int = 1,completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "include_adult": "false",
//            "region": "US",
            "query": query,
            "page":String(page)
        ], completion: completion)
    }
    
    func searchPerson(query: String, completion: @escaping (Result<PersonResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/person") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "include_adult": "false",
            "query": query
        ], completion: completion)
    }
    
    
    func GenreType(genreID: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/discover/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW",
            "include_adult": "false",
            "with_genres": "\(genreID)"
        ], completion: completion)
        
    }
    
  
    func fetchMovieImages(id: Int, completion: @escaping (Result<MovieImages, MovieError>) -> ())  {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/images") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url,  params: nil,  completion: completion)
    }
    

    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }

        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if params != nil{
            if let params = params {
                queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
            }
        }
        
        urlComponents.queryItems = queryItems

        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
//        print("//////////////////////")
        print(finalURL)
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }

            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }

            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                print(error)
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
//        dataTask.resume()
//        return dataTask
    }
    
    private func AsyncloadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil) async -> Result<D, MovieError> {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
           return .failure(.invalidEndpoint)
        }

        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if params != nil{
            if let params = params {
                queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
            }
        }
        
        urlComponents.queryItems = queryItems

        guard let finalURL = urlComponents.url else {
            return .failure(.invalidEndpoint)
        }
        
//        print("//////////////////////")
        print(finalURL)
        
        do {
            let (data , resp) = try await urlSession.data(from: finalURL)
            guard let httpResponse = resp as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                return .failure(.invalidResponse)
            }

            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                return .success(decodedResponse)
            } catch {
               return .failure(.serializationError)
            }
        } catch {
            return .failure(.invalidResponse)
        }
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    
    //---------以下為抓取片源---------//
    
    func fetchMovieResource(query: String, completion: @escaping (Result<[ResourceResponse], MovieError>) -> ()) {
        guard let url = URL(string: "https://url-detect.robin019.xyz/search") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecodeResource(url: url,query: query, completion: completion)
    }
    
    private func loadURLAndDecodeResource<D: Decodable>(url: URL, query: String, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }

        let queryItems = [URLQueryItem(name: "query", value: query)]
        
        urlComponents.queryItems = queryItems

        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }

            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }

            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    //---------以上為抓取片源---------//

    

}

class APIService : ServerAPIServerServiceInterface, ObservableObject{
    static let shared = APIService()
    private init(){
    } //signleton mode
    
    @AppStorage("userToken") var token : String = ""
    @Published var uploadProgress : Double = 0
    @Published var observable : NSKeyValueObservation?
    private let API_SERVER_HOST = "\(SERVER_HOST)/api/v1"
    private let HOST = "\(SERVER_HOST)/"
//    private let API_SERVER_HOST = "http://127.0.0.1:8080/api"
    private let Client = URLSession.shared
    private let Decoder = JSONDecoder()
    private let Encoder = JSONEncoder()
    
    //URI Path
    private let previewSearch = "/previewsearch"
    private let search = "/search"
    private let movie = "/movie"
    private let video = "/video"
    
    //TODO: HERLPER
    func serverConnection(completion : @escaping (Result<ServerStatus,Error>)->()){
        guard let url = URL(string: HOST + APIEndPoint.HealthCheck.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.FetchAndDecode(request: request, completion: completion)
    }
    
    func asyncServerConnection() async -> Result<ServerStatus,Error> {
        guard let url = URL(string: HOST + APIEndPoint.HealthCheck.apiUri) else{
           return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return await AsyncFetchAndDecode(request: request)
    }



    
    //MARK: --USER
    func GetUserProfile(completion: @escaping (Result<Profile, Error>) -> ()) {
        
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserProfile.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        FetchAndDecode(request: request, completion: completion)
      
    }
    
    func GetUserProfileById(userID : Int,completion : @escaping (Result<Profile,Error>) -> ()){
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserInfo.apiUri + userID.description) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        FetchAndDecode(request: request, completion: completion)
        
    }
    
    func AsyncGetUserProfileById(userID : Int) async -> Result<Profile,Error>{
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserInfo.apiUri + userID.description) else{
            return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return await AsyncFetchAndDecode(request: request)
    }
    
    func UserLogin(req: UserLoginReq, completion: @escaping (Result<UserLoginResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserLogin.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
       
        do {
            let userData = try JSONEncoder().encode(req)
            request.httpBody = userData
            
        } catch {
            completion(.failure(APIError.badEncoding))
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        PostAndDecode(req: request, completion: completion)
        
    }
    
    func UserSignUp(req : UserSignUpReq,completion : @escaping (Result<UserSignUpResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserSignup.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func UpdateUserProfile(req : UserProfileUpdateReq, completion: @escaping (Result<UserProfileUpdateResp,Error>) ->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UserUpdateProfile.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }

        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
        }
        
        PostAndDecode(req: request, completion: completion)
        
    }
    
    func UploadImage(imgData : Data,uploadType: UploadImageType, completion: @escaping (Result<UploadImageResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + uploadType.uploadURI) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var formFieldKey : String = ""
        switch uploadType {
        case .Avatar:
            formFieldKey = "uploadAvatar"
        case .Cover:
            formFieldKey = "uploadCover"
        }
        
        //generate boundary string
        let boundary = UUID().uuidString
        let httpBody = NSMutableData()
        httpBody.append(convertFileData(fieldName: formFieldKey,
                                        fileName: "\(UUID().uuidString).jpeg",
                                        mimeType: "image/jpeg",
                                        fileData: imgData,
                                        using: boundary))
        
        httpBody.appendString("--\(boundary)--")
        
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody as Data
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func ResetFriendNotification(completion: @escaping (Result<ResetFriendNotificationResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.ResetFriendNotification.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    func ResetCommentNotification(completion: @escaping (Result<ResetCommentNotificationResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.ResetCommentNotification.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    func ResetLikesNotification(completion: @escaping (Result<ResetLikesNotificationResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.ResetLikesNotification.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
//
//    func CountFollowingUser(req: CountFollowingReq, completion: @escaping (Result<CountFollowingResp, Error>) -> ()) {
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountFollowingUser.apiUri + req.user_id.description) else{
//            completion(.failure(APIError.badUrl))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        FetchAndDecode(request: request, completion: completion)
//    }
//
//    func CountFollowedUser(req: CountFollowedReq, completion: @escaping (Result<CountFollowedResp, Error>) -> ()) {
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountFollowedUser.apiUri + req.user_id.description) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//
//        var request = URLRequest(url : url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        FetchAndDecode(request: request, completion: completion)
//    }
//
//    func GetUserFollowingList(req: GetFollowingListReq,completion : @escaping (Result<GetFollowingListResp,Error>) -> ()){
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserFollowingList.apiUri + req.user_id.description) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//
//        var request = URLRequest(url : url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        FetchAndDecode(request: request, completion: completion)
//    }
//
//    func GetUserFollowedList(req : GetFollowedListReq,completion : @escaping (Result<GetFollowedListResp,Error>) -> ()){
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserFollowedList.apiUri + req.user_id.description) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//
//        var request = URLRequest(url : url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        FetchAndDecode(request: request, completion: completion)
//    }
    
    //MARK: Update API
    func CountFriend(req : CountFriendReq,completion: @escaping (Result<CountFriendResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountFriend.apiUri + req.user_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url : url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        FetchAndDecode(request: request, completion: completion)
    }
    
    func GetFriendList(req : GetFriendListReq,completion: @escaping (Result<GetFriendListResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFriendList.apiUri + req.user_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url : url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        FetchAndDecode(request: request, completion: completion)
    }
    
    func GetFriendRoomList(completion: @escaping (Result<GetFriendRoomListResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFriendRoomList.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url : url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        FetchAndDecode(request: request, completion: completion)
    }
    
    //MARK: --USER GENRES SETTING
    func UpdateUserGenre(req : UpdateUserGenreReq, completion : @escaping (Result<UpdateUserGenreResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UpdateUserGenre.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
       
        do {
            let userData = try JSONEncoder().encode(req)
            request.httpBody = userData
            
        } catch {
            completion(.failure(APIError.badEncoding))
        }
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    func GetUserGenres(req : GetUserGenreReq,completion : @escaping (Result<GetUserGenreResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserGenre.apiUri + req.user_id.description) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }

    //MARK: --LIKED MOVIE
    func PostLikedMovie(req : NewUserLikeMoviedReq,completion : @escaping (Result<CreateUserLikedMovieResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateLikedMovie.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func DeleteLikedMovie(req : DeleteUserLikedMovie,completion : @escaping (Result<DeleteUserLikedMovieResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.DeleteLikedMovie.apiUri) else{
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetAllUserLikedMoive(userID : Int, completion : @escaping (Result<AllUserLikedMovieResp,Error>) -> ()) {
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetAllLikedMovie.apiUri)\(userID)") else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetAllUserLikedMoive(userID : Int) async -> Result<AllUserLikedMovieResp,Error> {
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetAllLikedMovie.apiUri)\(userID)") else{
            return .failure(APIError.apiError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return await AsyncFetchAndDecode(request: request)
    }
    
    func IsLikedMovie(req: IsLikedMovieReq, completion: @escaping (Result<IsLikedMovieResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.IsLikedMovie.apiUri + req.movie_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url : url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
        
    }
    
    //MARK: --CUSTOM LIST
    func CreateCustomList(req : CreateNewCustomListReq ,completion : @escaping (Result<CreateNewCustomListResp,Error>) -> ()){
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateCustomList.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func UpdateCustomList(req : UpdateCustomListReq, completion : @escaping (Result<UpdateCustomListResp,Error>) -> ()){
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UpdateCustomList.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func DeleteCustomList(req : DeleteCustomListReq, completion : @escaping (Result<DeleteCustomListResp,Error>) -> ()){
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.DeleteCustomList.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetAllCustomLists(userID : Int, page : Int = 1,limit : Int = 10,completion: @escaping (Result<AllUserListResp, Error>) -> ()){
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetAllUserLists.apiUri)\(userID)") else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        FetchAndDecode(request: request, completion: completion)

    }
    
    func AsyncGetAllCustomLists(userID : Int, page : Int = 1,limit : Int = 10) async -> Result<AllUserListResp,Error> {
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetAllUserLists.apiUri)\(userID)") else{
            return .failure(APIError.apiError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
         return await AsyncFetchAndDecode(request: request)
    }
    
    func GetUserList(listID : Int , completion : @escaping (Result<UserListResp,Error> ) -> ()){
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetUserList.apiUri)\(listID)") else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        FetchAndDecode(request: request, completion: completion)
    }
    
    func InsertMovieToList(movieID : Int, listID : Int, completion : @escaping (Result<InsertMovieToListResp,Error>)->()){
        guard let url = URL(string: "\(API_SERVER_HOST + APIEndPoint.AddMovieToList.apiUri)\(listID)/movie/\(movieID)") else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func RemoveMovieFromList(req : RemoveMovieFromListReq , completion: @escaping (Result<RemoveMovieFromListResp,Error>)->()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.RemoveMovieFromList.apiUri + req.list_id.description + "/movie/" + req.movie_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetOneMovieFromUserList(req: GetOneMovieFromUserListReq, completion: @escaping (Result<GetOneMovieFromUserListResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetOneMovieFromUserList.apiUri + req.movie_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func GetCollectedMovieCount(userID : Int) async -> Result<GetCollectedMovieResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetCollectedMovieCount.apiUri + userID.description) else {
          return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return await AsyncFetchAndDecode(request: request)
    }
    
    //MARK: --POST
    func CreatePost(req : CreatePostReq ,completion : @escaping (Result<CreatePostResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreatePost.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecodeWithProgress(req: request,completion: completion)
    }
    
    func GetAllUserPost( page : Int = 1,limit : Int = 5,completion : @escaping (Result <AllUserPostResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetAllPosts.apiUri + "?page=\(page)&limit=\(limit)") else{
            completion(.failure(APIError.apiError))
            return
        }
        print(url.absoluteURL)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //Async Version
    func AsyncGetAllUserPost(page : Int = 1,limit : Int = 5) async -> Result<AllUserPostResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetAllPosts.apiUri + "?page=\(page)&limit=\(limit)") else{
            return .failure(APIError.apiError)
        }
//        print(url.absoluteURL)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return await AsyncFetchAndDecode(request: request)
    }
    
    func GetFollowUserPost( page : Int = 1,limit : Int = 5,completion : @escaping (Result <FollowingUserPostResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFollowingPosts.apiUri  + "?page=\(page)&limit=\(limit)") else{
            completion(.failure(APIError.apiError))
            return
        }
        print(url.absoluteURL)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetFollowUserPost( page : Int = 1 ,limit : Int = 5) async -> Result <FollowingUserPostResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFollowingPosts.apiUri + "?page=\(page)&limit=\(limit)") else{
            return .failure(APIError.apiError)
        }
        print(url.absoluteURL)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return await AsyncFetchAndDecode(request: request)
    }
    
    func GetUserPostByUserID(userID : Int ,completion : @escaping (Result <UserPostResp,Error>) -> ()) {
        print("GET USER POST")
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserPosts.apiUri + userID.description) else{
            completion(.failure(APIError.apiError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetUserPostByUserID(userID : Int) async -> Result <UserPostResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserPosts.apiUri + userID.description) else{
            return .failure(APIError.apiError)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return await AsyncFetchAndDecode(request: request)
    }
    
    func CountUserPosts(req : CountUserPostReq, completion : @escaping (Result<CountUserPostResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountUserPosts.apiUri + req.user_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //MARK: POST LIKED
    func CreatePostLikes(req : CreatePostLikesReq,completion : @escaping (Result<CreatePostLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreatePostLikes.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func RemovePostLikes(req : RemovePostLikesReq,completion : @escaping (Result<RemovePostLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.RemovePostLikes.apiUri) else{
            completion(.failure(APIError.apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let bodyData = try Encoder.encode(req)
            request.httpBody = bodyData
        }catch{
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func IsPostLiked(req : IsPostLikedReq,completion : @escaping (Result<IsPostLikedResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.IsPostLiked.apiUri + req.post_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    func CountPostLikes(req : CountPostLikesReq,completion : @escaping (Result<CountPostLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountPostLikes.apiUri + req.post_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //MARK: POST COMMENT
    func CreatePostComment(postId : Int,req : CreateCommentReq, completion : @escaping (Result<CreateCommentResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateComment.apiUri + postId.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func UpdatePostComment(commentId : Int, req : UpdateCommentReq, completion : @escaping (Result<UpdateCommentResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.UpdateComment.apiUri + commentId.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func DeletePostComment(commentId : Int, completion : @escaping (Result<DeletePostCommentResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.DeleteComment.apiUri + commentId.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetPostComments(postId : Int,  page : Int = 1,limit : Int = 20,completion : @escaping (Result<GetPostCommentsResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetPostComment.apiUri + postId.description + "?page=\(page)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetPostComments(postId : Int, page : Int = 1 ,limit : Int = 20) async -> Result<GetPostCommentsResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetPostComment.apiUri + postId.description + "?page=\(page)") else {
            return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return await AsyncFetchAndDecode(request: request)
    }
    
    //MARK: --REPLY COMMENT
    func CreateReplyComment(req : CreateReplyCommentReq, completion : @escaping (Result<CreateReplyCommentResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateReplyComment.apiUri + "\(req.post_id)/reply/\(req.comment_id)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        do{
            let  bodyData = try Encoder.encode(req.info)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetReplyComment(req : GetReplyCommentReq,  page : Int = 1,limit : Int = 5,completion : @escaping (Result<GetReplyCommentResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetReplyComment.apiUri + req.comment_id.description + "?page=\(page)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetReplyComment(req : GetReplyCommentReq,  page : Int = 1,limit : Int = 5) async -> Result<GetReplyCommentResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetReplyComment.apiUri + req.comment_id.description + "?page=\(page)") else {
            return .failure(APIError.badUrl)
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return await AsyncFetchAndDecode(request: request)
    }
    
    //MARK: --COMMENT LIKES
    func CreateCommentLikes(req : CreateCommentLikesReq,completion : @escaping (Result<CreateCommentLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateCommentLikes.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func RemoveCommentLikes(req : RemoveCommentLikesReq,completion : @escaping (Result<RemoveCommentLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.RemoveCommentLikes.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func IsCommentLiked(req : IsCommentLikedReq,completion : @escaping (Result<IsCommentLikedResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.IsCommentLiked.apiUri + req.comment_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func CountCommentLikes(req : CountCommentLikesReq,completion : @escaping (Result<CountCommentLikesResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CountCommentLikes.apiUri + req.comment_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //MARK: --MOVIE
    func GetMovieCardInfoByGenre(genre: GenreType, completion :@escaping (Result<MoviePageListByGenreResp, Error>) -> ()) {
        guard let url = URL(string: "\(API_SERVER_HOST)\(APIEndPoint.GetMoviesInfoByGenre.apiUri)/\(genre.rawValue)") else{
            completion(.failure(APIError.apiError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        FetchAndDecode(request: request,completion: completion)
    }
    
    func GetMovieLikedCount(req: CountMovieLikesReq, completion: @escaping (Result<CountMovieLikesResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetMovieLikedCount.apiUri + req.movie_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func GetMovieCollectedCount(req: CountMovieCollectedReq, completion: @escaping (Result<CountMovieCollectedResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetMovieCollectedCount.apiUri + req.movie_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //TODO: FRIEND
    func AddFriend(req : AddFriendReq, completion: @escaping (Result<AddFriendResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.AddFriend.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        PostAndDecode(req: request, completion: completion)
    }
    func RemoveFriend(req : RemoveFriendReq, completion: @escaping (Result<RemoveFriendResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.RemoveFriend.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    func AccepctFriendRequest(req : FriendRequestAccecptReq, completion: @escaping (Result<FriendRequestAcceptResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.AcceptFriendRequest.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }

        PostAndDecode(req: request, completion: completion)

    }
    func DeclineFriendRequest(req : FriendRequestDeclineReq, completion: @escaping (Result<FriendRequestDeclineResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.DeclineFriendRequest.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    func CancelFriendRequest(req : FriendRequestCancelReq, completion: @escaping (Result<FriendRequestCancelResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CancelFriendRequest.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //data
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    
    func GetFriendRequest( page : Int = 1,limit : Int = 20,completion: @escaping (Result<GetFriendRequestListResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFriendRequest.apiUri + "?page=\(page)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetFriendRequest(page : Int = 1,limit : Int = 20) async -> Result<GetFriendRequestListResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetFriendRequest.apiUri + "?page=\(page)") else {
            return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return await AsyncFetchAndDecode(request: request)
    }
    
    func IsFriend(req: IsFriendReq, completion: @escaping (Result<IsFriendResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.IsFriend.apiUri + req.friend_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    
//    func CreateNewFriend(req: CreateNewFriendReq, completion: @escaping (Result<CreateNewFriendResp, Error>) -> ()) {
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateNewFriend.apiUri) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        do{
//            let bodyData = try Encoder.encode(req)
//            request.httpBody = bodyData
//        } catch {
//            completion(.failure(APIError.badEncoding))
//        }
//        
//        PostAndDecode(req: request, completion: completion)
//        
//    }
//    
//    func RemoveFriend(req: RemoveFriendReq, completion: @escaping (Result<RemoveFriendResp, Error>) -> ()) {
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.RemoveFriend.apiUri) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        do{
//            let bodyData = try Encoder.encode(req)
//            request.httpBody = bodyData
//        } catch {
//            completion(.failure(APIError.badEncoding))
//        }
//        
//        PostAndDecode(req: request, completion: completion)
//    }
//    
//    func GetOneFriend(req: GetOneFriendReq, completion: @escaping (Result<GetOneFriendResp, Error>) -> ()) {
//        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetOneFriend.apiUri + req.friend_id.description) else {
//            completion(.failure(APIError.badUrl))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        FetchAndDecode(request: request, completion: completion)
//        
//    }
    
    //MARK: --Room/Group
    func CreateRoom(req : CreateRoomReq,completion: @escaping (Result<CreateRoomResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.CreateRoom.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //data
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    func DeleteRoom(req : DeleteRoomReq,completion: @escaping (Result<DeleteRoomResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.DeleteRoom.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //data
        do{
            let  bodyData = try Encoder.encode(req)
            request.httpBody =  bodyData
        } catch {
            completion(.failure(APIError.badEncoding))
            return
        }
        
        PostAndDecode(req: request, completion: completion)
    }
    func JoinRoom(req : JoinRoomReq,completion: @escaping (Result<JoinRoomResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.JoinRoom.apiUri + req.room_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    func LeaveRoom(req : LeaveRoomReq,completion: @escaping (Result<LeaveRoomResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.LeaveRoom.apiUri + req.room_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    func GetRoomMember(req : GetRoomMembersReq,completion: @escaping (Result<GetRoomMembersResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetRoomMember.apiUri + req.room_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    
    func GetUserRooms(completion: @escaping (Result<GetUserRoomsResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetUserRooms.apiUri) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func GetRoomInfo(req : GetRoomInfoReq,completion: @escaping (Result<GetRoomInfoResp,Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetRoomInfo.apiUri + req.roome_id.description) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    //MARK: --Message
    //TODO: Message
    func GetRoomMessage(req : GetRoomMessageReq, page : Int = 1,limit : Int = 10,completion: @escaping (Result<GetRoomMessageResp,Error>) -> ()){
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetRoomMessage.apiUri + req.room_id.description + "/" + req.last_id.description + "/?page=\(page)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetRoomMessage(req : GetRoomMessageReq, page : Int = 1 ,limit : Int = 20) async -> Result<GetRoomMessageResp,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetRoomMessage.apiUri + req.room_id.description + "/" + req.last_id.description + "/?page=\(page)") else {
           return .failure(APIError.badUrl)
        }
        print(url.description)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return await AsyncFetchAndDecode(request: request)
        
    }
    
    func SetIsRead(req: SetIsReadReq, completion: @escaping (Result<SetIsReadResp, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.SetIsRead.apiUri + req.room_id.description + "/read" ) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        PostAndDecode(req: request, completion: completion)
    }
    
    //MARK: --Notification
    func GetLikesNotification( page : Int = 1,limit : Int = 20,completion: @escaping (Result<GetLikesNotificationsResq, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetLikesNotification.apiUri + "?page=\(page)" ) else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetLikesNotification( page : Int = 1,limit : Int = 20) async -> Result<GetLikesNotificationsResq,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetLikesNotification.apiUri + "?page=\(page)" ) else {
            return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return await AsyncFetchAndDecode(request: request)
    }
    
    func GetCommentNotification( page : Int = 1,limit : Int = 20,completion: @escaping (Result<GetCommentNotificationsResq, Error>) -> ()) {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetCommentNotification.apiUri + "?page=\(page)") else {
            completion(.failure(APIError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        FetchAndDecode(request: request, completion: completion)
    }
    
    func AsyncGetCommentNotification( page : Int = 1 ,limit : Int = 20) async -> Result<GetCommentNotificationsResq,Error> {
        guard let url = URL(string: API_SERVER_HOST + APIEndPoint.GetCommentNotification.apiUri + "?page=\(page)") else {
           return .failure(APIError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return await AsyncFetchAndDecode(request: request)
    }
    
    
    //MARK: --API HEPLER
    private func FetchAndDecode<ResponseType : Decodable>(request : URLRequest,params : [String:String]? = nil,completion : @escaping (Result<ResponseType,Error>) -> ()){
        
        //check the url
        guard var component = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
            completion(.failure(APIError.invalidEndpoint))
            return
        }
        
        //page=?&value=? etc
        var query : [URLQueryItem] = []
        if let params = params{
            query.append(contentsOf: params.map{ URLQueryItem(name: $0.key, value: $0.value)})
            component.queryItems = query
        }
        
        guard let _ = component.url else {
            completion(.failure(APIError.invalidEndpoint))
            return
        }

    
        
//        print(request.absoluteURL)
        //do a URLSession
        
        Client.dataTask(with:request){ [weak self] (data,response,err) in
            guard let self = self else {return} //if current task is break , return
            
            guard err == nil else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.apiError))
                }
                return
            }
            
            //reponse cast to httpResponse ? and status code is 2xx?
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                DispatchQueue.main.async {
                    //Decode datas message???
                    
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
            
            
            do {
                if let result = try? self.Decoder.decode(ResponseType.self, from: data){
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                }else{
                    let errRes = try self.Decoder.decode(ErrorResp.self, from: data)
                    DispatchQueue.main.async {
                        completion(.failure(errRes))
                    }
                }
            } catch{
                DispatchQueue.main.async {
                    completion(.failure(APIError.serializationError))
                }
            }
        }.resume()
    }
   
    
    private func AsyncFetchAndDecode<ResponseType : Decodable>(request : URLRequest) async -> Result<ResponseType,Error>{
        
        //check the url
//        guard var component = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
////            completion(.failure(APIError.invalidEndpoint))
//            return .failure(APIError.invalidEndpoint)
//        }
        
        //page=?&value=? etc
//        var query : [URLQueryItem] = []
//        if let params = params{
//            query.append(contentsOf: params.map{ URLQueryItem(name: $0.key, value: $0.value)})
//            component.queryItems = query
//        }
//
//        guard let finalURL = component.url else {
//            return .failure(APIError.invalidEndpoint)
//        }
//
//        request.url
        //do a URLSession
        
        do {
            let (data ,response) = try await Client.data(for: request)
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                return  .failure(APIError.invalidResponse)
            }
            
            if let decideData = try? self.Decoder.decode(ResponseType.self, from: data){
               return .success(decideData)
            }else{
                //MARK: this code need to status code block !!!
                let errResp = try self.Decoder.decode(ErrorResp.self, from: data)
                print(errResp)
                return .failure(errResp)
            }
        } catch {
            return .failure(error)
        }
        
//        Client.dataTask(with:request){ [weak self] (data,response,err) in
//            guard let self = self else {return} //if current task is break , return
//
//            guard err == nil else {
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.apiError))
//                }
//                return
//            }
//
//            //reponse cast to httpResponse ? and status code is 2xx?
//            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
//                DispatchQueue.main.async {
//                    //Decode datas message???
//
//                    completion(.failure(APIError.invalidResponse))
//                }
//                return
//            }
//
//            guard let data = data else{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.noData))
//                }
//                return
//            }
//
//
//            do {
//                if let result = try? self.Decoder.decode(ResponseType.self, from: data){
//                    DispatchQueue.main.async {
//                        completion(.success(result))
//                    }
//                }else{
//                    let errRes = try self.Decoder.decode(ErrorResp.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.failure(errRes))
//                    }
//                }
//            } catch{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.serializationError))
//                }
//            }
//        }.resume()
    }
    
    private func PostAndDecode<ResponseType : Decodable>(req : URLRequest,completion : @escaping (Result<ResponseType,Error>)->()) {
        
         Client.dataTask(with: req){(data,response,error) in
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                //Decode datas message???
                DispatchQueue.main.async {
//                    print((response as? HTTPURLResponse)?.statusCode)
                    completion(.failure(APIError.badResponse))
                }
                return
            }
            
            if let data = data {
                do {
                    if let decideData = try? self.Decoder.decode(ResponseType.self, from: data){
                        completion(.success(decideData))
                    }else{
                        let errResp = try self.Decoder.decode(ErrorResp.self, from: data)
                        print(errResp)
                        completion(.failure(errResp))
                    }
                    
                }catch{
                    completion(.failure(error))
                }
            }

         }.resume()

    }
    
    private func PostAndDecodeWithProgress<ResponseType : Decodable>(req : URLRequest,completion : @escaping (Result<ResponseType,Error>)->()) {
        
        let dataTask = Client.dataTask(with: req){(data,response,error) in
            self.observable?.invalidate()
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                //Decode datas message???
                DispatchQueue.main.async {
//                    print((response as? HTTPURLResponse)?.statusCode)
                    completion(.failure(APIError.badResponse))
                }
                return
            }
            
            if let data = data {
                do {
                    if let decideData = try? self.Decoder.decode(ResponseType.self, from: data){
                        completion(.success(decideData))
                    }else{
                        let errResp = try self.Decoder.decode(ErrorResp.self, from: data)
                        print(errResp)
                        completion(.failure(errResp))
                    }
                    
                }catch{
                    completion(.failure(error))
                }
            }

        }
        
        self.observable = dataTask.progress.observe(\.fractionCompleted){pro ,_ in
            DispatchQueue.main.async {
                self.uploadProgress = pro.fractionCompleted
            }
        }
        
        dataTask.resume()
    }
    
    private func UploadTask<ResponseType : Decodable>(req : URLRequest,data :Data,completion : @escaping (Result<ResponseType,Error>)->()) {
        
        Client.uploadTask(with: req, from: data) { (data,response,error) in
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                //Decode datas message???
                DispatchQueue.main.async {
//                    print((response as? HTTPURLResponse)?.statusCode)
                    completion(.failure(APIError.badResponse))
                }
                return
            }
            
            if let data = data {
                do {
                    if let decideData = try? self.Decoder.decode(ResponseType.self, from: data){
                        completion(.success(decideData))
                    }else{
                        let errResp = try self.Decoder.decode(ErrorResp.self, from: data)
                        print(errResp)
                        completion(.failure(errResp))
                    }
                    
                }catch{
                    completion(.failure(error))
                }
            }

        }.resume()

    }
    
    
    //MARK: ---UNUSE API
    //getactors?page
    func fetchActors(page : Int = 1,completion: @escaping (Result<PersonInfoResponse, Error>) -> ()) {
        //guard data size in greater than 0
//        if page < 0{
//            completion(.failure(APIError.invalidEndpoint))
//            return
//        }
//
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getactors")!
//
//        let params = [
//            "page" : page.description
//        ]
////        print(url.absoluteURL)
//        self.FetchAndDecode(url: url, params: params,completion: completion)
    }
    
    func fetchDirectors(page : Int = 1, completion: @escaping (Result<PersonInfoResponse, Error>) -> ()) {
        //T
//        //guard data size in greater than 0
//        if page < 0{
//            completion(.failure(APIError.invalidEndpoint))
//            return
//        }
//
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getdirectors")!
//
//        let params = [
//            "page" : page.description
//        ]
////        print(url.absoluteURL)
//        self.FetchAndDecode(url: url, params: params,completion: completion)
    }
    
    func fetchGenreById(genreID id: Int, dataSize size: Int = 5, completion: @escaping (Result<GenreInfoResponse, Error>) -> ()) {
        //TODO
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getgenre")!
//
//        let params = [
//            "id" : id.description,
//            "size" : size.description
//        ]
////        print(url.absoluteURL)
//        self.FetchAndDecode(url: url, params: params,completion: completion)
        
    }
    
    func fetchAllGenres(completion: @escaping (Result<GenreInfoResponse, Error>) -> ()) {
        //TODO
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getallgenres")!
//
////        print(url.absoluteURL)
//        self.FetchAndDecode(url: url,completion: completion)
    
    }
    
    func getPreviewMovie(datas: [SearchRef], completion: @escaping (Result<[MoviePreviewInfo], Error>) -> ()) {
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getpreview")
//        guard let component = URLComponents(url: url!, resolvingAgainstBaseURL: false) else {
//            completion(.failure(APIError.invalidEndpoint))
//            return
//        }
//
//        guard let requestComponent = component.url else {
//            completion(.failure(APIError.invalidEndpoint))
//            return
//        }
//
//        print(requestComponent.absoluteURL)
//        //do a URLSession
//        var request = URLRequest(url: requestComponent)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        guard let encodedData = try? Encoder.encode(datas) else {
//            completion(.failure(APIError.apiError))
//            return
//        }
//
//        Client.uploadTask(with: request, from: encodedData){ [weak self] (data,response,err) in
//            guard let self = self else {return} //if current task is break , return
//
//            guard err == nil else {
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.apiError))
//                }
//                return
//            }
//
//            //reponse cast to httpResponse ? and status code is 2xx?
//            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.invalidResponse))
//                }
//                return
//            }
//
//
//            guard let data = data else{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.noData))
//                }
//                return
//            }
//
//            if statusCode.statusCode == 204{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.noData))
//                }
//                return
//            }
//
//
//            do {
//
//                let result = try self.Decoder.decode([MoviePreviewInfo].self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(result))
////                    print("[DEBUG] PREVIEW IS GOT")
//                }
//            } catch{
//                DispatchQueue.main.async {
//                    completion(.failure(APIError.serializationError))
//                }
//            }
//        }.resume()
    }
    
    func getPreviewMovieList(completion: @escaping (Result<[MoviePreviewInfo], Error>) -> ()) {
//        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getpreviewlist")!
////        let params = [
////            "page" : page.description,
////        ]
//        self.FetchAndDecode(url: url,completion: completion)
    }
    
    func getRecommandtionSearch(query key : String,completion : @escaping (Result<Movie,Error>)-> ()){
//        let url = URL(string: "\(API_SERVER_HOST)\(search)/query")!
//        self.FetchAndDecode(url: url, completion:completion)
    }
    
    func getHotSeachingList(completion: @escaping (Result<[SearchHotItem], Error>) -> ()) {
//        let url = URL(string: "\(API_SERVER_HOST)\(search)/getrecommandsearch")!
//        self.FetchAndDecode(url: url, completion: completion)
    }
    
    func getMovieTrailerList(page : Int = 1 , completing : @escaping (Result<[TrailerInfo],Error>)->()){
//        let url = URL(string: "\(API_SERVER_HOST)\(video)/trailers?page=\(page)")!
//        self.FetchAndDecode(url: url, completion: completing)
    }
}

struct AlgorithmFormatJSON : Codable{
    var Genres : [GenreInfo]
    var Actors : [PersonDataInfo]
    var Directors : [PersonDataInfo]
}

struct PersonDataInfo : Codable,Identifiable {
    let id:Int
    let name: String
    let known_for_department: String
    let profile_path: String?
    
}

struct ServerStatus : Decodable{
    let result : String
}


func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
  let data = NSMutableData()

  data.appendString("--\(boundary)\r\n")
  data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
  data.appendString("Content-Type: \(mimeType)\r\n\r\n")
  data.append(fileData)
  data.appendString("\r\n")

  return data as Data
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

