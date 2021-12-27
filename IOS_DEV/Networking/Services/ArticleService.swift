//
//  ArticleService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/24.
//


import Foundation

class ArticleService: ObservableObject {
    
    let networkingService = NetworkingService.shared
    
    //-------------------------------get某電影的討論區文章-------------------------------------//
    func GET_allArticle(endpoint: String,
                      completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
       
        allArticleResponse(for: request, completion: completion)
        
    }
    //--------------------------------post文章在討論區--------------------------------//
    func POST_Article(endpoint: String,
                    RegisterObject: NewArticle,
                 completion: @escaping (Result<NewArticleRes, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        do {
            let newData = try JSONEncoder().encode(RegisterObject)
            request.httpBody = newData

        } catch {
            completion(.failure(NetworkingError.badEncoding))
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        postArticleResponse(for: request, completion: completion)
        
    }
    
    //--------------------------------update文章--------------------------------//
    func PUT_Article(endpoint: String,
                    RegisterObject: UpdateArticle,
                 completion: @escaping(Int)->()) {
        
        let url = URL(string: baseUrl + endpoint)
        let token =  networkingService.getToken()
        
        var request = URLRequest(url: url!)
        do {
            let newData = try JSONEncoder().encode(RegisterObject)
            request.httpBody = newData

        } catch {
            print("encode error")
        }
        
        request.httpMethod = "PUT"
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
    
    //--------------------------------delete文章--------------------------------//
    func DELETE_Article(endpoint: String,
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
    
    //----------------------------------------RESPONSE-----------------------------------------//
    func allArticleResponse(for request: URLRequest,
                        completion: @escaping (Result<[Article], Error>) -> Void){
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
                        if let list = try? JSONDecoder().decode([Article].self, from: unwrappedData) {
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
    
    
    func postArticleResponse(for request: URLRequest,
                        completion: @escaping (Result<NewArticleRes, Error>) -> Void){
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
                        if let list = try? JSONDecoder().decode(NewArticleRes.self, from: unwrappedData) {
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
    

    
    
    enum NetworkingError: Error{
        case badUrl
        case badResponse
        case badEncoding
    }
}
