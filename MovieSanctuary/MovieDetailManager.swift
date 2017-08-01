
import APIKit
import Result
import Himotoki

/* Manager */

struct MovieDetailManager {
    
    // movie/{movie_id}/
    // 1. スタンダードなリクエスト
    struct StandardRequest:   TMDbRequest {
        typealias Response  = RLMMovie // HimotokiのDecodable準拠なデータモデル
        let movieID: Int
        var path:    String {
            return "/3/movie/" + movieID.description
        }
        var parameters: Any? {
            return [
                "api_key":            APIkey.TMDB_APIkey,
                "append_to_response": "videos,credits,recommendations"
            ]
        }
    }
    
    // movie/now_playing/
    // 2. 現在公開中の映画一覧
    struct NowPlayingRequest: TMDbRequest {
        
        typealias Response = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        var path:    String {
            return "/3/movie/now_playing"
        }
        var parameters: Any? {
            return [
                "api_key": APIkey.TMDB_APIkey
            ]
        }
        
    }
    
    // スタンダードなリクエスト(映画ポスターセル、もしくは検索結果セルをタップして詳細画面に遷移する時にコールされる)
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
    
    // now playingのリクエスト
    func request(completion: @escaping (NowPlayingRequest.Response) -> Void) {
        
        let request = NowPlayingRequest()
        
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
