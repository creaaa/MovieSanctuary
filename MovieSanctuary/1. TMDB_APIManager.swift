
import APIKit
import Result
import Himotoki


struct TMDB_APIManager {
    
    struct Request_TMDB_Concise: TMDBRequest {
        
        let query: String
        
        typealias Response = ConciseMovieInfo
        
        var path: String {
            return "/3/search/movie"
        }
        
        var parameters: Any? {
            return ["api_key": "5f215b9dfac50de053affb4f9085e620",
                    "query":   self.query
            ]
        }
    }
    
    func request(query: String, _ comp: @escaping (Request_TMDB_Concise.Response) -> Void) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB_Concise(query: query)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
            switch result {
                case .success(let response):
                    comp(response)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    /*
    func success(_ response: Request_TMDB_Concise.Response, _ comp: (TMDB_APIManager.Request_TMDB_Concise.Response) -> Void) {
        NotificationCenter.default.post(name: Notification.Name("JSONresult"), object: response)
        comp(response)
    }
 
    func failure(_ error: SessionTaskError) {
        print(error)
    }
    */
    
}


struct TMDB_OMDBidManager {
    
    struct Request_TMDB_IMDBid: TMDBRequest {
        
        let movieID: Int
        
        typealias Response = MovieForIMDB_ID
        
        var path: String {
            return "/3/movie/" + movieID.description
        }
        
        var parameters: Any? {
            return ["api_key": "5f215b9dfac50de053affb4f9085e620"]
        }
    }
    
    func request(id: Int) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB_IMDBid(movieID: id)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
            
            switch result {
            case .success(let response):
                self.success(response)
                
            case .failure(let error):
                self.failure(error)
            }
        }
    }
    
    func success(_ response: Request_TMDB_IMDBid.Response) {
        let id = response.imdb_id
        OMDB_APIManager().request(id: id)
    }
    
    func failure(_ error: SessionTaskError) {
        print(error)
    }
    
}


