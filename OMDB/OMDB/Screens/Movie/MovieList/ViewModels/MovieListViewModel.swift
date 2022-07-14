//
//  MovieListViewModel.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import RxCocoa
import RxSwift

public enum MediaType: String {
    case movie = "movie"
}

class MovieListViewModel {
    
    private let bag = DisposeBag()
    var apiType: BaseServiceProtocol.Type = BaseService.self
    
    // MARK: - Input
    var searchText: String = ""
    var type: MediaType = .movie
    
    // MARK: - Output
    var dataObservable: Observable<SearchMovieResult?> = Observable.just(nil)
    
    // MARK: - Init
    func load(searchText: String, type: MediaType, page: Int, apiType: BaseServiceProtocol.Type) {
        self.searchText = searchText
        self.apiType = apiType
        dataObservable = apiType
            .searchMovies(searchText: searchText, type: type, page: page)
            .flatMap ({resultNSURL -> Observable<Result<SearchMovieResult?, Error>> in
                return self.apiType.searchMovies(searchText: searchText, type: type, page: page)
            })
            .map() { result -> SearchMovieResult? in
                switch result {
                case .Success(let result):
                    return result
                case .Failure:
                    return nil
                }
            }
    }
    
    func loadData(page: Int) {
        self.load(searchText: searchText,
                  type: type,
                  page: page,
                  apiType: apiType)
    }
}
