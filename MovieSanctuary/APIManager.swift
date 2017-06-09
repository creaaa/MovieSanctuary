
import APIKit
import Result
import Himotoki


struct TMDB_APIManager {
    
    func request()  {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB()
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
            
            switch result {
                
                case .success(let response):
                    print(response)
                    
                case .failure(let error):
                    print(error)
                
            }
            
        }
    }
}
