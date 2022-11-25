//
//  MovieListState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//


import SwiftUI
import Algorithms

class MovieListState: ObservableObject {

    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var page : Int = 1
    @Published var total : Int = 0
    
//    @Published var initData : Bool = false
    @Published var loadMore = false
    
    private let movieService: MovieService
    private let apiService : APIService
//    private let endpoint: MovieListEndpoint
    init(movieService: MovieService = MovieStore.shared,apiService : APIService = APIService.shared) {
        self.movieService = movieService
        self.apiService = apiService
//        self.endpoint = endpoint
//        loadMovies()
    }
    
    func loadMovies(endpoint: MovieListEndpoint) {        
        self.movies = nil
        self.isLoading = true
        self.movieService.fetchMovies(from: endpoint,page: 1) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.movies = response.results
//                self.total = response.total_pages
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.loadMore = self.page < self.total
                }
            case .failure(let error):
                self.error = error as NSError
            }
            self.isLoading = false
        }
    }
    
    @MainActor
    func loadMoreMovies(endpoint: MovieListEndpoint) async {
        if self.page > self.total || self.total == 0 {
            return
        }
        self.page += 1
        let resp = await self.movieService.AsyncfetchMovies(from: endpoint, page: self.page)
        switch resp {
        case .success(let data):
            self.movies?.append(contentsOf: data.results)
            self.movies?.uniqued()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.loadMore = self.page < self.total
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    
    
    
    
}

