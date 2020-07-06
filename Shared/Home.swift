//
//  Home.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 06/07/20.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
    enum NavigationBarTitle : String {
        case Movies
        case TVSeries = "TV Series"
        case Search
    }
    
    @State var navTitle : NavigationBarTitle = .Movies
    
    var tabColor : Color {
        return (colorScheme == .dark) ? .white : .black
    }
    
    var body: some View {
        NavigationView {
            TabView(selection : $navTitle) {
                
                MovieHomeView()
                    .environmentObject(MovieHomeData(endpoints: [.nowPlaying, .popular]))
                    .tag(NavigationBarTitle.Movies)
                    .tabItem {
                        
                        VStack {
                            Image(systemName: "film")
                            Text("Movies")
                        }
                    }
                
                Text("TV")
                    .tag(NavigationBarTitle.TVSeries)
                    .tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("TV")
                        }
                    }
                
                MovieSearchView()
                    .tag(NavigationBarTitle.Search)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
            }
            .navigationTitle(navTitle.rawValue)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
        
    }
}
