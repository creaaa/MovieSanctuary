
import UIKit
import APIKit
import Result
import Himotoki


struct OMDB_APIManager {
    
    struct Request_OMDB: OMDBRequest {
        
        typealias Response = OMDB_Movie
        
        let movieID: String
        var method: HTTPMethod { return .get }
        var path:   String     { return "" }
        var parameters: Any? {
            return [
                "i":      self.movieID,
                "plot":   "full",
                "apikey": APIkey.OMDB_APIkey
            ]
        }
    }
    
    func request(id: String,
                 _ completion:   @escaping (Request_OMDB.Response) -> Void,
                 _ errorHundler: @escaping () -> Void) {
        
        let request = Request_OMDB(movieID: id)
        
        Session.send(request) { result in
            switch result {
                case .success(let response):
                    completion(response)
                case .failure(.responseError(let keyPathError as DecodeError)):
                    switch keyPathError {
                        case .missingKeyPath(_):
                            print(keyPathError.description)
                            errorHundler()
                        default:
                            break
                    }
                case .failure(let error):
                    print("Unknown error: \(error)")
            }
        }
    }
    
}

