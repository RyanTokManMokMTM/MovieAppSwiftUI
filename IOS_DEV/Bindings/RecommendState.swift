//
//  RecommendState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/1.
//

import SwiftUI

class RecommendState: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?

    private let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func RecommendMovies(id:Int) {
        self.movies = nil
        self.isLoading = true
        self.movieService.MovieReccomend(id:id){ [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
                
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    
    
    
}


