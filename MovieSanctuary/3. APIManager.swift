

import APIKit
import Result
import Himotoki


struct OMDB_APIManager {
    
    func request(id: String) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_OMDB(movieID: id)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
                        
            switch result {
            case .success(let response):
                NotificationCenter.default.post(name: Notification.Name("TMDB_OMDB"), object: response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
