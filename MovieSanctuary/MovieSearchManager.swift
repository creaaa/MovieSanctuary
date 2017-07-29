
import APIKit
import Result
import Himotoki


/* Manager */


struct MovieSearchManager {
    
    struct StandardRequest: TMDbRequest {
        
        typealias Response = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        
        let query: String
        let page:  Int
        
        var path:  String {
            return "/3/search/movie"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey,
                "query"  : query,
                "page"   : page
            ]
        }
    }
    
    
    // スタンダード(クエリ検索)
    func request(query: String, page: Int, _ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest(query: query, page: page)
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


