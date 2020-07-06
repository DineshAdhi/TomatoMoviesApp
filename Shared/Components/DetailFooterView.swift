//
//  DetailFooterView.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 05/07/20.
//

import SwiftUI

struct DetailFooterView: View {
    
    var footerViewHeight : CGFloat
    var movie : Movie
    
    var body: some View {
        HStack {
            
            RatingsCount(ratingCount: movie.voteCount)
            
            Spacer()
            
            RatingsView(rating: CGFloat(movie.voteAverage))
            
            Spacer()
            
            
            if movie.imdbURL != nil {
                Link(destination: movie.imdbURL!) {
                    Image("IMDBLogo")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
            }
            else if movie.homepageURL != nil {
                Link(destination: movie.homepageURL!) {
                    Image(systemName: "safari")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("DetailAccentColor"))
                }
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal)
        .frame(height : footerViewHeight)
        .background(Color.black)
    }
}

struct DetailFooterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DetailFooterView(footerViewHeight: (UIScreen.main.bounds.height/100) * 20, movie: Movie.testMovies[1])
            
            DetailFooterView(footerViewHeight: (UIScreen.main.bounds.height/100) * 20, movie: Movie.testMovies[0])
        }
    }
}
