//
//  MovieResourceState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//

import SwiftUI
import Combine
import Foundation

class MovieResourceState: ObservableObject {
    
    @Published var query = ""
    @Published var resource: [ResourceResponse] = []
    @Published var isLoading = false
    @Published var error: NSError?

    
    private var subscriptionToken: AnyCancellable?
    
    let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    
    func fetchMovieResource(query: String) {
        self.resource = []
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.query = query
        
        self.isLoading = true
        self.movieService.fetchMovieResource(query: query) {[weak self] (result) in
            guard let self = self ,self.query == query  else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.resource = response
                print("success")
                print(response)
            case .failure(let error):
                self.error = error as NSError
                print(result)
            }
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
