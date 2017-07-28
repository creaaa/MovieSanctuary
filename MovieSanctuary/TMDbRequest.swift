
import APIKit
import Himotoki


protocol TMDbRequest: Request {}

extension TMDbRequest {
    
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

extension TMDbRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
