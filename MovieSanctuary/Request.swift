
import APIKit
import Result
import Himotoki


protocol TMDBRequest: Request {}


extension TMDBRequest {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    /*
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
    */
    
}


extension TMDBRequest where Response: Decodable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
    
}


struct Request_TMDB: TMDBRequest {
 
    typealias Response = ConciseMovieInfo
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/3/search/movie"
    }
    
    var parameters: Any? {
        return ["api_key": "5f215b9dfac50de053affb4f9085e620",
                "query":   "butterfly%20effect"
               ]
    }
    
    
    // ここ、返り値があってなくて、くそわかりにくい一生エラー出てた。 上の typealiasと型を合わせなくてはいけない。
    
    /*
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ConciseMovieInfo {
        
        print(object)
        print(urlResponse)
        
        return try ConciseMovieInfo.decode(object as! Extractor)
    }
    */
    
    
    
    
}

