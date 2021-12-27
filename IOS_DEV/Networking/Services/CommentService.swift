//
//  CommentService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/3.
//

//just for comment

import Foundation


class CommentService: ObservableObject {
    
    let networkingService = NetworkingService.shared
    
    
    //get comment
    func GETrequest(endpoint: String,
                 completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        getCommentResponse(for: request, completion: completion)
        
    }
    
    //post comment
    func POSTrequest(endpoint: String,
                 RegisterObject: CommentTodo,
                 completion: @escaping (Result<CommentRes, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
       
        do {
            let userData = try JSONEncoder().encode(RegisterObject)
            request.httpBody = userData
            
        } catch {
            completion(.failure(NetworkingError.badEncoding))
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        postCommentResponse(for: request, completion: completion)
        
    }
    
    //update comment
    func PUT_Comments(endpoint: String,
                    RegisterObject: UpdateComment,
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
                  completion(response.statusCode)
                  print(String(data: data, encoding: .utf8) ?? "")
              } else {
                  completion(404)
              }
          }.resume()
        
    }
    //delete comment
    func DELETE_Comments(endpoint: String,
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
    func getCommentResponse(for request: URLRequest,
                        completion: @escaping (Result<[Comment], Error>) -> Void){
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //check the response status
            DispatchQueue.main.async {
                //伺服器回傳的error （事實上錯誤訊息會由data回傳）
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                
                //伺服器回傳的data （含錯誤訊息）
                if let unwrappedData = data {
                    do {
                        // decode data
                        if let comment = try? JSONDecoder().decode([Comment].self, from: unwrappedData) {
                            completion(.success(comment))
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
    
    func postCommentResponse(for request: URLRequest,
                        completion: @escaping (Result<CommentRes, Error>) -> Void){
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //check the response status
            DispatchQueue.main.async {
                
                //伺服器回傳的error （事實上錯誤訊息會由data回傳）
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                
                //伺服器回傳的data （含錯誤訊息）
                if let unwrappedData = data {
                    do {
                        // decode data
                        if let comment = try? JSONDecoder().decode(CommentRes.self, from: unwrappedData) {
                            completion(.success(comment))
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

