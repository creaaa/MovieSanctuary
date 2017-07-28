
import APIKit
import Result
import Himotoki

/* Manager */


struct MovieDetailManager {
    
    // movie/{movie_id}/
    // 1. スタンダードなリクエスト
    struct StandardRequest: TMDbRequest {
        
        typealias Response = RLMMovie // HimotokiのDecodable準拠なデータモデル
        let movieID: Int
        var path:    String {
            return "/3/movie/" + movieID.description
        }
        var parameters: Any? {
            return [
                "api_key":            APIkey.TMDB_APIkey,
                "append_to_response": "videos,credits" // recommendations
            ]
        }
    }
    
    /*
    // movie/recommendation
    // 2. recommendationなリクエスト
    struct RecommendationRequest: TMDbRequest {
        
        typealias Response = RLMMovie // HimotokiのDecodable準拠なデータモデル
        let movieID: Int
        var path:    String {
            return "/3/movie/" + movieID.description + "/recommendations"
        }
        var parameters: Any? {
            return [
                "api_key":            APIkey.TMDB_APIkey,
                "append_to_response": "videos,credits" // recommendations
            ]
        }
    }
    */
    
    
    // スタンダードなリクエスト
    func request(id: Int, _ completion: @escaping (StandardRequest.Response) -> Void) {
        
        let request = StandardRequest(movieID: id)
        
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
