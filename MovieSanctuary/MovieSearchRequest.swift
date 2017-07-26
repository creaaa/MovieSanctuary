
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
        
        typealias Response = ConciseMovie // HimotokiのDecodable準拠なデータモデル
        let query: String
        var path:  String {
            return "/3/search/movie"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey
            ]
        }
    }
    
    
    func request(query: String, _ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest(query: query)
        
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



