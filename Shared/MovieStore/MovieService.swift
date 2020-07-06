//
//  MovieService.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 04/07/20.
//

import Foundation
import SwiftUI

enum ImageDataType : String {
    case Thumbnail = "https://image.tmdb.org/t/p/w200"
    case Poster = "https://image.tmdb.org/t/p/w500"
}

protocol MovieService {
    func fetchMovies(endpoint : MovieEndpoint, params : [String : String]?, successHandler : @escaping(_ response : MoviesResponse) -> Void, errorHandler : @escaping(_ error : Error) -> Void)
    func fetchMovie(id: Int, successHandler: @escaping (_ response: Movie) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func searchMovie(query: String, params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func getImageData(endpoint : String, imageDataType : ImageDataType, successHandler : @escaping(_ data : Data) -> Void, errorHandler : @escaping(_ error : Error) -> Void)
}

public enum MovieEndpoint : String, CaseIterable {
    
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public var description : String {
        switch self {
        case .nowPlaying : return "Now Playing"
        case .upcoming : return "Upcoming"
        case .popular : return "Popular"
        case .topRated : return "Top Rated"
        }
    }
    
    public init?(index: Int) {
        switch index {
        case 0: self = .nowPlaying
        case 1: self = .popular
        case 2: self = .upcoming
        case 3: self = .topRated
        default: return nil
        }
    }
    
    public init?(description: String) {
        guard let first = MovieEndpoint.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
}

public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
