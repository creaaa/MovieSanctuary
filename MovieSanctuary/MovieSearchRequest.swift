
import APIKit
import Result
import Himotoki

/* Request */

protocol MovieSearchRequest: Request {}

extension MovieSearchRequest {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
    
}

extension MovieSearchRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}


/* Manager */

struct MovieSearchManager {
    
    struct StandardRequest: MovieSearchRequest {
        
        typealias Response = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        
        let query: String
        let page:  Int
        
        var path:  String {
            return "/3/search/movie"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey,
                "query"  : query,
                "page"   : page
            ]
        }
    }
    
    struct NowPlayingRequest: MovieDetailRequest {
        
        typealias Response = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        var path: String {
            return "/3/movie/now_playing"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey
            ]
        }
    }
    
    // スタンダード(クエリ検索)
    func request(query: String, page: Int, _ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest(query: query, page: page)
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // upcoming
    func request(_ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = NowPlayingRequest()
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}



