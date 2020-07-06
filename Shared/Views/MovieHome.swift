//
//  Home.swift
//  iOS
//
//  Created by Dineshadhithya V on 04/07/20.
//

import SwiftUI

struct MovieHomeView: View {
    
    @EnvironmentObject var movieHomeData : MovieHomeData
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(movieHomeData.movieCategory) { (category : MovieHomeRow) in
                    MovieRow(categoryName: category.categoryName, movies: category.movies)
                }
            }
        }
    }
}

struct MovieHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(MovieHomeData(endpoints: [.nowPlaying, .popular]))
    }
}
