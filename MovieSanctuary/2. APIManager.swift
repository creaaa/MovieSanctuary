
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
                self.success(response)
                
            case .failure(let error):
                self.failure(error)
            }
        }
    }
    
    
    func success(_ response: Request_TMDB_IMDBid.Response) {
        
        /*
        let apiManager = OMDB_APIManager()
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        let id = response.imdb_id
        
        queue.async { apiManager.request(id: id) }
        */
        
        let id = response.imdb_id

        OMDB_APIManager().request(id: id)
        
    }
    
    func failure(_ error: SessionTaskError) {
        print(error)
    }
    
}
