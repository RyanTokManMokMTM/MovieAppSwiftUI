//
//  MovieImages.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//

import Foundation

struct MovieImages: Decodable, Identifiable {
    let id: Int
    let backdrops: [ImagePath]
}

struct ImagePath: Decodable {
    let height: Int
    let filePath: String?
    let width : Int
    
    var MovieImageURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(filePath ?? "")")!
    }

}
