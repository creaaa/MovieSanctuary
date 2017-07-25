
import Himotoki

struct Movie: Decodable {
    
    struct Genre: Decodable {
        
        let id:   Int
        let name: String
        
        static func decode(_ e: Extractor) throws -> Genre {
            return try Genre(
                id:   e <|  "id",
                name: e <|  "name"
            )
        }
        
    }
    
    // searchでも取れるやつ
    let id:           Int
    let title:        String
    let poster_path:  String?
    let genres:       [Genre]
    let vote_average: Float
    let vote_count:   Int
    
    static func decode(_ e: Extractor) throws -> Movie {
        return try Movie (
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            genres:       e <|| "genres",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count"
        )
    }
  
}
