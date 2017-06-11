
import APIKit
import Result
import Himotoki

protocol TMDB_IMDBidRequest: Request {}


extension TMDB_IMDBidRequest {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}


extension TMDB_IMDBidRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}


struct Request_TMDB_IMDBid: TMDB_IMDBidRequest {
    
    let movieID: Int
    
    typealias Response = MovieForIMDB_ID
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/3/movie/" + movieID.description
    }
    
    var parameters: Any? {
        return ["api_key": "5f215b9dfac50de053affb4f9085e620"]
    }
    
}
