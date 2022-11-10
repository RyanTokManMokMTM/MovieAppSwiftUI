//
//  metadata.swift
//  IOS_DEV
//
//  Created by Jackson on 10/11/2022.
//

import Foundation

//MARK: For pagnation API
struct metadata : Decodable {
    let total_pages : Int
    let total_results : Int
    let page : Int
}
