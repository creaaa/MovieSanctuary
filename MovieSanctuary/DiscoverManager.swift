
import APIKit
import Result
import Himotoki

/* Manager */

enum Genre: Int {
    
    case Adventure   = 12
    case Fantasy     = 14
    case Animation   = 16
    case Drama       = 18
    case Horror      = 27
    case Action      = 28
    case Comedy      = 35
    case History     = 36
    case Western     = 37
    case Thriller    = 53
    case Crime       = 80
    case Documentary = 99
    case SF          = 878
    case Mystery     = 9648
    case Music       = 10402
    case Romance     = 10749
    case Family      = 10751
    case War         = 10752
    case TVMovie     = 10770
    
}


struct DiscoverManager {
    
    // discover/movie
    // セクション【1】: MASTERPIECE で使われる
    struct MasterpieceRequest: TMDbRequest {
        
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
    
    // discover/movie
    // セクション【4-11】: 各ジャンル で使われる
    struct GenreRequest: TMDbRequest {
        
        // このAPIの問題は、ジャンルIDを複数指定した時、全部一緒くたにしてresultsを返すこと。
        // ジャンルごとに各セクションを用意しているのだから、
        // コール発行数が増えたとしても、各ジャンルごとに呼び出すべき。
        
        typealias Response  = SearchMovieResult // HimotokiのDecodable準拠なデータモデル
        let genre: Genre
        var path:  String {
            return "/3/discover/movie/"
        }
        var parameters: Any? {
            return [
                "api_key":     APIkey.TMDB_APIkey,
                "with_genres": genre.rawValue,
                "sort_by":     "vote_average.desc"
            ]
        }
        
    }
    
    
    // MASTERPIECEなリクエスト
    func request(completion: @escaping (MasterpieceRequest.Response) -> Void) {
        
        let request = MasterpieceRequest()
        
        Session.send(request) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // 各ジャンルなリクエスト
    func request(genre: Genre, completion: @escaping (MasterpieceRequest.Response) -> Void) {
        
        let request = GenreRequest(genre: genre)
        
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


