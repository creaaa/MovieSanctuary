
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
    
    let id:          Int
    let name:        String
    let poster_path: String?
    let genres:      [Int]
    
    static func decode(_ e: Extractor) throws -> ConciseMovieInfoResult {
        return try ConciseMovieInfoResult (
            id:          e <|  "id",
            name:        e <|  "title",
            poster_path: e <|? "poster_path",
            genres:      e <|| "genre_ids"
        )
    }
}

