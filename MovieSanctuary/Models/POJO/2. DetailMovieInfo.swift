
import Himotoki

struct MovieForIMDB_ID: Decodable {
    
    let imdb_id: String
    
    static func decode(_ e: Extractor) throws -> MovieForIMDB_ID {
        return try MovieForIMDB_ID (
            imdb_id: e <|  "imdb_id"
        )
    }
}
