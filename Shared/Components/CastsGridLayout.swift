//
//  CastsGridLayout.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 05/07/20.
//

import SwiftUI

struct CastsGridLayout: View {
    
    @State var casts : [MovieCast]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Casts")
                    .font(.title)
                    .padding()
                
                LazyVGrid(columns : columns, alignment : .center) {
                    ForEach(casts, id : \.name) { (cast:MovieCast) in
                        CastItem(cast : cast, isCharacterVisible: false)
                    }
                    .padding(.bottom)
                }
                .padding(.trailing)
                .padding(.vertical)
            }
        }
    }
}

struct CastsGridLayout_Previews: PreviewProvider {
    static var previews: some View {
        CastsGridLayout(casts : Movie.testCasts)
    }
}
