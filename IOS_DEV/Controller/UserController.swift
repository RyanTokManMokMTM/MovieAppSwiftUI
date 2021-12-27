//
//  UserController.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/15.
//

import Foundation
import SwiftUI


private let _imageCache = NSCache<AnyObject, AnyObject>()
// 上傳使用者大頭貼
class UserController: ObservableObject {
    
    let networkingService = NetworkingService.shared //get
    var PhotoStr:URL?
    @Published var image: UIImage?
    var imageCache = _imageCache
    
    
    func GetUserPhoto(){
        networkingService.GET_userPhoto(endpoint: "/UserPhoto/my/\(NowUserID!)"){ [self] (result) in
            switch result {
            case nil:
                print("UserPhoto failed")
            default:
                self.PhotoStr = result
                print("PhotoStr: \(PhotoStr!)")
                loadImage(with: self.PhotoStr!)
            }

        }
    }


    
    
    func PostUserPhoto(uiImage:UIImage){
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        print("time: \(dateTimeString)")
        
        networkingService.uploadImage(fileName: "\(NowUserName)\(dateTimeString).jpg", image: uiImage)
        
    }
    
    
    //----------用userID找使用者info--------//
    

    func GetUserInfo(userID:UUID){
        networkingService.GetUserInfo(endpoint: "/users/\(userID)"){ [self] (result) in
            switch result {
            case .success(let res):
                print("get the userInfo")
                loadImage(with:res.UserPhotoURL)

            case .failure: print("userInfo failed")
            }
        }
    }
    
    //----------load使用者大頭貼--------//
    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    NowUserPhoto = Image(uiImage: (self?.image)!)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

