
import Himotoki

protocol Movieable {
    var id:           Int     { get }
    var title:        String  { get }
    var poster_path:  String? { get }
    var genres:       [Genre] { get }
    var vote_average: Float   { get }
    var vote_count:   Int     { get }
}


struct Genre: Decodable {
    
    let id:   Int
    let name: String
    
    static func decode(_ e: Extractor) throws -> Genre {
        return try Genre(
            id:   e <|  "id",
            name: e <|  "name"
        )
    }
    
    init(id: Int, name: String) {
        self.id   = id
        self.name = name
    }
    
}



struct ConciseMovie: Decodable {
    
    struct Movie: Decodable, Movieable {
        
//        struct Genre: Decodable {
//            let id:   Int
//            let name: String
//            
//            static func decode(_ e: Extractor) throws -> Genre {
//                return try Genre(
//                    id:   e <|  "id",
//                    name: e <|  "name"
//                )
//            }
//            
//            init(id: Int, name: String) {
//                self.id   = id
//                self.name = name
//            }
//            
//        }
        
        let id:           Int
        let title:        String
        let poster_path:  String?
        /*
        let genres:       [Int]
        */
        let genres:       [Genre]
        let vote_average: Float
        let vote_count:   Int
        
        static func decode(_ e: Extractor) throws -> Movie {
            
            let derivedData: [Int] = try! e <|| "genre_ids"
            
            let genres: [Genre] = derivedData.map { id in
                switch id {
                    case 12:
                        return Genre(id: id, name: "Adventure")
                    default:
                        return Genre(id: id, name: "Adventure")
                }
            }
            
            return try Movie (
                id:           e <|  "id",
                title:        e <|  "title",
                poster_path:  e <|? "poster_path",
                //genres:       e <|| "genre_ids",
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


