
import RealmSwift
import Himotoki

protocol Movieable {
    var id:           Int     { get set }
    var title:        String  { get set }
    var poster_path:  String? { get set }
    var genres: List<RLMGenre>{ get }
    var vote_average: Float   { get set }
    var vote_count:   Int     { get set }
}


/*
final class Genre: Object, Decodable {
    
    var id   = 0
    var name = ""
    
    static func decode(_ e: Extractor) throws -> Genre {
        return try Genre(
            id:   e <|  "id",
            name: e <|  "name"
        )
    }
    
    required convenience init(id: Int, name: String) {
        self.init()
        self.id   = id
        self.name = name
    }
    
}
*/


struct ConciseMovie: Decodable {
    
    struct Movie: Decodable, Movieable {
        
        var id:           Int
        var title:        String
        var poster_path:  String?
        // var genres:       [Genre]
        var genres: List<RLMGenre>
        var vote_average: Float
        var vote_count:   Int
        
        static func decode(_ e: Extractor) throws -> Movie {
            
            let derivedData: [Int] = try! e <|| "genre_ids"
            
            let tmpGenres: [RLMGenre] = derivedData.map { id in
                switch id {
                    case 12:
                        return RLMGenre(id: id, name: "Adventure")
                    default:
                        return RLMGenre(id: id, name: "Adventure")
                }
            }

            let genres = List<RLMGenre>()
            (0..<tmpGenres.count).forEach {
                genres.append(tmpGenres[$0])
            }
            
            return try Movie (
                id:           e <|  "id",
                title:        e <|  "title",
                poster_path:  e <|? "poster_path",
                genres:       genres,
                vote_average: e <|  "vote_average",
                vote_count:   e <|  "vote_count"
            )
        }
        
        
        var genreName: [String] {
            
            
            
            
            var results: [String] = []
            
            var dict = [
                12:    "Adventure",
                14:    "Fantasy",
                16:    "Animation",
                18:    "Drama",
                27:    "Horror",
                28:    "Action",
                35:    "Comedy",
                36:    "History",
                37:    "Western",
                53:    "Thriller",
                80:    "Crime",
                99:    "Documentary",
                878:   "Science Fiction",
                9648:  "Mystery",
                10402: "Music",
                10749: "Romance",
                10751: "Family",
                10752: "War",
                10770: "TV Movie"
            ]
            
            /*
            (0..<self.genres.count).forEach {
                if let val = dict[genres[$0]] {
                    results.append(val)
                }
            }
            */
            
            return results
            
        }
        
    }

    let results: [Movie]

    static func decode(_ e: Extractor) throws -> ConciseMovie {
        return try ConciseMovie (
            results: e <|| ["results"]
        )
    }
    
}


