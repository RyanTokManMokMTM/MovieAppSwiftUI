//
//  DataLoader.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/22.
//

import Foundation

public class DataLoader {
    
    @Published var genreData = [MovieGenre]()
    
    init() {
        load()
//        sort()
    }
    
    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "movie_genre", withExtension: "json") {
            
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([MovieGenre].self, from: data)
                
                self.genreData = dataFromJson
               
            } catch {
                print(error)
            }
        }
    }
    
//    func sort() {
//        self.genreData = self.genreData.sorted(by: { $0.id < $1.id })
//    }
    
}
