
import APIKit
import Result
import Himotoki

/* Manager */

enum Genre: Int {
    
    case adventure   = 12
    case fantasy     = 14
    case animation   = 16
    case drama       = 18
    case horror      = 27
    case action      = 28
    case comedy      = 35
    case history     = 36
    case western     = 37
    case thriller    = 53
    case crime       = 80
    case documentary = 99
    case SF          = 878
    case mystery     = 9648
    case music       = 10402
    case romance     = 10749
    case family      = 10751
    case war         = 10752
    case TVMovie     = 10770
    
    static let genres: [Genre] = [.adventure, .fantasy, .horror,.action,
                                  .comedy, .history, .romance, .family]
    
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
            let cond =
                arc4random_uniform(2) % 2 == 0 ? "vote_average.desc" : "popularity.desc"
            return [
                "api_key": APIkey.TMDB_APIkey,
                "sort_by": cond,
                "vote_count.gte" : 100
            ]
        }
        
    }
    
    // discover/movie
    // セクション【3-10】: 各ジャンル で使われる
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
            let cond =
                arc4random_uniform(2) % 2 == 0 ? "vote_average.desc" : "popularity.desc"
            return [
                "api_key":     APIkey.TMDB_APIkey,
                "with_genres": genre.rawValue,
                "sort_by":     cond,
                "vote_count.gte" : 100
            ]
        }
        
    }
    
        
    // セクション[1]: MASTERPIECEなリクエスト
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
    
    
    // セクション[3-10]: 各ジャンルなリクエスト
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

