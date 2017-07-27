
import Foundation

import Himotoki
import Realm
import RealmSwift


// *** 詳細版モデル *** ///

/*
struct Movie: Decodable, Movieable {
    
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
            genres:       e <|| "genres",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count",
            videos:       e <|  "videos",
            credits:      e <|  "credits"
        )
    }
}
*/


/////////////////////////////////////////////////////////

// 上記モデルのRealm用 // 


final class RLMGenre: Object, Decodable {
    
    dynamic var id   = 0
    dynamic var name = ""
    
    static func decode(_ e: Extractor) throws -> RLMGenre {
        return try RLMGenre(
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

////////////


// 1. ビデオ用

final class RLMVideo: Object, Decodable {
    
    dynamic var key = ""
    
    static func decode(_ e: Extractor) throws -> RLMVideo {
        return try RLMVideo(
            key: e <| "key"
        )
    }
    
    // なぜかこれを定義しないとエラー(decodeと共存できない)！
    required convenience init(key: String) {
        self.init()
        self.key = key
    }
    
}

final class RLMVideos: Object, Decodable {
    
    var results = List<RLMVideo>()
    
    static func decode(_ e: Extractor) throws -> RLMVideos {
        
        let results = List<RLMVideo>()
        let tmp: [RLMVideo] = try! e <|| "results"
        tmp.forEach {
            results.append($0)
        }
        
        return RLMVideos(results: results)
        
    }
    
    required convenience init(results: List<RLMVideo>) {
        self.init()
        self.results = results
    }
    
}


// 2. キャスト用

final class RLMCast: Object, Decodable {
    
    dynamic var name  = ""
    dynamic var order = 0
    
    static func decode(_ e: Extractor) throws -> RLMCast {
        return try RLMCast(
            name: e <| "name",
            order: e <| "order"
        )
    }
    
    required convenience init(name: String, order: Int) {
        self.init()
        self.name = name
        self.order = order
    }
    
}

// 3. クルー用

final class RLMCrew: Object, Decodable {
    
    dynamic var job  = ""
    dynamic var name = ""
    
    static func decode(_ e: Extractor) throws -> RLMCrew {
        return try RLMCrew(
            job: e <| "job",
            name: e <| "name"
        )
    }
    
    required convenience init(job: String, name: String) {
        self.init()
        self.job  = job
        self.name = name
    }
    
}

// 4. キャスト + クルー用

final class RLMCredits: Object, Decodable {
    
    var casts =  List<RLMCast>()
    var crews =  List<RLMCrew>()
    
    static func decode(_ e: Extractor) throws -> RLMCredits {
        
        let casts = List<RLMCast>()
        let tmp1: [RLMCast] = try! e <|| "cast"
        tmp1.forEach {
            casts.append($0)
        }
        let crews = List<RLMCrew>()
        let tmp2: [RLMCrew] = try! e <|| "crew"
        tmp2.forEach {
            crews.append($0)
        }
        
        return RLMCredits(casts: casts, crews: crews)
        
    }
    
    required convenience init(casts: List<RLMCast>, crews: List<RLMCrew>) {
        self.init()
        self.casts = casts
        self.crews = crews
    }
    
}


// 大ボスです。
final class RLMMovie: Object, Movieable, Decodable {

    // searchでも取れるやつ
    dynamic var id           = 0
    dynamic var title        = ""
    dynamic var poster_path:   String?
    let genres               = List<RLMGenre>()
    dynamic var vote_average: Float = 0.0
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
    
    /*
    static func decode(_ e: Extractor) throws -> RLMMovie {
        return try RLMMovie (
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            // genres:       e <|| "genres",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count"
            // videos:       e <|  "videos",
            // credits:      e <|  "credits"
        )
    }
    */
    
    static func decode(_ e: Extractor) throws -> RLMMovie {
        return try RLMMovie(
            
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count"
            // ↑ ここまではよい。
            
        )
    }
    
    required convenience init(id: Int, title: String, poster_path: String?,
                              vote_average: Float, vote_count: Int) {
        self.init()
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
}





