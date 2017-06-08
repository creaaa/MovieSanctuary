//
//import APIKit
//import Result
//
//
//struct Request_TMDB: Request {
//    
//    var baseURL: URL {
//        return URL(string: "https://api.themoviedb.org")!
//    }
//    
//    var method: HTTPMethod {
//        return .get
//    }
//    
//    var path: String {
//        return "/3/search/movie"
//    }
//    
//    /*
//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> <null> {
//        
//    }
//    */
//    
//}
//
//
//
///*
// 
//struct RateLimitRequest: Request {
//    
//    typealias Response = RateLimit
//    
//    var baseURL: URL {
//        return URL(string: "https://api.github.com")!
//    }
//    
//    var method: HTTPMethod {
//        return .get
//    }
//    
//    var path: String {
//        return "/rate_limit"
//    }
//    
//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RateLimit {
//        return try RateLimit(object: object)
//    }
//}
//
//struct RateLimit {
//    
//    let limit: Int
//    let remaining: Int
//    
//    init(object: Any) throws {
//        guard let dictionary = object as? [String: Any],
//            let rateDictionary = dictionary["rate"] as? [String: Any],
//            let limit = rateDictionary["limit"] as? Int,
//            let remaining = rateDictionary["remaining"] as? Int else {
//                throw ResponseError.unexpectedObject(object)
//        }
//        
//        self.limit = limit
//        self.remaining = remaining
//    }
//}
// 
//*/
//
