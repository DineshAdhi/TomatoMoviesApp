//
//  MovieSearchView.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 06/07/20.
//

import SwiftUI

struct MovieSearchView: View {
    
    @State var query : String = ""
    
    @ObservedObject var movieQueryData : MovieQueryData = MovieQueryData(list: [])
    
    var body: some View {
            ScrollView {
                
                SearchBarView(searchTextField : $query, movieQueryData: movieQueryData)
                    .padding()
                
                if !movieQueryData.movieList.isEmpty {
                    VStack {
                        ForEach(movieQueryData.movieList) { (movie : Movie) in
                            if movie.posterPath != nil {
                                NavigationLink(destination : MovieDetailView(movieItemData : MovieItemData(movie: movie))) {
                                    
                                    MovieItemCard(movie : movie)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                else {
                    VStack {
                        Spacer()
                        Text(movieQueryData.queryStatusMessage)
                        Spacer()
                    }
                    .frame(maxWidth : .infinity)
                    .padding()
                    .offset(y : 150)
                }
                
                    
            }
            .frame(maxWidth : .infinity)
    }
}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView(movieQueryData: MovieQueryData(list: Movie.testMovies))
            .preferredColorScheme(.light)
    }
}

struct MovieItemCard: View {
    
    @State var movie : Movie
    
    var body: some View {
        VStack {
            HStack {
                ImageViewContainer(imageType: .Thumbnail, imageEndPoint: movie.posterPath!)
                    .aspectRatio(contentMode: .fit)
                    .frame(width : 100)
                
                VStack(alignment : .leading, spacing : 10) {
                    
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(Color.primary)
                    Text(movie.overview)
                        .font(.caption2)
                        .foregroundColor(Color.primary)
                        .lineLimit(4)
                    Spacer()
                    
                    VStack {
                        HStack(spacing : 5) {
                            Text(String(format : "%.1f", movie.voteAverage))
                                .font(.callout)
                                .foregroundColor(Color.primary)
                            
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width : 13)
                                .foregroundColor(Color("DetailAccentColor"))
                        }
                    }
                    
                }
                .padding()
                
                Spacer()
            }
            
            Divider()
        }
        
    }
}

struct SearchBarView: View {
    
    @Binding var searchTextField : String
    @State var showSearchCloseButton : Bool = false
    
    @ObservedObject var movieQueryData : MovieQueryData
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    var body: some View {
        HStack(spacing : 15) {
            Image(systemName: "magnifyingglass").font(Font.headline.weight(.medium))
            TextField("Search", text: $searchTextField
                      ,onEditingChanged: { isEditing in
                        withAnimation {
                            self.showSearchCloseButton = isEditing
                        }
                      }, onCommit : {
                            self.movieQueryData.query(query: searchTextField)
                    })
            
            if(self.showSearchCloseButton) {
                Button(action : {
                    self.searchTextField = ""
                    self.showSearchCloseButton = false
                    self.movieQueryData.query(query: "")
                }) {
                    Text("Cancel")
                }
            }
        }
        .frame(height : 20)
        .padding(12)
        .background(getBackgroundColor())
        .cornerRadius(10)
    }
    
    func getBackgroundColor() -> Color {
        
        if(colorScheme == .dark) {
            return Color.gray.opacity(0.2)
        }
        
        return Color.gray.opacity(0.3)
    }
}
