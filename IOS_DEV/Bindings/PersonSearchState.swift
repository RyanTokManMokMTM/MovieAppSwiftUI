//
//  PersonSearchState.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//

import SwiftUI
import Combine
import Foundation

class PersonSearchState: ObservableObject {
    
    @Published var query = ""
    @Published var person: [Person]?
    @Published var isLoading = false
    @Published var error: NSError?

    
    private var subscriptionToken: AnyCancellable?
    
    let movieService: MovieService
    
    var isEmptyResults: Bool {
        !self.query.isEmpty && self.person != nil && self.person!.isEmpty
    }
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    
    func searchPerson(query: String) {
        self.person = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.query = query
        
        self.isLoading = true
        self.movieService.searchPerson(query: query) {[weak self] (result) in
            guard let self = self ,self.query == query  else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.person = response.results
            case .failure(let error):
                self.error = error as NSError
                print(error)
            }
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
