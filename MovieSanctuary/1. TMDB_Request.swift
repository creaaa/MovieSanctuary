
import APIKit
import Result
import Himotoki


protocol TMDBRequest: Request {}

extension TMDBRequest {
    
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

extension TMDBRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}

