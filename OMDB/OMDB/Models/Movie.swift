//
//  Movie.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import UIKit

struct Movie: Codable {
    var title: String = ""
    var year: String = ""
    var imdbID: String = ""
    var type: String = ""
    var poster: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
        
        case imdbID
    }
}
