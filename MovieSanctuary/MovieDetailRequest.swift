
import APIKit
import Result
import Himotoki


protocol Manager {
    var page: Int { get set }
}

struct TMDB_OMDBidManager {
    
    struct Request_TMDB_IMDBid: TMDBRequest {
        
        typealias Response = MovieForIMDB_ID
        
        let movieID: Int
        var path:    String {
            return "/3/movie/" + movieID.description
        }
        var parameters: Any? {
            return ["api_key": APIkey.TMDB_APIkey]
        }
        
    }
    
    func request(id: Int, _ completion: @escaping (Request_TMDB_IMDBid.Response) -> Void) {
        
        let request = Request_TMDB_IMDBid(movieID: id)
        
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
