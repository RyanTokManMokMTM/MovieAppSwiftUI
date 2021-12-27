//
//  Utils.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//


import Foundation

class Utils {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    static let Formatter: DateFormatter = {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return Formatter
    }()



}

