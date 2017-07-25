
import Himotoki

struct OMDB_Movie: Decodable {
    
    let name:     String
    let director: String
    let actors:   String
    let year:     String
    let plot:     String
    let rate:     String
    
    static func decode(_ e: Extractor) throws -> OMDB_Movie {
        
        return try OMDB_Movie (
            name:     e <| "Title",
            director: e <| "Director",    // 特有
            actors:   e <| "Actors",      // 特有
            year:     e <| "Year",
            plot:     e <| "Plot",        // 特有
            rate:     e <| "imdbRating"
        )
        
    }
}
