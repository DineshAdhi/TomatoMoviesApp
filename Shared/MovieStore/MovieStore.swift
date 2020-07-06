//
//  MovieStore.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 04/07/20.
//

import Foundation
import SwiftUI




public class MovieStore : MovieService {

    private let baseURL = "https://api.themoviedb.org/3"
    private let API_KEY = "a64ba79e33b9d05a263dee7bcc80a984"
    private init() {}
    public  static let shared = MovieStore()
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    func fetchMovies(endpoint: MovieEndpoint, params: [String : String]?, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
            
        guard var urlComponents = URLComponents(string : "\(baseURL)/movie/\(endpoint.rawValue)") else {
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: API_KEY)];
        
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(MovieError.invalidEndpoint)
            return;
        }
        
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let moviesResponse : MoviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(moviesResponse)
                }
            }
            catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    
    
    }
    
    
    func fetchMovie(id: Int, successHandler: @escaping (Movie) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(API_KEY)&append_to_response=videos,credits") else {
            handleError(errorHandler: errorHandler, error: MovieError.invalidEndpoint)
            return
        }
        
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    successHandler(movie)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
            }.resume()
    }
    
    func searchMovie(query: String, params: [String : String]?, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        guard var urlComponents = URLComponents(string : "\(baseURL)/search/movie") else {
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "api_key", value: API_KEY),
            URLQueryItem(name : "query", value: query)
        ];
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("URL ENDODING ISSUE")
            return
        }
        
        print(url.absoluteURL)
    
        urlSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let moviesResponse : MoviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    print(moviesResponse)
                    successHandler(moviesResponse)
                }
            }
            catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    }
    
    func getImageData(endpoint: String, imageDataType: ImageDataType, successHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        guard let url = URL(string : "\(imageDataType.rawValue)\(endpoint)") else {
            handleError(errorHandler: errorHandler, error: MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            DispatchQueue.main.async {
                successHandler(data)
            }
        }.resume()
        
    }
    
  
    
    
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    
    
}
