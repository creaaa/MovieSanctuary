
import Foundation

import Himotoki
import Realm
import RealmSwift


// 0. ジャンル用
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

// 1. ビデオ用

final class RLMVideo: Object, Decodable {
    
    dynamic var key  = ""
    dynamic var name = ""
    
    static func decode(_ e: Extractor) throws -> RLMVideo {
        return try RLMVideo(
            key:  e <| "key",
            name: e <| "name"
        )
    }
    
    // なぜかこれを定義しないとエラー(decodeと共存できない)！
    required convenience init(key: String, name: String) {
        self.init()
        self.key  = key
        self.name = name
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
    
    dynamic var name         = ""
    dynamic var order        = 0
    dynamic var profile_path:  String?
    
    static func decode(_ e: Extractor) throws -> RLMCast {
        return try RLMCast(
            name:         e <|  "name",
            order:        e <|  "order",
            profile_path: e <|? "profile_path"
        )
    }
    
    required convenience init(name: String, order: Int, profile_path: String?) {
        self.init()
        self.name = name
        self.order = order
        self.profile_path = profile_path
    }
    
}

// 3. クルー用

final class RLMCrew: Object, Decodable {
    
    dynamic var job  = ""
    dynamic var name = ""
    dynamic var profile_path: String?
    
    static func decode(_ e: Extractor) throws -> RLMCrew {
        return try RLMCrew(
            job:  e <| "job",
            name: e <| "name",
            profile_path: e <|? "profile_path"
        )
    }
    
    required convenience init(job: String, name: String, profile_path: String?) {
        self.init()
        self.job  = job
        self.name = name
        self.profile_path = profile_path
    }
    
}

// 4. キャスト + クルー用

final class RLMCredits: Object, Decodable {
    
    var casts = List<RLMCast>()
    var crews = List<RLMCrew>()
    
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

// 5. Recommendations用

final class RLMRecommendation: Object, Decodable {
    
    dynamic var id           = 0
    dynamic var title        = ""
    dynamic var poster_path: String?
    var vote_average: Float  = 0.0
    var vote_count           = 0
    
    static func decode(_ e: Extractor) throws -> RLMRecommendation {
        return try RLMRecommendation(
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count"
        )
    }

    required convenience init(id: Int, title: String, poster_path: String?,
                              vote_average: Float, vote_count: Int) {
        self.init()
        self.id           = id
        self.title        = title
        self.poster_path  = poster_path
        self.vote_average = vote_average
        self.vote_count   = vote_count
    }
    
}


final class RLMRecommendations: Object, Decodable {
    
    var results = List<RLMRecommendation>()
    
    static func decode(_ e: Extractor) throws -> RLMRecommendations {
        
        let recommendations = List<RLMRecommendation>()
        
        let tmp: [RLMRecommendation] = try! e <|| "results"
        tmp.forEach { recommendations.append($0) }
        
        return RLMRecommendations(recommendations: recommendations)
        
    }
    
    required convenience init(recommendations: List<RLMRecommendation>) {
        self.init()
        self.results = recommendations
    }
    
}


// 大ボスです。
final class RLMMovie: Object, Movieable, Decodable {

    // searchでも取れるやつ
    dynamic var id                     = 0
    dynamic var title                  = ""
    dynamic var poster_path: String?
            var genres: List<RLMGenre> = List<RLMGenre>()
    dynamic var vote_average: Float    = 0.0
    dynamic var vote_count             = 0
    
    // movie/{movie_id}/videos で取れるやつ
    
    // なんかここ、オプショナル型じゃないと実行時エラー！
    // property must be marked as optional... みたいなメッセージ見たら、
    // ここをオプショナルにすると通る...はず。
    var videos:  List<RLMVideos>  = List<RLMVideos>()
    var credits: List<RLMCredits> = List<RLMCredits>()
    
    // 7/27 recomendations 追加しまーす
    var recommendations: List<RLMRecommendations> = List<RLMRecommendations>()
    
    // 7/30 さらに追加
    dynamic var overview: String?
    dynamic var release_date = ""
    var runtime: Int?
    dynamic var budget  = 0
    dynamic var revenue = 0
    dynamic var homepage: String?
    
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    static func decode(_ e: Extractor) throws -> RLMMovie {
        
        // genres
        let genres: List<RLMGenre> = List<RLMGenre>()
        let tmpGenres: [RLMGenre] = try! e <|| "genres"
        tmpGenres.forEach {
            genres.append($0)
        }
        
        // videos
        let videos: List<RLMVideos> = List<RLMVideos>()
        let tmpVideos: RLMVideos  = try! e <| "videos"
        
        /*
        tmpVideos.forEach {
            videos.append($0)
        }
        */
        
        videos.append(tmpVideos)
        
        
        // credits(cast&crew)
        let credits: List<RLMCredits> = List<RLMCredits>()
        let tmpCredits: RLMCredits  = try! e <| "credits"
        /*
        tmpCredits.forEach {
            credits.append($0)
        }
        */
        
        credits.append(tmpCredits)
        
        
        // recommendations
        let recommendations: List<RLMRecommendations> = List<RLMRecommendations>()
        let tmpRecommendations: RLMRecommendations  = try! e <| "recommendations"
        /*
        tmpRecommendations.forEach {
            recommendations.append($0)
        }
        */
        
        recommendations.append(tmpRecommendations)
        
        
        return try RLMMovie(
            
            id:           e <|  "id",
            title:        e <|  "title",
            poster_path:  e <|? "poster_path",
            vote_average: e <|  "vote_average",
            vote_count:   e <|  "vote_count",
            
            genres:          genres,
            videos:          videos,
            credits:         credits,
            recommendations: recommendations,
            
            // 7/30 added
            overview:     e <|? "overview",
            release_date: e <|  "release_date",
            runtime:      e <|? "runtime",
            budget:       e <|  "budget",
            revenue:      e <|  "revenue",
            homepage:     e <|? "homepage"

        )
    }
    
    required convenience init(id: Int, title: String, poster_path: String?,
                              vote_average: Float, vote_count: Int,
                              genres: List<RLMGenre>, videos: List<RLMVideos>,
                              credits: List<RLMCredits>, recommendations: List<RLMRecommendations>,
                              overview: String?, release_date: String, runtime: Int?,
                              budget: Int, revenue: Int, homepage: String?) {
        
        self.init()
        
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.vote_average = vote_average
        self.vote_count = vote_count
        //
        self.genres          = genres
        self.videos          = videos
        self.credits         = credits
        self.recommendations = recommendations
        //
        self.overview        = overview
        self.release_date    = release_date
        self.runtime         = runtime
        self.budget          = budget
        self.revenue         = revenue
        self.homepage        = homepage
        
    }
    
}



