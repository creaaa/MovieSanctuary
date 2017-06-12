
import APIKit
import Result
import Himotoki


protocol OMDBRequest: Request {}

extension OMDBRequest {
    
    var baseURL: URL {
        return URL(string: "http://www.omdbapi.com")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}


extension OMDBRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}


struct Request_OMDB: OMDBRequest {
    
    let movieID: String
    
    typealias Response = OMDB_Movie
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var parameters: Any? {
        return [
            "i": self.movieID,
            "api_key": "f462ae21"
        ]
    }
    
}
