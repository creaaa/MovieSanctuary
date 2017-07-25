//
//import APIKit
//import Result
//import Himotoki
//
//
//protocol Manager {
//    var page: Int { get set }
//}
//
///* 1 */
//
///* search by query(movie title) */
//
//struct TMDB_APIManager: Manager {
//
//    struct Request_TMDB: TMDBRequest {
//        
//        typealias Response = ConciseMovieInfo
//
//        var path:  String {
//            return "/3/search/movie"
//        }
//        let query: String
//        var page:  Int
//        var parameters: Any? {
//            return ["api_key": APIkey.TMDB_APIkey,
//                    "query":   self.query,
//                    "page" :   self.page
//                   ]
//        }
//        
//    }
//    
//    var query: String
//    var page:  Int = 1
//
//    init(query: String) {
//        self.query = query
//    }
//    
//    
//    func request(completion: @escaping (Request_TMDB.Response) -> Void) {
//        
//        let request = Request_TMDB(query: self.query, page: self.page)
//        
//        print("generated request: ", request)
//        
//        Session.send(request) { result in
//            switch result {
//                case .success(let response):
//                    completion(response)
//                case .failure(let error):
//                    // no need to write switch any more if I use "if case" 😋
//                    if case .connectionError = error {
//                        print("No network...")
//                    }
//            }
//        }
//    }
//    
//    
//}
//
//
///* search by genre */
//
//struct TMDB_Genre_Manager: Manager {
//    
//    struct Request_TMDB: TMDBRequest {
//        
//        typealias Response = ConciseMovieInfo
//        
//        var page:    Int
//        let genreID: Int
//        var path:    String {
//            return "/3/discover/movie"
//        }
//        var parameters: Any? {
//            return ["api_key": APIkey.TMDB_APIkey,
//                    "with_genres" : self.genreID,
//                    "sort_by": "popularity.desc",
//                    "page" :   self.page
//            ]
//        }
//    }
//    
//    var page:    Int = 1
//    let genreID: Int
//    
//    init(genreID: Int) {
//        self.genreID = genreID
//    }
//    
//    func request(completion: @escaping (Request_TMDB.Response) -> Void) {
//        
//        let request = Request_TMDB(page: self.page, genreID: self.genreID)
//        
//        Session.send(request) { result in
//            switch result {
//                case .success(let response):
//                    completion(response)
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
//    
//}
//
//
///* 2 */
//
///* bridge from TMDb to OMDb passing movie's IMDB id */
//
//struct TMDB_OMDBidManager {
//    
//    struct Request_TMDB_IMDBid: TMDBRequest {
//        
//        typealias Response = MovieForIMDB_ID
//        
//        let movieID: Int
//        var path:    String {
//            return "/3/movie/" + movieID.description
//        }
//        var parameters: Any? {
//            return ["api_key": APIkey.TMDB_APIkey]
//        }
//        
//    }
//    
//    func request(id: Int, _ completion: @escaping (Request_TMDB_IMDBid.Response) -> Void) {
//        
//        let request = Request_TMDB_IMDBid(movieID: id)
//        
//        Session.send(request) { result in
//            switch result {
//                case .success(let response):
//                    completion(response)
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
//}
//
//
