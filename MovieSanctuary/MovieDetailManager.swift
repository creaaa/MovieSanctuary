
import APIKit
import Result
import Himotoki


/* Request */

protocol MovieDetailRequest: Request {}

extension MovieDetailRequest {
    
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

extension MovieDetailRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}


/* Manager */

protocol Manager {
    var page: Int { get set }
}

struct MovieDetailManager {
    
    struct StandardRequest: MovieDetailRequest {
        
        typealias Response = Movie // HimotokiのDecodable準拠なデータモデル
        let movieID: Int
        var path:    String {
            return "/3/movie/" + movieID.description
        }
        var parameters: Any? {
            return ["api_key": APIkey.TMDB_APIkey]
        }
        
    }
    
    func request(id: Int, _ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest(movieID: id)
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
