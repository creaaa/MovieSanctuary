
import UIKit
import APIKit
import Result
import Himotoki


struct OMDB_APIManager {
    
    struct Request_OMDB: OMDBRequest {
        
        typealias Response = OMDB_Movie
        
        let movieID: String
        var method: HTTPMethod { return .get }
        var path:   String     { return "" }
        var parameters: Any? {
            return [
                "i":      self.movieID,
                "plot":   "full",
                "apikey": APIkey.OMDB_APIkey
            ]
        }
    }
    
    func request(id: String, _ completion: @escaping (Request_OMDB.Response) -> Void) {
        
        let request = Request_OMDB(movieID: id)
        
        Session.send(request) { result in
            switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error)
                
                // アラートを作成
                /*
                let alert = UIAlertController(
                    title: "アラートのタイトル",
                    message: "アラートの本文",
                    preferredStyle: .alert)
                
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                // アラート表示
                self.present(alert, animated: true, completion: nil)
                */
                
            }
        }
    }
}

