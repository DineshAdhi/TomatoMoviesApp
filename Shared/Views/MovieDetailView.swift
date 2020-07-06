//
//  MovieDetailView1.swift
//  Tomato Movies App
//
//  Created by Dineshadhithya V on 04/07/20.
//

import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject var movieItemData : MovieItemData
    
    var movie : Movie {
        return movieItemData.movie
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    private let posterViewHeight = (UIScreen.main.bounds.height/100) * 80
    private let footerViewHeight = (UIScreen.main.bounds.height/100) * 20
    
    
    var body: some View {
        
        ScrollView(showsIndicators : false) {
            
            VStack(spacing : 0) {
                VStack {
                    GeometryReader { reader in
                        ZStack {
                            ImageViewContainer(imageType: .Poster, imageEndPoint: movie.posterPath!)
                                .aspectRatio(contentMode: .fill)
                                .frame(width : UIScreen.main.bounds.width, height : self.getHeightForHeaderImage(reader))
                                .offset(y: self.getOffsetForHeaderImage(reader))
                                .clipped()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
                            
                            VStack {
                                Spacer()
                                VStack {
                                    Text(movie.title)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .lineLimit(1)
                                    
                                    HStack {
                                        Text(movie.durationText ?? "Unknown Duration")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        
                                        Text("|  " + movie.releaseDate)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        
                                        if movie.adult {
                                            Text("|  18+")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(height : posterViewHeight + self.getPosterHeightOffset(reader))
                    }
                    .frame(height : posterViewHeight)
                }
                
                
                DetailFooterView(footerViewHeight: footerViewHeight, movie: movie)
                
                Divider()
                
                
                VStack(spacing : 20) {
                    if movie.casts != nil {
                        CastsRow(casts: movie.casts!)
                        Divider()
                    }

                    VStack(alignment : .leading, spacing : 10) {
                        Text("Overview")
                            .font(.headline)

                        Text(movie.overview)
                    }
                    .padding(.horizontal)

                     Divider()
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear { movieItemData.loadMovie() }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }))
        
    }
    
    
    
    
    var backButton : some View {
        Button(action : {
            self.presentationMode.wrappedValue.dismiss();
        }) {
            Image(systemName: "arrow.left")
                .renderingMode(.original)
                .frame(width : 35, height : 35)
                .background(Color.white)
                .clipShape(Circle())
        }
    }
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getPosterHeightOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        if(offset <= 0) {
            return offset/5
        }
        
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = posterViewHeight
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // 3 (values will range from 0 - 1)
        return blur * 6 // Values will range from 0 - 6
    }
    
}



struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieDetailView(movieItemData: MovieItemData(movie : Movie.testMovies[0]))
                .preferredColorScheme(.dark)
        }
    }
}

