//
//  CircularProgressView.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 05/07/20.
//

import SwiftUI

struct RatingsView : View {
    
    @State var rating : CGFloat
    @State var itr : CGFloat = .zero
    
    var body : some View {
        ZStack {
            Circle()
                .trim(from : 0, to : itr/10)
                .stroke(style : StrokeStyle(lineWidth : 5.0, lineCap : .round))
                .rotationEffect(Angle(degrees : 150))
            
            Circle()
                .stroke(style : StrokeStyle(lineWidth : 2.0))
                .rotationEffect(Angle(degrees : 150))
                .opacity(0.2)
            
            VStack(spacing : 5) {
                Text(String(format : "%.1f", rating))
                Image(systemName : "star.fill")
            }
        }
        .foregroundColor(Color("DetailAccentColor"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation {
                    itr = rating;
                }
            }
        }
    }
}

struct RatingsCount : View {
    
    var ratingCount : Int
    
    var body : some View {
        VStack {
            Image(systemName : "hand.thumbsup.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("\(ratingCount)")
        }
        .foregroundColor(Color("DetailAccentColor"))
    }
    
}




struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RatingsCount(ratingCount: 2343)
                .frame(width : 100, height : 100)
            
            RatingsView(rating: 7.5)
                .frame(width : 100, height : 100)
        }
    }
}
