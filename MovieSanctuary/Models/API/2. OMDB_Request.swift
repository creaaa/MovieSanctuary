//
//import APIKit
//import Result
//import Himotoki
//
//
//protocol OMDBRequest: Request {}
//
//extension OMDBRequest {
//    
//    var baseURL: URL {
//        return URL(string: "http://www.omdbapi.com")!
//    }
//    
//    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
//        
//        guard (200..<300).contains(urlResponse.statusCode) else {
//            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
//        }
//        
//        return object
//    }
//}
//
//extension OMDBRequest where Response: Decodable {
//    
//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
//        return try decodeValue(object)
//    }
//    
//}
//
//
//
//
//
//
//
