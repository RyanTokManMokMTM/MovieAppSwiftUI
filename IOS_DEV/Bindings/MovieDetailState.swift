//
//  MovieDetailState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//

import SwiftUI

class MovieDetailState: ObservableObject {
    
    private let movieService: MovieService
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) {
        self.movie = nil
        self.isLoading = false
        self.movieService.fetchMovie(id: id) {[weak self] (result) in
            guard let self = self else { return }
        
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
            self.isLoading = false
        }
    }
    
    func loadMovieWithEng(id: Int) {
        self.movie = nil
        self.isLoading = false
        self.movieService.fetchMovieWithEng(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
