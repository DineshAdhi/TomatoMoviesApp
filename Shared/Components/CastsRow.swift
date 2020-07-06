//
//  CastsRow.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 04/07/20.
//

import SwiftUI

struct CastsRow : View {
    
    var casts : [MovieCast]
    
    @State var showCastSheet : Bool = false
    
    var body : some View {
        
        VStack(alignment : .leading, spacing : 0) {
            
            HStack {
                Text("Casts")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Button(action : {
                    showCastSheet.toggle();
                }) {
                    Text("Show All")
                        .font(.caption)
                        .padding()
                }
            }
            
            ScrollView(.horizontal, showsIndicators : false) {
                LazyHStack {
                    ForEach(filterCasts(), id: \.name) { (cast : MovieCast) in
                        CastItem(cast : cast)
                    }
                }
            }
        }
        .sheet(isPresented: $showCastSheet) {
            CastsGridLayout(casts: filterCastsWithProfilePath())
        }
    }
    
    func filterCastsWithProfilePath() -> [MovieCast] {
        let profilePathCasts = self.casts.filter { (cast) -> Bool in
            return cast.profilePath != nil
        }
        
        return profilePathCasts
    }
    
    func filterCasts() -> [MovieCast] {
        return Array(filterCastsWithProfilePath().prefix(10))
    }
}


struct CastsRow_Previews: PreviewProvider {
    static var previews: some View {
        CastsRow(casts: Movie.testCasts)
            .frame(height : 200)
            .preferredColorScheme(.dark)
    }
}

struct CastItem: View {
    
    var cast : MovieCast
    var isCharacterVisible : Bool = true
    
    var body: some View {
        VStack {
            ImageViewContainer(imageType: .Thumbnail, imageEndPoint: cast.profilePath!)
                .aspectRatio(contentMode: .fill)
                .frame(width : 100, height : 110)
                .clipShape(Circle())
            
            VStack(spacing : 2) {
                Text(cast.name)
                    .font(.caption)
                
                if isCharacterVisible {
                    Text("(" + cast.character + ")")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                }
            }
        }
        .padding(.leading, 15)
    }
}
