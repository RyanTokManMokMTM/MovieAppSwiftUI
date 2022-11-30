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
    @Published var total : Int = 1
    @Published var page : Int = 1
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
                self.total = response.totalPages
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func LoadMoreRecommendMovies(id:Int) async {
        if self.page >= self.total {
            return
        }
        
        self.isLoading = true
        self.page = page + 1
        let resp = await  self.movieService.AsyncMovieReccomend(id: id, page: self.page)
        switch resp {
        case .success(let response):
            self.movies = (self.movies ?? []) + response.results
//            self.total = response.total_pages
            
        case .failure(let error):
            self.error = error as NSError
            print(error.localizedDescription)
        }
        self.isLoading = false
        
    }
    
    func isLastMovie(movieID : Int) -> Bool {
        return self.movies?.last?.id == movieID
    }
    
    
}


