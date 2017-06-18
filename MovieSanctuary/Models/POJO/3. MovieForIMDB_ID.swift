
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
            director: e <| "Director",
            actors:   e <| "Actors",
            year:     e <| "Year",
            plot:     e <| "Plot",
            rate:     e <| "imdbRating"
        )
    }
}
