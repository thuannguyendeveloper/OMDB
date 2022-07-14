//
//  SearchMovieResult.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import UIKit

struct SearchMovieResult: Codable {
    let movies: [Movie]?
    let totalResults: String?
    let response: String

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}
