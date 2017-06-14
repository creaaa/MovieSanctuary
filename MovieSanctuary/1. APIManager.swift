
import APIKit
import Result
import Himotoki


enum Hoge<T, U> {
    case a(T)
    case n(U)
}


struct TMDB_APIManager {
    
    func request(query: String) {
        
        // SearchRepositoriesRequest conforms to Request protocol.
        let request = Request_TMDB(query: query)
        
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
    
    func success(_ response: Request_TMDB.Response) {
        NotificationCenter.default.post(name: Notification.Name("JSONresult"), object: response)
    }
    
    func failure(_ error: SessionTaskError) {
        print(error)
    }
    
}
