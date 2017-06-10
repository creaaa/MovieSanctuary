
import Himotoki

struct ConciseMovieInfo: Decodable {
    
    let results: [ConciseMovieInfoResult]
    
    static func decode(_ e: Extractor) throws -> ConciseMovieInfo {
        return try ConciseMovieInfo (
            results: e <|| ["results"]
        )
    }
}


struct ConciseMovieInfoResult: Decodable {
    
    let name:        String
    let poster_path: String?  // ここ、nilになる
    let genres:      [Int]
    
    static func decode(_ e: Extractor) throws -> ConciseMovieInfoResult {
        return try ConciseMovieInfoResult (
            name:        e <|  "title",
            poster_path: e <|? "poster_path",
            genres:      e <|| "genre_ids"
        )
    }
}
