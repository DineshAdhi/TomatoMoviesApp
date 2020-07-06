//
//  ImageViewContainer.swift
//  MovieAPIDB
//
//  Created by Dineshadhithya V on 28/06/20.
//

import SwiftUI


class ImageData : ObservableObject {
    
    private static let imageCache = NSCache<AnyObject, AnyObject>()
    private let movieService : MovieService = MovieStore.shared
    
    @Published var data : Data = Data()
    
    init(imageType : ImageDataType, imageEndpoint : String) {
        
        let key = imageEndpoint + imageType.rawValue
        
        if let imageCacheData = ImageData.imageCache.object(forKey: key as AnyObject) as? Data {
            self.data = imageCacheData as Data
            return
        }
        
        movieService.getImageData(endpoint: imageEndpoint, imageDataType: imageType) { (data) in
            ImageData.imageCache.setObject(data as AnyObject, forKey: key as AnyObject)
            DispatchQueue.main.async {
                self.data = data;
            }
        } errorHandler: { (error) in
            print(error.localizedDescription)
            return
        }
    }
    
    init() {
        self.data = Data();
    }
}


struct ImageViewContainer: View {
    
    @ObservedObject var imageData : ImageData
    
    init(imageType : ImageDataType, imageEndPoint : String) {
        self.imageData = ImageData(imageType : imageType, imageEndpoint: imageEndPoint)
    }
    
    init(imageData : ImageData) {
        self.imageData = imageData
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data : imageData.data) ?? UIImage(imageLiteralResourceName: "TestPosterImage"))
                .resizable()
                .renderingMode(.original)
                .opacity(imageData.data.isEmpty ? 0.0 : 1.0)
                .background(Color.clear)

                if(imageData.data.isEmpty) {
                    ProgressView().scaleEffect(2.0)
                }
        }
    }
}

struct ImageViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageViewContainer(imageData: ImageData())
                .preferredColorScheme(.dark)
        }
    }
}
