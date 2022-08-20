//
//  MovieImagesState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/23.
//

import SwiftUI

class MovieImagesState: ObservableObject {
    
    private let movieService: MovieService
    @Published var movieImage: MovieImages?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovieImage(id: Int) {
        self.movieImage = nil
        self.isLoading = false
        self.movieService.fetchMovieImages(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let image):
                self.movieImage = image
                
//                print(image)
            case .failure(let error):
                print(error.localizedDescription)
                self.error = error as NSError
            }
        }
    }
}
