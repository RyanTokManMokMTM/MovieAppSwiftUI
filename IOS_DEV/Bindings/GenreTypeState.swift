//
//  GenreTypeState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import SwiftUI
import Combine
import Foundation

class GenreTypeState: ObservableObject {
    @Published var genreMovies : [MovieCardInfo] = []
    @Published var isLoading = false
    @Published var error: NSError?
    private let genreType : GenreType
    private let movieService: MovieService
    private let apiService : APIService
    
    
    init(movieService: MovieService = MovieStore.shared,apiService : APIService = APIService.shared,genreType:GenreType) {
        self.movieService = movieService
        self.apiService = apiService
        self.genreType = genreType
        
        getGenreCard()
    }
    
    func getGenreCard() {
        self.isLoading = true
        self.error = nil
        self.apiService.getMovieCardInfoByGenre(genre: self.genreType){ [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.genreMovies = response.results
      
            case .failure(let error):
                self.error = error as NSError
            }
            
            self.isLoading = false
            
        }
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self else { return }
//
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//            case .failure(let error):
//                self.error = error as NSError
//
//            }
//        }
    }
    
//    func genreType(genreID: Int) {
//        self.movies = nil
//        self.isLoading = false
//        self.error = nil
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self else { return }
//            
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//            case .failure(let error):
//                self.error = error as NSError
//
//            }
//        }
//    }
    
//    private var subscriptionToken: AnyCancellable?
//
//    let movieService: MovieService
//
//    var isEmptyResults: Bool {
//        self.genreID == 0 && self.movies != nil && self.movies!.isEmpty
//    }
//
//    init(movieService: MovieService = MovieStore.shared) {
//        self.movieService = movieService
//        self.genreID = 0
//    }
//
//    func genreType(genreID: Int) {
//        self.movies = nil
//        self.isLoading = false
//        self.error = nil
//
//
//        guard (genreID == 0) else {
//            return
//        }
//
//        self.genreID = genreID
//
//        self.isLoading = true
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self, self.genreID == genreID else { return }
//
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//                print("==========")
//                print(response)
//            case .failure(let error):
//                self.error = error as NSError
//                print("==========")
//                print(error)
//            }
//        }
//    }
//
//
//    deinit {
//        self.subscriptionToken?.cancel()
//        self.subscriptionToken = nil
//    }
}


class Test: ObservableObject {
    
    @Published var genreMovies : [MovieCardInfo]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let movieService: MovieService
    private let apiService : APIService
    
    
    init(movieService: MovieService = MovieStore.shared,apiService : APIService = APIService.shared) {
        self.movieService = movieService
        self.apiService = apiService
    }
    
    func getGenreCard(genre: GenreType) {
        self.genreMovies = nil
        self.isLoading = false
        self.error = nil
        self.apiService.getMovieCardInfoByGenre(genre: genre){ [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.genreMovies = response.results
                self.error = nil
                print(self.genreMovies?.count ?? "0")
            case .failure(let error):
                self.error = error as NSError
                
            }
            self.isLoading = false
        }
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self else { return }
//
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//            case .failure(let error):
//                self.error = error as NSError
//
//            }
//        }
    }
    
//    func genreType(genreID: Int) {
//        self.movies = nil
//        self.isLoading = false
//        self.error = nil
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self else { return }
//
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//            case .failure(let error):
//                self.error = error as NSError
//
//            }
//        }
//    }
    
//    private var subscriptionToken: AnyCancellable?
//
//    let movieService: MovieService
//
//    var isEmptyResults: Bool {
//        self.genreID == 0 && self.movies != nil && self.movies!.isEmpty
//    }
//
//    init(movieService: MovieService = MovieStore.shared) {
//        self.movieService = movieService
//        self.genreID = 0
//    }
//
//    func genreType(genreID: Int) {
//        self.movies = nil
//        self.isLoading = false
//        self.error = nil
//
//
//        guard (genreID == 0) else {
//            return
//        }
//
//        self.genreID = genreID
//
//        self.isLoading = true
//        self.movieService.GenreType(genreID: genreID) {[weak self] (result) in
//            guard let self = self, self.genreID == genreID else { return }
//
//            self.isLoading = false
//            switch result {
//            case .success(let response):
//                self.movies = response.results
//                print("==========")
//                print(response)
//            case .failure(let error):
//                self.error = error as NSError
//                print("==========")
//                print(error)
//            }
//        }
//    }
//
//
//    deinit {
//        self.subscriptionToken?.cancel()
//        self.subscriptionToken = nil
//    }
}
