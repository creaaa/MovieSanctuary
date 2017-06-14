
import APIKit
import Result
import Himotoki


struct OMDB_APIManager {
    
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
                "i":      self.movieID,
                "plot":   "full",
                "apikey": "f462ae21"
            ]
        }
        
    }
    
    func request(id: String) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_OMDB(movieID: id)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
                        
            switch result {
            case .success(let response):
                NotificationCenter.default.post(name: Notification.Name("TMDB_OMDB"), object: response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

