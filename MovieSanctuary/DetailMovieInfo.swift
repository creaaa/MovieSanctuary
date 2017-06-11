//
//import Himotoki
//
//struct DetailMovieInfo: Decodable {
//    
//    let results: [ConciseMovieInfoResult]
//    
//    static func decode(_ e: Extractor) throws -> DetailMovieInfo {
//        return try DetailMovieInfo (
//            results: e <|| ["results"]
//        )
//    }
//}
