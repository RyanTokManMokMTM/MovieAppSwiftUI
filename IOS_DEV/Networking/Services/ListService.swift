//
//  ListService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/1.
//

import Foundation


class ListService: ObservableObject {
    
    let networkingService = NetworkingService.shared
    
    //get all lists
    func GET_allLists(endpoint: String,
                 completion: @escaping (Result<[CustomList], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        allListResponse(for: request, completion: completion)
        
    }
    //get list details
    func GET_ListsDetails(endpoint: String,
                 completion: @escaping (Result<[ListDetail], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let token =  networkingService.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
        ListDetailsResponse(for: request, completion: completion)
        
    }
    
    //-----新增片單-----//
    func POST_Lists(endpoint: String,
                    RegisterObject: NewList,
                 completion: @escaping (Result<NewListRes, Error>) -> Void) {
        
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
    
        PostListsResponse(for: request, completion: completion)
        
    }
    
    //-----編輯片單-----//
    func PUT_Lists(endpoint: String,
                    RegisterObject: UpdateList,
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
    
    //-----新增片單內容-----//
    func POST_ListDetails(endpoint: String,
                    RegisterObject: NewListMovie,
                 completion: @escaping (Result<ListDetail, Error>) -> Void) {
        
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
    
        PostListMovieResponse(for: request, completion: completion)
        
    }
    
    
    //-----編輯片單內容-----//
    func PUT_ListDetails(endpoint: String,
                    RegisterObject: UpdateListMovie,
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
    
    //-----刪除片單內容-----////-----刪除片單內容-----//
    func DELETE_ListDetails(endpoint: String,
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
    

//    //post comment
//    func POSTrequest(endpoint: String,
//                 RegisterObject: CommentTodo,
//                 completion: @escaping (Result<CommentRes, Error>) -> Void) {
//
//        guard let url = URL(string: baseUrl + endpoint) else {
//            completion(.failure(NetworkingError.badUrl))
//            return
//        }
//
//        var request = URLRequest(url: url)
//
//        do {
//            let userData = try JSONEncoder().encode(RegisterObject)
//            request.httpBody = userData
//
//        } catch {
//            completion(.failure(NetworkingError.badEncoding))
//        }
//
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        Response(for: request, completion: completion)
//
//    }
    
//
//    func Response(for request: URLRequest,
//                        completion: @escaping (Result<CommentRes, Error>) -> Void){
//
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//
//            //check the response status
//            DispatchQueue.main.async {
//                guard let unwrappedResponse = response as? HTTPURLResponse else {
//                    completion(.failure(NetworkingError.badResponse))   //badResponse : 連不上伺服器
//                    return
//                }
//
//                print(unwrappedResponse.statusCode)
//                switch unwrappedResponse.statusCode {
//                case 200 ..< 300:   //200~300 ,NOT INCLUDE 300
//                    print("success")
//                default:
//                    print("failure")
//                }
//
//                //伺服器回傳的error （事實上錯誤訊息會由data回傳）
//                if let unwrappedError = error {
//                    completion(.failure(unwrappedError))
//                    return
//                }
//
//                //伺服器回傳的data （含錯誤訊息）
//                if let unwrappedData = data {
//                    do {
//                        // turn data into json
//                        //let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
//                       // print(json)
//
//                        // decode data
//                        if let comment = try? JSONDecoder().decode(CommentRes.self, from: unwrappedData) {
//                            completion(.success(comment))
//                        } else {
//                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
//                            completion(.failure(errorResponse))
//
//                        }
//
//                    } catch {
//                        completion(.failure(error))
//                    }
//                }
//
//            }
//
//        }
//
//        task.resume()
//
//    }
//

    
    
//----------------------------------------RESPONSE-----------------------------------------//
    
    func allListResponse(for request: URLRequest,
                        completion: @escaping (Result<[CustomList], Error>) -> Void){
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
                        if let list = try? JSONDecoder().decode([CustomList].self, from: unwrappedData) {
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
    
    func ListDetailsResponse(for request: URLRequest,
                        completion: @escaping (Result<[ListDetail], Error>) -> Void){
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
                        if let listDetail = try? JSONDecoder().decode([ListDetail].self, from: unwrappedData) {
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
    
    func PostListsResponse(for request: URLRequest,
                        completion: @escaping (Result<NewListRes, Error>) -> Void){
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
                        if let listDetail = try? JSONDecoder().decode(NewListRes.self, from: unwrappedData) {
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
    
    func PostListMovieResponse(for request: URLRequest,
                        completion: @escaping (Result<ListDetail, Error>) -> Void){
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
                        if let listDetail = try? JSONDecoder().decode(ListDetail.self, from: unwrappedData) {
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

