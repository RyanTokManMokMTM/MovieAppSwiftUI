//
//  NetworkingService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/18.
//

//for login and get article

import Foundation
import SwiftUI

//let baseUrl="http://120.126.16.229:8080"
let baseUrl="http://127.0.0.156767yy:8000"

class NetworkingService: ObservableObject {
    private var token = ""
        
    static let shared = NetworkingService()
    
    private init(){
        
    }
    //login
    func requestLogin(endpoint: String,
                 loginObject: UserLoginReq,
                 completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let payload = try JSONEncoder().encode(loginObject)
            print("login payload \(payload)")
            request.httpBody = payload
        }catch{
            completion(.failure(NetworkingError.badEncoding))
        }
        
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            
            guard let _ = response as? HTTPURLResponse else{
                completion(.failure(NetworkingError.badResponse))
                return
            }
            
            if let err = error {
                print(err)
                completion(.failure(err))
                return
            }
            
            if let resData = data{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: resData, options: [])
                    print(jsonData)
                    
                    if let tokenData = try? JSONDecoder().decode(UserLoginResp.self, from: resData){
                        print(tokenData)
                        self.token = tokenData.token
                        self.AuthUser(token: self.token, completion: completion)
                    }else{
                        let errRes = try JSONDecoder().decode(ErrorResp.self, from: resData)
                        print(errRes)
                        completion(.failure(errRes))
                    }
                }catch{
                    completion(.failure(error))
                }
                
                
            }

        }.resume()
    }
    
    //驗證token,辨識user
    func AuthUser(token:String, completion: @escaping (Result<Profile, Error>) -> Void){
        let url = URL(string: baseUrl+"/api/v1/user/profile")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let result = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let gotData = data else{
                print("failed to get data")
                completion(.failure(NetworkingError.badUrl))
                return
            }
            do {
                if let user = try? JSONDecoder().decode(Profile.self, from: gotData) {
                    //get all the user datas
                    print(user)
                    UserDefaults.standard.set(token, forKey: "userToken")
                    completion(.success(user))
                }else {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: gotData)
                    completion(.failure(errorResponse))
                }
            } catch {
                print("failed to decode user objects")
            }
        }
        result.resume()
    }
    
    
    
    func getToken() -> String{
        return token
    }
    func getBaseURL() -> String{
        return baseUrl
    }
    
    //----------------------------------上傳使用者大頭貼-------------------------------------//
   
    func uploadImage(fileName: String, image: UIImage) {
        let url = URL(string: baseUrl+"/UserPhoto/post/\(NowUserID!)")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.1)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    
    //----------------------------------取得使用者大頭貼-------------------------------------//
    
    func GET_userPhoto(endpoint: String,completion: @escaping(URL)->()) {

        let url = URL(string: baseUrl + endpoint)

        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        //response
        let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if error == nil, let data = data, let response = response as? HTTPURLResponse {
                  print("statusCode: \(response.statusCode)")
                  completion(url!)
                  print(String(data: data, encoding: .utf8) ?? "")
              } else {
                  completion(url!)
              }
          }.resume()

    }
    
    //----------------------------------取得使用者資訊-------------------------------------//
    func GetUserInfo(endpoint: String,
                 completion: @escaping (Result<User, Error>) -> Void) {

        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        userInfoResponse(for: request, completion: completion)

    }


    func userInfoResponse(for request: URLRequest,
                        completion: @escaping (Result<User, Error>) -> Void){

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in

            //check the response status
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                if let unwrappedData = data {
                    do {
                        if let user = try? JSONDecoder().decode(User.self, from: unwrappedData) {
                            completion(.success(user))
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

}

enum NetworkingError: Error{
    case badUrl
    case badResponse
    case badEncoding
}

//
//protocol SocialService {
//
//    func fetchList(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
//}
//
//enum SocialError: Error, CustomNSError {
//
//    case apiError
//    case invalidEndpoint
//    case invalidResponse
//    case noData
//    case serializationError
//
//    var localizedDescription: String {
//        switch self {
//        case .apiError: return "Failed to fetch data"
//        case .invalidEndpoint: return "Invalid endpoint"
//        case .invalidResponse: return "Invalid response"
//        case .noData: return "No data"
//        case .serializationError: return "Failed to decode data"
//        }
//    }
//
//    var errorUserInfo: [String : Any] {
//        [NSLocalizedDescriptionKey: localizedDescription]
//    }
//
//}
