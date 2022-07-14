//
//  BaseService.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import RxSwift
import RxCocoa
import SVProgressHUD

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}

// MARK: -Flickr URL Components
struct API {
    static let baseURLString = "http://www.omdbapi.com/"
    static let apiKey = "b9bd48a6"
}

enum RequestError: Error {
    case unknown
}

class BaseService: BaseServiceProtocol {
    static func searchMovies(searchText: String, type: MediaType, page: Int) -> Observable<Result<SearchMovieResult?, Error>> {
        let baseURLString = API.baseURLString
        let parameters = [
            "apiKey" : API.apiKey,
            "type" : type.rawValue,
            "s" : searchText,
            "page" : "\(page)"
        ]
        return request(baseURLString, parameters: parameters)
            .map({ result in
                switch result {
                case .Success(let data):
                    var searchResult: SearchMovieResult?
                    do {
                        searchResult = try JSONDecoder().decode(SearchMovieResult.self, from: data)
                    } catch let parseError {
                        return Result<SearchMovieResult?, Error>.Failure(parseError)
                    }

                    return Result<SearchMovieResult?, Error>.Success(searchResult)
                case .Failure(let error):
                    return Result<SearchMovieResult?, Error>.Failure(error)
                }
            })
    }
    
    //MARK: - URL request
    static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        return Observable.create { observer in
            var components = URLComponents(string: baseURL)!
            components.queryItems = parameters.map(URLQueryItem.init)
            let url = components.url!
            var result: Result<Data, Error>?
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    result = Result<Data, Error>.Success(data)
                } else {
                    if let error = error {
                        result = Result<Data, Error>.Failure(error)
                    }
                }
                observer.onNext(result!)
                observer.onCompleted()
            }
            dataTask?.resume()
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}
