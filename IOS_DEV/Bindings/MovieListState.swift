//
//  MovieListState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//


import SwiftUI

class MovieListState: ObservableObject {

    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?

    private let movieService: MovieService
    private let apiService : APIService
    private let endpoint: MovieListEndpoint
    init(movieService: MovieService = MovieStore.shared,apiService : APIService = APIService.shared, endpoint: MovieListEndpoint) {
        self.movieService = movieService
        self.apiService = apiService
        self.endpoint = endpoint
        loadMovies()
    }
    
    func loadMovies() {
        self.movies = nil
        self.isLoading = true
        self.movieService.fetchMovies(from: self.endpoint) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.movies = response.results
  
            case .failure(let error):
                self.error = error as NSError
            }
            self.isLoading = false
        }
    }
    
    
    
    
}

