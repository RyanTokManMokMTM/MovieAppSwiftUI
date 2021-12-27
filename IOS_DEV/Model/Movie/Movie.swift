//
//  TestMovie.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//

import Foundation



struct MovieResponse: Decodable {
    let totalPages : Int
    let results: [Movie]
}

struct MovieSearchResponse: Decodable {
    let results: [MovieSearchInfo]
}

struct MovieSearchInfo : Decodable,Identifiable{
    let id : Int
    let title : String
}


//This information is used in StackCard View
struct MovieCardResponse : Decodable {
    let results : [MovieCardInfo]
}

struct MovieCardInfo : Identifiable,Decodable{
    let id : Int
    let title : String
    let poster : String?
    let vote_average : Double
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster ?? "")")!
    }
    
    var ratingText: String {
        let rating = Int(vote_average)/2
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
            
        }
        
        return ratingText
    }
}


struct Movie: Decodable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let genreIds : [Int]? //For some data only
    let originalLanguage: String
    
    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?
    
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
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var genreStr : String {
        if let genresIds = genreIds {
            var genresName : [String] = []
            genresName.append(contentsOf: genresIds.map{GenreIdsName[$0] ?? "?" })
            if genresName.count>3{
                genresName.removeSubrange(3..<genresName.count)
            }
            return genresName.joined(separator: "⊙")
        }else{
            return ""
        }
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)/2
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
            
        }
        
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/5"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var cast: [MovieCast]? {
        credits?.cast
    }
    
    var crew: [MovieCrew]? {
        credits?.crew
    }
    
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
    
}

struct MovieSeachInfo : Decodable, Identifiable{
    let id: Int //Movie ID
    let title: String //MovieTitle
    let posterPath: String? //Movie Poster
    let overview: String //Movie Overview
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let genre_ids : [Int]? //Movie Genre ids
    
//    var genresString : String{
//        var genreStr : [String] = []
//
//            for id in genre_ids{
//                if let ids = GenreIdsName[id]{
//                    genreStr.append(ids)
//            }
//        }
//        return genreStr.joined(separator: ",")
//    }
}

struct MovieGenreID: Decodable {    //抓特定類別用的
    
    let id: Int
}

struct MovieGenre: Codable {
    
    let id: Int
    let name: String
}

struct MovieGenreId : Decodable{
    let id : Int
}


struct MovieCredit: Decodable {
    
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}

struct MovieVideoResponse: Decodable {
    
    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable {
    
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}

//圖表記錄用
//struct GenreChart: Decodable, Encodable{
//    let id: Int
//    let name: String
//    let TypeNum: Int
//}
//
//let stubbedMovie:[Movie] = [
//    Movie(id: 338762, title: "Bloodshot", backdropPath: "/ocUrMYbdjknu2TwzMHKT9PBBQRw.jpg", posterPath: "/8WUVHemHFH2ZIP6NWkwlHWsyrEL.jpg", overview: "After he and his wife are murdered, marine Ray Garrison is resurrected by a team of scientists. Enhanced with nanotechnology, he becomes a superhuman, biotech killing machine—'Bloodshot'. As Ray first trains with fellow super-soldiers, he cannot recall anything from his former life. But when his memories flood back and he remembers the man that killed both him and his wife, he breaks out of the facility to get revenge, only to discover that there's more to the conspiracy than he thought.", voteAverage: 7.1, voteCount: 2324, runtime: 250, releaseDate: "2020-03-05", originalLanguage: "en", genres: [], credits: nil, videos: nil),
//    Movie(id: 338763, title: "test1", backdropPath: "/ic0intvXZSfBlYPIvWXpU1ivUCO.jpg", posterPath: "/ic0intvXZSfBlYPIvWXpU1ivUCO.jpg", overview: "After he and his wife are murdered, marine Ray Garrison is resurrected by a team of scientists. Enhanced with nanotechnology, he becomes a superhuman, biotech killing machine—'Bloodshot'. As Ray first trains with fellow super-soldiers, he cannot recall anything from his former life. But when his memories flood back and he remembers the man that killed both him and his wife, he breaks out of the facility to get revenge, only to discover that there's more to the conspiracy than he thought.", voteAverage: 7.1, voteCount: 2324, runtime: 250, releaseDate: "2020-03-05", originalLanguage: "en", genres: [], credits: nil, videos: nil),
//    Movie(id: 338764, title: "test2", backdropPath: "/xing0YOUsHS4qKFu7BtFSnZfAgJ.jpg", posterPath: "/xing0YOUsHS4qKFu7BtFSnZfAgJ.jpg", overview: "After he and his wife are murdered, marine Ray Garrison is resurrected by a team of scientists. Enhanced with nanotechnology, he becomes a superhuman, biotech killing machine—'Bloodshot'. As Ray first trains with fellow super-soldiers, he cannot recall anything from his former life. But when his memories flood back and he remembers the man that killed both him and his wife, he breaks out of the facility to get revenge, only to discover that there's more to the conspiracy than he thought.", voteAverage: 7.1, voteCount: 2324, runtime: 250, releaseDate: "2020-03-05", originalLanguage: "en", genres: [], credits: nil, videos: nil)
//    
//]
//
//let GenreID:[MovieGenreID] = [
//    MovieGenreID(id:28),
//    MovieGenreID(id:12),
//    MovieGenreID(id:16),
//    MovieGenreID(id:35),
//
//]
//
enum GenreType : Int{
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
    case Documentary = 99
    case Drama = 18
    case Family = 10751
    case Fantasy = 14
    case History = 36
    case Horror = 27
    case Music = 10402
    case Mystery = 9648
    case Romance = 10749
    case ScienceFiction = 878
    case TvMovie = 10770
    case Thriller = 53
    case War = 10752
    case Western = 37
}

let GenreIdsName : [Int:String]  = [
    28 : "動作",
    12 : "冒險",
    16 : "動畫",
    35 : "喜劇",
    80 : "犯罪",
    99 : "紀錄",
    18 : "劇情",
    10751 : "家庭",
    14 : "奇幻",
    36 : "歷史",
    27 : "恐怖",
    10402 : "音樂",
    9648 : "懸疑",
    10749 : "愛情",
    878 : "科幻",
    10770 : "電視電影",
    53 : "驚悚",
    10752 : "戰鬥"
]
