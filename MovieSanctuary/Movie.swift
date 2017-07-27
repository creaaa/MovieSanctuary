
import Foundation

import Himotoki
import Realm
import RealmSwift



// *** 詳細版モデル *** ///
struct Movie: Decodable, Movieable {
    
//    struct Genre: Decodable {
//        let id:   Int
//        let name: String
//        static func decode(_ e: Extractor) throws -> Genre {
//            return try Genre(
//                id:   e <| "id",
//                name: e <| "name"
//            )
//        }
//    }

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
            
            // 
            genres:       e <|| "genres",
            
            
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count",
            videos:       e <|  "videos",
            credits:      e <|  "credits"
            
        )
    }
}


/////////////////////////////////////////////////////////

// 上記モデルのRealm用 // 

class RLMMovie: Object {
    
    class RLMGenre: Object {
        dynamic var id   = 0
        dynamic var name = ""
    }
    
    class RLMVideos: Object {
        class RLMVideo: Object {
            dynamic var key = ""
        }
        let results = List<RLMVideo>()
    }
    
    class RLMCredits: Object {
        
        class RLMCast: Object {
            dynamic var name  = ""
            dynamic var order = 0
        }
        
        class RLMCrew: Object {
            dynamic var job  = ""
            dynamic var name = ""
        }
        
        var casts =  List<RLMCast>()
        var crews =  List<RLMCrew>()
        
    }
    
    // searchでも取れるやつ
    dynamic var id           = 0
    dynamic var title        = ""
    dynamic var poster_path:   String?
    let genres               = List<RLMGenre>()
    dynamic var vote_average: Float = 0
    dynamic var vote_count   = 0
    // movie/{movie_id}/videos で取れるやつ
    let videos               = List<RLMVideos>()
    let credits              = List<RLMCredits>()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


