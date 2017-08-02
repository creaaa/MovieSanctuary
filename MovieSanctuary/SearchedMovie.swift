
import RealmSwift
import Himotoki


protocol Movieable {
    var id:           Int     { get set }
    var title:        String  { get set }
    var poster_path:  String? { get set }
    var genres: List<RLMGenre>{ get     }
    var vote_average: Float   { get set }
    var vote_count:   Int     { get set }
}


struct SearchMovieResult: Decodable {
    
    struct Movie: Decodable, Movieable {
        
        var id:           Int
        var title:        String
        var poster_path:  String?
        var genres:       List<RLMGenre>
        var vote_average: Float
        var vote_count:   Int
        
        static func decode(_ e: Extractor) throws -> Movie {
            
            let derivedData: [Int] = try! e <|| "genre_ids"
            
            let tmpGenres: [RLMGenre] = derivedData.map { id in
                switch id {
                    case 12:
                        return RLMGenre(id: id, name: "Adventure")
                    case 14:
                        return RLMGenre(id: id, name: "fantasy")
                    case 16:
                        return RLMGenre(id: id, name: "animation")
                    case 18:
                        return RLMGenre(id: id, name: "drama")
                    case 27:
                        return RLMGenre(id: id, name: "horror")
                    case 28:
                        return RLMGenre(id: id, name: "action")
                    case 35:
                        return RLMGenre(id: id, name: "comedy")
                    case 36:
                        return RLMGenre(id: id, name: "history")
                    case 37:
                        return RLMGenre(id: id, name: "western")
                    case 53:
                        return RLMGenre(id: id, name: "thriller")
                    case 80:
                        return RLMGenre(id: id, name: "crime")
                    case 99:
                        return RLMGenre(id: id, name: "documentary")
                    case 878:
                        return RLMGenre(id: id, name: "SF")
                    case 9648:
                        return RLMGenre(id: id, name: "mystery")
                    case 10402:
                        return RLMGenre(id: id, name: "music")
                    case 10749:
                        return RLMGenre(id: id, name: "romance")
                    case 10751:
                        return RLMGenre(id: id, name: "family")
                    case 10752:
                        return RLMGenre(id: id, name: "war")
                    case 10770:
                        return RLMGenre(id: id, name: "TVMovie")
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
        
    }

    let results: [Movie]

    static func decode(_ e: Extractor) throws -> SearchMovieResult {
        return try SearchMovieResult(
            results: e <|| ["results"]
        )
    }
    
}


