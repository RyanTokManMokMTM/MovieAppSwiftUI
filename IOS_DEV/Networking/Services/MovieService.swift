//
//  MovieService.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/2.
//
// Interface, endpoint, error

import Foundation

protocol MovieService {

    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    func fetchMovieWithEng(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    func MovieReccomend(id: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    
    func searchRecommandMovie(query: String, completion: @escaping (Result<MovieSearchResponse, MovieError>) -> ())
    func searchMovieInfo(query: String,page:Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func searchPerson(query: String, completion: @escaping (Result<PersonResponse, MovieError>) -> ())
    func GenreType(genreID: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovieImages(id: Int, completion: @escaping (Result<MovieImages, MovieError>) -> ())
    func fetchMovieResource(query: String, completion: @escaping (Result<[ResourceResponse], MovieError>) -> ())

}


protocol ServerAPIServerServiceInterface {
    
    //Conennection check
    func serverConnection(completion : @escaping (Result<ServerStatus,MovieError>)->())
    
    //Searching and playground
    //TODO - Person data format
    func fetchActors(page : Int ,completion : @escaping (Result<PersonInfoResponse,MovieError>) ->  ())
    func fetchDirectors(page : Int ,completion : @escaping (Result<PersonInfoResponse,MovieError>) -> ())
    
    //TODO - Genre with description image of a referencing movie
    func fetchGenreById(genreID id :Int, dataSize size : Int , completion : @escaping (Result<GenreInfoResponse,MovieError>) -> ())
    func fetchAllGenres(completion : @escaping (Result<GenreInfoResponse,MovieError>) -> ())
    
    //TODO -Preview API
    func getPreviewMovie(datas : [SearchRef],completion : @escaping (Result<[MoviePreviewInfo],MovieError>) -> ())
    
    func getPreviewMovieList(completion : @escaping (Result<[MoviePreviewInfo],MovieError>) -> ())
    
    //TODO -Search API
    func getRecommandtionSearch(query key: String,completion : @escaping (Result<Movie,MovieError>)-> ())
    func getHotSeachingList(completion : @escaping (Result<[SearchHotItem],MovieError>)->())
    
    //TODO -MovieAPI
    func getMovieCardInfoByGenre(genre:GenreType,completing : @escaping (Result<MovieCardResponse,MovieError>)->())
    
    //TODO -TrailerAPI
    func getMovieTrailerList(page : Int,completing : @escaping (Result<[TrailerInfo],MovieError>)->())
    
}


enum MovieListEndpoint: String, CaseIterable, Identifiable {

    var id: String { rawValue }

    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular

    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

enum MovieError: Error, CustomNSError {

    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }

    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }

}



