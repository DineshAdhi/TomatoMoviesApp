//
//  MovieService.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 04/07/20.
//

import Foundation
import SwiftUI

protocol TVService {
    func fetchMovies(endpoint : TVEndpoint, params : [String : String]?, successHandler : @escaping(_ response : MoviesResponse) -> Void, errorHandler : @escaping(_ error : Error) -> Void)
    func fetchMovie(id: Int, successHandler: @escaping (_ response: Movie) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func searchMovie(query: String, params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func getImageData(endpoint : String, imageDataType : ImageDataType, successHandler : @escaping(_ data : Data) -> Void, errorHandler : @escaping(_ error : Error) -> Void)
}

public enum TVEndpoint : String, CaseIterable {
    
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
        guard let first = TVEndpoint.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
}
