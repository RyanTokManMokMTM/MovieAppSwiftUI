//
//  MovieSearchView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//


import SwiftUI

struct MovieSearchView: View {
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(placeholder: "Search movies", text: self.$movieSearchState.query)
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                
                LoadingView(isLoading: self.movieSearchState.isLoading, error: self.movieSearchState.error) {
                    self.movieSearchState.search(query: self.movieSearchState.query)
                }
                
                if self.movieSearchState.movies != nil {
                    ForEach(self.movieSearchState.movies!) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true))) {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                Text(movie.yearText)
                            }
                        }
                    }
                }
                
            }
            .onAppear {
                self.movieSearchState.startObserve()
            }
            .navigationBarTitle("Search")
        }
    }
}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView()
    }
}
