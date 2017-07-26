
import Himotoki

struct ConciseMovie: Decodable {
    
    let id:           Int
    let title:        String
    let poster_path:  String?
    let vote_average: Float
    let vote_count:   Int
    
    
    static func decode(_ e: Extractor) throws -> ConciseMovie {
        
        return try ConciseMovie (

            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count"
            
        )
    }
    
}
