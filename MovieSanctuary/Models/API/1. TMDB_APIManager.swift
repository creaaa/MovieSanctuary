
import APIKit
import Result
import Himotoki


protocol Manager {
    var page: Int { get set }
}

/* 1 */

struct TMDB_APIManager: Manager {
    
    func request(completion: @escaping (Request_TMDB.Response) -> Void) {
        
        let request = Request_TMDB(query: self.query, page: self.page)
        
        print("generated request: ", request)
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
        
    }

    struct Request_TMDB: TMDBRequest {
        
        let query: String
        var page:  Int
        
        typealias Response = ConciseMovieInfo
        
        var path: String {
            return "/3/search/movie"
        }
        
        var parameters: Any? {
            return ["api_key": APIkey.TMDB_APIkey,
                    "query":   self.query,
                    "page" :   self.page
            ]
        }
        
    }
    
    var query: String
    var page:  Int = 1
    
    /*
    func request(_ completion: @escaping (Request_TMDB.Response) -> Void) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB(query: self.query, page: self.page)
        
        print("generated request: ", request)
        
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
    */
  
    
    
    init(query: String) {
        self.query = query
    }
    
    
}


//struct Request_TMDB_Concise: TMDBRequest {
//    
//    let query: String
//    var page:  Int
//    
//    typealias Response = ConciseMovieInfo
//    
//    var path: String {
//        return "/3/search/movie"
//    }
//    
//    var parameters: Any? {
//        return ["api_key": APIkey.TMDB_APIkey,
//                "query":   self.query,
//                "page" :   self.page
//        ]
//    }
//    
//}



/* 2 */

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


/* 3 */

struct TMDB_Genre_Manager: Manager {
    
    struct Request_TMDB: TMDBRequest {
        
        var page:  Int
        let genreID: Int
        
        typealias Response = ConciseMovieInfo
        
        var path: String {
            return "/3/discover/movie"
        }
        
        var parameters: Any? {
            return ["api_key": APIkey.TMDB_APIkey,
                    "with_genres" : self.genreID,
                    "sort_by": "popularity.desc",
                    "page" :   self.page
            ]
        }
        
    }
    
    var page: Int = 1
    let genreID: Int
    
    init(genreID: Int) {
        self.genreID = genreID
    }
    
    
    func request(completion: @escaping (Request_TMDB.Response) -> Void) {
        
        let request = Request_TMDB(page: self.page, genreID: self.genreID) // Request_TMDB(genreID: self.genreID)
        
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







