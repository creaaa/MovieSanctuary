//
//import APIKit
//import Result
//import Himotoki
//
//struct APIManager {
//    
//    func request()  {
//        
//        // SearchRepositoriesRequest conforms to Request protocol.
//        // let request = SearchRepositoriesRequest(query: "swift")
//        
//        // Session receives an instance of a type that conforms to Request.
//        Session.send(request) { result in
//            switch result {
//                case .success(let response):
//                    // Type of `response` is `[Repository]`,
//                    // which is inferred from `SearchRepositoriesRequest`.
//                    print(response)
//                    
//                case .failure(let error):
//                    self.printError(error)
//            }
//        }
//        
//
//        
//    }
//    
//}
