//
//  LikeService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation

class FavoriteService: ObservableObject {
    
    let networkingService = NetworkingService.shared
    
    //-----取得喜愛電影-----//
    func GET_likeMovie(endpoint: String,
                 completion: @escaping (Result<[LikeMovie], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        GetLikeMovieResponse(for: request, completion: completion)
        
    }
    
    //-----取得喜愛文章-----//
    func GET_likeArticle(endpoint: String,
                 completion: @escaping (Result<[LikeArticle], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        GetLikeArticleResponse(for: request, completion: completion)
        
    }

    //-----新增喜愛電影-----//
    func POST_likeMovie(endpoint: String,
                    RegisterObject: NewLikeMovie,
                        completion: @escaping(Int)->()) {
        
        let url = URL(string: baseUrl + endpoint)
        print(url?.relativePath)
        let token =  networkingService.getToken()
        var request = URLRequest(url: url!)
        do {
            let newData = try JSONEncoder().encode(RegisterObject)
            request.httpBody = newData

        } catch {
            completion(404)
        }
        
       
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        //response
        let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if error == nil, let data = data, let response = response as? HTTPURLResponse {
//                  print("statusCode: \(response.statusCode)")
                  completion(response.statusCode)
                  print(String(data: data, encoding: .utf8) ?? "")
              } else {
                  completion(404)
              }
          }.resume()
      
        
    }

    
    //-----新增喜愛文章-----//
    func POST_likeArticle(endpoint: String,
                    RegisterObject: NewLikeArticle,
                          completion: @escaping(Int)->()) {
        
        let url = URL(string: baseUrl + endpoint)
        let token =  networkingService.getToken()
        var request = URLRequest(url: url!)
        do {
            let newData = try JSONEncoder().encode(RegisterObject)
            request.httpBody = newData

        } catch {
            completion(404)
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        
        //response
        let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if error == nil, let data = data, let response = response as? HTTPURLResponse {
//                  print("statusCode: \(response.statusCode)")
                  completion(response.statusCode)
                  print(String(data: data, encoding: .utf8) ?? "")
              } else {
                  completion(404)
              }
          }.resume()
      
        
    }
    
    
    //-----刪除喜愛項目（電影or文章）-----//
    func DELETE_like(endpoint: String,
                 completion: @escaping(Int)->()) {
        
        let url = URL(string: baseUrl + endpoint)
        let token =  networkingService.getToken()
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        //response
        let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if error == nil, let data = data, let response = response as? HTTPURLResponse {
//                  print("statusCode: \(response.statusCode)")
                  completion(response.statusCode)
                  print(String(data: data, encoding: .utf8) ?? "")
              } else {
                  completion(404)
              }
          }.resume()
        
    }
    
    //-----檢查喜愛電影-----//
    func CHECK_likeMovie(endpoint: String,
                 completion: @escaping (Result<[CheckLike], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        LikeResponse(for: request, completion: completion)
        
    }
    
    //-----檢查喜愛文章-----//
    func CHECK_likeArticle(endpoint: String,
                 completion: @escaping (Result<[CheckLike], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        LikeResponse(for: request, completion: completion)
        
    }
    
    
//----------------------------------------RESPONSE-----------------------------------------//
    
    func GetLikeMovieResponse(for request: URLRequest,
                        completion: @escaping (Result<[LikeMovie], Error>) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            //check the response status
            DispatchQueue.main.async {
                guard (response as? HTTPURLResponse) != nil else {
                    completion(.failure(NetworkingError.badResponse))   //badResponse : 連不上伺服器
                    return
                }
                //伺服器回傳的error （事實上錯誤訊息會由data回傳）
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                //伺服器回傳的data （含錯誤訊息）
                if let unwrappedData = data {
                    do {
                        if let list = try? JSONDecoder().decode([LikeMovie].self, from: unwrappedData) {
                            completion(.success(list))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func GetLikeArticleResponse(for request: URLRequest,
                        completion: @escaping (Result<[LikeArticle], Error>) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard (response as? HTTPURLResponse) != nil else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                if let unwrappedData = data {
                    do {
                        if let list = try? JSONDecoder().decode([LikeArticle].self, from: unwrappedData) {
                            completion(.success(list))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    
    
    func LikeResponse(for request: URLRequest,
                        completion: @escaping (Result<[CheckLike], Error>) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            //check the response status
            DispatchQueue.main.async {
                guard (response as? HTTPURLResponse) != nil else {
                    completion(.failure(NetworkingError.badResponse))   //badResponse : 連不上伺服器
                    return
                }
                //伺服器回傳的error （事實上錯誤訊息會由data回傳）
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                //伺服器回傳的data （含錯誤訊息）
                if let unwrappedData = data {
                    do {
                        if let listDetail = try? JSONDecoder().decode([CheckLike].self, from: unwrappedData) {
                            completion(.success(listDetail))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    
    enum NetworkingError: Error{
        case badUrl
        case badResponse
        case badEncoding
    }
}

