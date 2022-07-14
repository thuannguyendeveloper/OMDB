//
//  BaseServiceProtocol.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import Foundation
import RxSwift

protocol BaseServiceProtocol {
    static func searchMovies(searchText: String, type: MediaType, page: Int) -> Observable<Result<SearchMovieResult?, Error>>
}
