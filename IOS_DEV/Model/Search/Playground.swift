//
//  Playground.swift
//  IOS_DEV
//
//  Created by Jackson on 30/10/2021.
//

import Foundation

struct PersonInfoResponse : Decodable {
    let response : [PersonInfo]
}

struct GenreInfoResponse : Decodable {
    let response : [GenreInfo]
}

struct GenreInfo : Codable,Identifiable {
    var id : Int //genre id
    var name : String //genre name
    var describe_img : String //using any image which movie can describe this Genre (URL)
    
    var posterImg: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\( describe_img)")!
    }
}

struct MoviePreviewInfo : Codable,Identifiable{
    let id: Int
    let title: String
    let poster_path: String?
    let overview: String
    let run_time: Int?
    let release_date: String?
    let original_language: String?
    let genres : [String]?
    let casts : [String]?
    let vote_average: Double?
    let vote_count: Int?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path ?? "")")!
    }
    
    var yearText: String {
        guard let releaseDate = self.release_date, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return MoviePreviewInfo.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.run_time, runtime > 0 else {
            return "n/a"
        }
        return MoviePreviewInfo.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    
    var ratingText: String {
        if let avg = vote_average {
            let rating = Int(avg)/2
            let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
                return acc + "★"
                
            }
            return ratingText
        }
        else {
            return ""
        }
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/5"
    }

}
