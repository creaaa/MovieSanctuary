
import APIKit
import Result
import Himotoki


struct TMDB_APIManager {
    
    func request(query: String) {

        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB(query: query)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
            
            switch result {
                case .success(let response):
                    NotificationCenter.default.post(name: Notification.Name("JSONresult"), object: response)
                
                case .failure(let error):
                    print(error)
            }
        }
    }
}
