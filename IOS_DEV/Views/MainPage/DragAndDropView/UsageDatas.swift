//
//  UsageDatas.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import Foundation
import SwiftUI


enum CharacterRule : String,Codable{
    case Actor = "Actor"
    case Director = "Director"
    case Genre = "Genre"
}

enum RefType :Codable{
    case Persons
    case Genre
}


//Total info for Dragging data
struct DragItemData : Identifiable,Codable{
    let id : String
    let itemType : CharacterRule //descrip what data in used
    let genreData : GenreInfo? //only for genre
    let personData : PersonInfo? //only for actor and director
}

struct SearchRef : Codable{
    let id : Int
    let type : RefType
}

struct PersonInfo: Codable, Identifiable {
    let id:Int
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var ProfileImageURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\( profile_path ?? "")")!
    }
}

enum Tab : String {
    case Actor = "演員"
    case Director = "導演"
    case Genre = "類別"
    case All = "all"
}

enum updateInsertPosition {
    case front,back
}
