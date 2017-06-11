
import APIKit
import Result
import Himotoki


struct TMDB_OMDBidManager {
    
    func request(id: Int) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB_IMDBid(movieID: id)
        
        // Session receives an instance of a type that conforms to Request.
        Session.send(request) { result in
            
            switch result {
            case .success(let response):
                NotificationCenter.default.post(name: Notification.Name("TMDB_OMDB1"), object: response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
