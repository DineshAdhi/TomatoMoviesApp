//
//  Movie.swift
//  MovieKit
//
//  Created by Alfian Losari on 11/24/18.
//  Copyright © 2018 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftUI

public struct MoviesResponse: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

public struct MovieImagesReponse : Codable {
    public let id : Int
    public let backdrops : [Backdrop]
    public let posters : [Poster]
}

public struct Backdrop : Codable {
    public let filePath : String
    public let height : Int
    public let width : Int
}

public struct Poster : Codable {
    public let filePath : String
    public let height : Int
    public let width : Int
}

extension Movie {
    
    static var testMovies: [Movie] {
        return [
            Movie.test1,
            Movie.test2,
        ]
    }
    
    static var testCasts : [MovieCast] {
        return [
            MovieCast(character: "Sigrit Ericksdottir", name: "Rachel McAdams", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Dinesh Adhithya", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Rachel Stewart", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Rachel Vera", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Arthur Fleck", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Naveen Chandhar", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
            MovieCast(character: "Sigrit Ericksdottir", name: "Rachel Hiden", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg"),
        ]
    }
    
    static var test1 : Movie {
        Movie(id: 23, title: "Aladdin", backdropPath: "/3lBDg3i6nn5R2NKFCJ6oKyUo2j5", posterPath: "/9zrbgYyFvwH8sy5mv9eT25xsAzL.jpg", overview: "A missing child causes four families to help each other for answers. What they could not imagine is that this mystery would be connected to innumerable other secrets of the small town.", releaseDate: "2012-07-05", voteAverage: 4.0, voteCount: 45, imdbId : nil, tagline: "Nobody wins solo", genres: [MovieGenre(name : "Action"), MovieGenre(name: "Thriller")], videos: nil, credits: MovieCreditResponse(cast : Movie.testCasts, crew: []), adult: true, runtime: 112, homepage: "https:/www.google.com", spokenLanguages: nil, productionCompanies: nil)
    }
    
    static var test2 : Movie {
        Movie(id: 23, title: "Aladdin", backdropPath: "/3lBDg3i6nn5R2NKFCJ6oKyUo2j5", posterPath: "/9zrbgYyFvwH8sy5mv9eT25xsAzL.jpg", overview: "A missing child causes four families to help each other for answers. What they could not imagine is that this mystery would be connected to innumerable other secrets of the small town.", releaseDate: "2012-07-05", voteAverage: 4.0, voteCount: 45, imdbId : "tt8580274", tagline: "Nobody wins solo", genres: [MovieGenre(name : "Action"), MovieGenre(name: "Thriller")], videos: nil, credits: MovieCreditResponse(cast : Movie.testCasts, crew: []), adult: true, runtime: 112, homepage: nil, spokenLanguages: nil, productionCompanies: nil)
    }
    
    static var cast : MovieCast {
        MovieCast(character: "Sigrit Ericksdottir", name: "Rachel McAdams", profilePath: "/1PoAxIDpFnc91QNumrtTUZF8LCE.jpg")
    }
}

public struct Movie: Codable, Identifiable  {
    
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let releaseDate: String
    public let voteAverage: Double
    public let voteCount: Int
    public let imdbId : String?
    public let tagline: String?
    public let genres: [MovieGenre]?
    public let videos: MovieVideoResponse?
    public let credits: MovieCreditResponse?
    public let adult: Bool
    public let runtime: Int?
    public let homepage: String?
    public let spokenLanguages: [SpokenLanguage]?
    public let productionCompanies: [ProductionCompany]?
    
    public var casts: [MovieCast]? {
        return credits?.cast
    }
    
    public var crews: [MovieCrew]? {
        return credits?.crew
    }
    
    public var movieVideos: [MovieVideo]? {
        return videos?.results
    }
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    public var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    public var voteAveragePercentText: String {
        return "\(Int(voteAverage * 10))%"
    }
    
    public var genreText: String? {
        guard let movieGenres = self.genres else {
            return nil
        }
        return movieGenres.map { $0.name }.joined(separator: ", ")
    
    }
    
    public var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
    
//    public var yearText: String {
//        return Movie.yearFormatter.string(from: self.releaseDate)
//    }
    
    public var durationText: String? {
        guard let runtime = self.runtime else {
            return nil
        }
        
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60)
    }
    
    public var homepageURL: URL? {
        guard let homepage = self.homepage else {
            return nil
        }
        return URL(string: homepage)
    }
    
    public var imdbURL: URL? {
        guard let imdbId = self.imdbId else {
            return nil
        }
        
        let url = "https://www.imdb.com/title/\(imdbId)"
        
        return URL(string: url)
    }
}

public struct MovieGenre: Codable {
    let name: String
}

public struct MovieVideoResponse: Codable {
    public let results: [MovieVideo]
}

public struct MovieVideo: Codable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let size: Int
    public let type: String
    
    public var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

public struct MovieCreditResponse: Codable {
    public let cast: [MovieCast]
    public let crew: [MovieCrew]
}

public struct MovieCast: Codable {
    public let character: String
    public let name: String

    public let profilePath: String?
    
    public var profileURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }
        
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")!
    }
    
}

public struct MovieCrew: Codable {
    public let id: Int
    public let department: String
    public let job: String
    public let name: String
    
    public let profilePath: String?
    public var profileURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")!
    }
    
}

public struct ProductionCompany: Codable {
    
    public let name: String
    public let originCountry: String
    
    public let logoPath: String?
    public var logoURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")!
    }
    
}

public struct SpokenLanguage: Codable {
    public let name: String
    
}


