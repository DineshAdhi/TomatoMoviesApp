//
//  MovieData.swift
//  iOS
//
//  Created by Dineshadhithya V on 04/07/20.
//

import Foundation
import SwiftUI

struct MovieHomeRow: Identifiable {
    
    var categoryName: String
    var movies: [Movie]
    var order: Int
    
    var id: String {
        return categoryName
    }
}

class MovieHomeData : ObservableObject {
    
    private let movieService : MovieService = MovieStore.shared
    
    @Published var movieCategory : [MovieHomeRow] = []
    
    public init(endpoints : [MovieEndpoint]) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        
        var rows: [MovieHomeRow] = []
        
        for (index, endPoint) in endpoints.enumerated() {
            
            queue.async(group : group) {
                group.enter()
                
                self.movieService.fetchMovies(endpoint: endPoint, params: nil) { (response) in
                    rows.append(MovieHomeRow(categoryName: endPoint.description, movies: response.results, order: index))
                    group.leave()
                } errorHandler: { (error) in
                    print(error.localizedDescription)
                    group.leave()
                }
            }
            
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            rows.sort { $0.order < $1.order }
            self.movieCategory = rows
        }
    }
    
    public func isLoading() -> Bool {
        return movieCategory.isEmpty
    }
}

class MovieItemData : ObservableObject {
    
    @Published var movie : Movie
    
    init(movie : Movie) {
        self.movie = movie;
    }
    
    func loadMovie() {
        MovieStore.shared.fetchMovie(id: movie.id) {[weak self] (movie) in
            self?.movie = movie
        } errorHandler: { (error) in
            print(error.localizedDescription)
        }
    }
}

class MovieQueryData : ObservableObject {
    
    @Published var movieList : [Movie] = []
    @Published var queryStatusMessage : String = "Type in the movie name to search"
    
    init(list : [Movie]) {
        self.movieList = list;
    }
    
    func query(query : String) {
        
        movieList = []
        
        if(query.isEmpty) {
            return
        }
        
        MovieStore.shared.searchMovie(query: query, params: nil) { [weak self] (movieResponse) in
            
            if(movieResponse.results.isEmpty) {
                self?.queryStatusMessage = "No Results"
                self?.movieList = []
                return;
            }
            
            self?.movieList = movieResponse.results
            
        } errorHandler: { [weak self] (error) in
            
            self?.queryStatusMessage = "We ran in to error :("
            
            switch error {
            case MovieError.apiError :
                print("API ERROR")
                break;
                
            case MovieError.invalidEndpoint :
                print("INVALID ENDPOINT")
                break;
            case MovieError.invalidResponse :
                print("INVALID RESPONSE")
                break;
            case MovieError.noData :
                print("NO DATA")
                break;
            case MovieError.serializationError :
                print("SERIALIZATION ERROR")
                break;
                
            default:
                print("UNKNOWN ERROR")
            }
        }
    }
    
}
