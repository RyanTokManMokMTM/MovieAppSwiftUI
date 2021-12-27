//
//  Seach.swift
//  IOS_DEV
//
//  Created by Jackson on 14/11/2021.
//

import Foundation
import SwiftUI

struct SearchHotItem : Codable {
    let id : Int
    let title : String
    let overview : String
    
    var description : String{
        return overview.isEmpty ? "Comming soon..." : overview
    }
}

struct SearchResult : Codable{
    var id: Int
    var title: String

}

