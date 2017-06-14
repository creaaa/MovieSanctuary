
import APIKit
import Result
import Himotoki


struct TMDB_APIManager {
    
    struct Request_TMDB_Concise: TMDBRequest {
        
        let query: String
        let page:  Int
        
        typealias Response = ConciseMovieInfo
        
        var path: String {
            return "/3/search/movie"
        }
        
        var parameters: Any? {
            return ["api_key": "5f215b9dfac50de053affb4f9085e620",
                    "query":   self.query,
                    "page" :   self.page
            ]
        }
    }
    
    func request(query: String, page: Int = 1, _ completion: @escaping (Request_TMDB_Concise.Response) -> Void) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB_Concise(query: query, page: page)
        
        // Session receives an instance of a type that conforms to Request.
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
    
    
    func request(id: Int, _ completion: @escaping (Request_TMDB_IMDBid.Response) -> Void) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB_IMDBid(movieID: id)
        
        // Session receives an instance of a type that conforms to Request.
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

