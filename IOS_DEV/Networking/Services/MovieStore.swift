//
//  MovieStore.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//
// MovieService concrete implementation

import Foundation

class MovieStore: MovieService {

    static let shared = MovieStore()
    private init() {}

    private let apiKey = "6dfbbbfc10aa0e69930a9f512c59b66d"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
//    private let API_URL = "http://127.0.0.1:8080/api"
//    private let API_PLAYGOUND_URI = "/playground"
    
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

    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "zh-TW"
        ], completion: completion)
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

class APIService : ServerAPIServerServiceInterface{
    static let shared = APIService()
    private init(){
    } //signleton mode
    
    private let API_SERVER_HOST = "http://127.0.0.1:8080/api"
    private let HOST = "http://127.0.0.1:8080"
//    private let API_SERVER_HOST = "http://127.0.0.1:8080/api"
    private let Client = URLSession.shared
    private let Decoder = JSONDecoder()
    private let Encoder = JSONEncoder()
    
    //URI Path
    private let previewSearch = "/previewsearch"
    private let search = "/search"
    private let movie = "/movie"
    private let video = "/video"
    
    func serverConnection(completion : @escaping (Result<ServerStatus,MovieError>)->()){
        let url = URL(string: "\(HOST)/ping")!
        print(url)
        self.FetchAndDecode(url: url, completion: completion)
    }
    
    //To Fetching and Decoding the response body or throw an error
    /*FetchAndDecode - parameters
     @param {url} request - the endpoint url request
     @param {[String : String]} - the header setting
     @param { @escaping (Result<ResponseType,MovieError>) -> ()} - the closure that will call when the request is done
     */
    private func FetchAndDecode<ResponseType : Decodable>(url : URL,params : [String:String]? = nil,completion : @escaping (Result<ResponseType,MovieError>) -> ()){
        
        //check the url
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        //page=?&value=? etc
        var query : [URLQueryItem] = []
        if let params = params{
            query.append(contentsOf: params.map{ URLQueryItem(name: $0.key, value: $0.value)})
            component.queryItems = query
        }
        
        guard let request = component.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
//        print(request.absoluteURL)
        //do a URLSession
        
        Client.dataTask(with:request){ [weak self] (data,response,err) in
            guard let self = self else {return} //if current task is break , return
            
            guard err == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.apiError))
                }
                return
            }
            
            //reponse cast to httpResponse ? and status code is 2xx?
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                DispatchQueue.main.async {
                    //Decode datas message???
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            
            do {
                let result = try self.Decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
//                    print("[DEBUG] DATA IS FETCHED SUCCESSFULLY")
                }
            } catch{
                DispatchQueue.main.async {
                    completion(.failure(.serializationError))
                }
            }
        }.resume()
    }
    
    //getactors?page
    func fetchActors(page : Int = 1,completion: @escaping (Result<PersonInfoResponse, MovieError>) -> ()) {
        //guard data size in greater than 0
        if page < 0{
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getactors")!
        
        let params = [
            "page" : page.description
        ]
//        print(url.absoluteURL)
        self.FetchAndDecode(url: url, params: params,completion: completion)
    }
    
    func fetchDirectors(page : Int = 1, completion: @escaping (Result<PersonInfoResponse, MovieError>) -> ()) {
        //T
        //guard data size in greater than 0
        if page < 0{
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getdirectors")!
        
        let params = [
            "page" : page.description
        ]
//        print(url.absoluteURL)
        self.FetchAndDecode(url: url, params: params,completion: completion)
    }
    
    func fetchGenreById(genreID id: Int, dataSize size: Int = 5, completion: @escaping (Result<GenreInfoResponse, MovieError>) -> ()) {
        //TODO
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getgenre")!
        
        let params = [
            "id" : id.description,
            "size" : size.description
        ]
//        print(url.absoluteURL)
        self.FetchAndDecode(url: url, params: params,completion: completion)
        
    }
    
    func fetchAllGenres(completion: @escaping (Result<GenreInfoResponse, MovieError>) -> ()) {
        //TODO
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getallgenres")!
        
//        print(url.absoluteURL)
        self.FetchAndDecode(url: url,completion: completion)
    
    }
    
    func getPreviewMovie(datas: [SearchRef], completion: @escaping (Result<[MoviePreviewInfo], MovieError>) -> ()) {
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getpreview")
        guard let component = URLComponents(url: url!, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard let requestComponent = component.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print(requestComponent.absoluteURL)
        //do a URLSession
        var request = URLRequest(url: requestComponent)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let encodedData = try? Encoder.encode(datas) else {
            completion(.failure(.apiError))
            return
        }
        
        Client.uploadTask(with: request, from: encodedData){ [weak self] (data,response,err) in
            guard let self = self else {return} //if current task is break , return
            
            guard err == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.apiError))
                }
                return
            }
            
            //reponse cast to httpResponse ? and status code is 2xx?
            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            if statusCode.statusCode == 204{
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            
            do {
                
                let result = try self.Decoder.decode([MoviePreviewInfo].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
//                    print("[DEBUG] PREVIEW IS GOT")
                }
            } catch{
                DispatchQueue.main.async {
                    completion(.failure(.serializationError))
                }
            }
        }.resume()
    }
    
    func getPreviewMovieList(completion: @escaping (Result<[MoviePreviewInfo], MovieError>) -> ()) {
        let url = URL(string: "\(API_SERVER_HOST)\(previewSearch)/getpreviewlist")!
//        let params = [
//            "page" : page.description,
//        ]
        self.FetchAndDecode(url: url,completion: completion)
    }
    
    func getRecommandtionSearch(query key : String,completion : @escaping (Result<Movie,MovieError>)-> ()){
        let url = URL(string: "\(API_SERVER_HOST)\(search)/query")!
        self.FetchAndDecode(url: url, completion:completion)
    }
    
    func getHotSeachingList(completion: @escaping (Result<[SearchHotItem], MovieError>) -> ()) {
        let url = URL(string: "\(API_SERVER_HOST)\(search)/getrecommandsearch")!
        self.FetchAndDecode(url: url, completion: completion)
    }
    
    func getMovieCardInfoByGenre(genre: GenreType, completing: @escaping (Result<MovieCardResponse, MovieError>) -> ()) {
        let url = URL(string: "\(API_SERVER_HOST)\(movie)/getmoviecard?genre=\(genre.rawValue)")!
        self.FetchAndDecode(url: url, completion: completing)
    }
    
    func getMovieTrailerList(page : Int = 1 , completing : @escaping (Result<[TrailerInfo],MovieError>)->()){
        let url = URL(string: "\(API_SERVER_HOST)\(video)/trailers?page=\(page)")!
        self.FetchAndDecode(url: url, completion: completing)
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
    let status : String
    let code : Int
}
