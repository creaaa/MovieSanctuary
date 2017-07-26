
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

    // movie/{movie_id}/videos で取れるやつ
    struct Videos: Decodable {
        
        struct Video: Decodable {
            let key: String
            static func decode(_ e: Extractor) throws -> Video {
                return try Video (
                    key: e <| "key"
                )
            }
        }
        
        let results: [Video]
        
        static func decode(_ e: Extractor) throws -> Videos {
            return try Videos (
                results: e <|| "results"
            )

        }
    }
    
    // movie/{movie_id}/credits で取れるやつ
    struct Credits: Decodable {
        
        struct Cast: Decodable {
            let name:  String
            let order: Int
            static func decode(_ e: Extractor) throws -> Cast {
                return try Cast(
                    name:  e <| "name",
                    order: e <| "order"
                )
            }
        }
        
        struct Crew: Decodable {
            let job:  String
            let name: String
            static func decode(_ e: Extractor) throws -> Crew {
                return try Crew(
                    job:  e <| "job",
                    name: e <| "name"
                )
            }
        }
        
        let casts:  [Cast]
        let crews:  [Crew]
        
        static func decode(_ e: Extractor) throws -> Credits {
            return try Credits(
                casts: e <|| "cast",
                crews: e <|| "crew"
            )
        }
    }
    

    
    /*
    let id:           Int
    let title:        String
    let poster_path:  String?
    let genres:       [Int]
    let vote_average: Float
    let vote_count:   Int
    */
    
    
    // searchでも取れるやつ
    let id:           Int
    let title:        String
    let poster_path:  String?
    let genres:       [Genre]
    let vote_average: Float
    let vote_count:   Int
    
    // movie/{movie_id}/videos で取れるやつ
    let videos:       Videos
    let credits:      Credits
    
    static func decode(_ e: Extractor) throws -> Movie {
        
        return try Movie (
            
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            genres:       e <|| "genres",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count",
            
            videos:       e <|  "videos",
            credits:      e <|  "credits"
            
        )
    }
  
}






