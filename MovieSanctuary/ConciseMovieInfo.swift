//
//import Himotoki
//
//struct ConciseMovieInfo {
//    
//    var genres: [Int]
//    
//}
//
//extension ConciseMovieInfo: Decodable {
//    
//    static func decode(_ e: Extractor) throws -> ConciseMovieInfo {
//        
//        return try ConciseMovieInfo (
//            genres: e <|| "genre_ids"
//        )
//    }
//    
//}
