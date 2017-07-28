
import APIKit
import Result
import Himotoki

/* Manager */

struct DiscoverManager {
    
    // discover/movie
    struct StandardRequest: TMDbRequest {
        
        typealias Response  = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        var path: String {
            return "/3/discover/movie/"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey,
                "sort_by": "vote_average.desc"
            ]
        }
        
    }
    
    
    // スタンダードなリクエスト
    func request(completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest()
        
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


