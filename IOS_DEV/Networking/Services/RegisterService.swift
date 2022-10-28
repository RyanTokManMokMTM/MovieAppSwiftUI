//
//  RegisterService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//

//just for register

import Foundation
//
//class RegisterService: ObservableObject {
//    func handleResponse(for request: URLRequest,
//                        completion: @escaping (Result<, Error>) -> Void){
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
////                print(unwrappedResponse)
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
//                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
//                        print(json)
//                        
//                        // decode data
//                        if let user = try? JSONDecoder().decode(UserSignInResp.self, from: unwrappedData) {       // try? : 沒辦法執行的話就進到else
//                            completion(.success(user))
//                        } else {
//                            let errorResponse = try JSONDecoder().decode(ErrorResp.self, from: unwrappedData)   // try : 沒辦法執行的話跳到catch
//                            print(errorResponse)
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
//    func requestRegister(endpoint: String,
//                 RegisterObject: UserSignInReq,
//                 completion: @escaping (Result<UserSignInResp, Error>) -> Void) {
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
//        
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        handleResponse(for: request, completion: completion)
//        
//    }
//    
//   
//    
//    enum NetworkingError: Error{
//        case badUrl
//        case badResponse
//        case badEncoding
//    }
//}
//
