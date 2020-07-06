//
//  TVModel.swift
//  iOS
//
//  Created by Dineshadhithya V on 07/07/20.
//

import Foundation
import SwiftUI

public struct TVResponse: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

public struct TVImagesReponse : Codable {
    public let id : Int
    public let backdrops : [Backdrop]
    public let posters : [Poster]
}

