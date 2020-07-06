//
//  MovieRow.swift
//  iOS
//
//  Created by Dineshadhithya V on 04/07/20.
//

import SwiftUI

struct MovieRow: View {
    
    var categoryName : String
    var movies : [Movie] = [Movie]()
    
    var body: some View {
        ZStack {
                VStack(alignment : .leading) {
                    Text(categoryName)
                        .bold()
                        .padding(.leading, 16)
                    ScrollView(.horizontal, showsIndicators : false) {
                        HStack {
                                ForEach(filterMovies(), id: \.id) { (movie : Movie) in
                                    LazyVStack {
                                        NavigationLink(destination : MovieDetailView(movieItemData: MovieItemData(movie: movie))) {
                                            ImageViewContainer(imageType: .Thumbnail, imageEndPoint: movie.posterPath!)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width : 100)
                                                .shadow(radius: 5)
                                                .cornerRadius(10.0)
                                        }
                                    }
                                    .padding(.leading, 8)
                                }
                        }
                        .padding(.horizontal, 8)
                    }
                }
        }
    }
    
    func filterMovies() -> [Movie] {
        
        return self.movies.filter { (movie) -> Bool in
            return (movie.posterPath != nil)
        }
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieRow(categoryName: "Popular", movies: Movie.testMovies)
        }
    }
}
