//
//  People.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//

import Foundation

struct PersonResponse: Decodable {
 
    let results: [Person]
   
}

struct Person: Decodable, Identifiable {
    let id:Int
    let name: String
    let knownForDepartment: String?
    let profilePath: String?
    let knownFor: [knownFor]
    
    var ProfileImageURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\( profilePath ?? "")")!
    }
   
}

struct knownFor: Decodable, Identifiable{
    let id: Int
    let title: String?      //電影名稱可能被放在title也可能被放在name
    let name: String?
    let posterPath: String?

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
}

