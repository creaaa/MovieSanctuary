

import UIKit

class MovieDetailViewController: UIViewController {

    var tmdb_id: Int!
    
    var movieForIMDB_ID: MovieForIMDB_ID!
    var movie:           OMDB_Movie!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("前画面から来たID: ", tmdb_id)
        
        NotificationCenter.default.addObserver(self, selector: #selector(completion1(sender:)), name: Notification.Name("TMDB_OMDB1"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(completion2(sender:)), name: Notification.Name("TMDB_OMDB2"), object: nil)
        
        connect1()
        
    }
    
    
    func connect1() {
        
        let apiManager = TMDB_OMDBidManager()
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async { apiManager.request(id: self.tmdb_id) }
        
    }
    
    
    func connect2() {
        
        let apiManager = OMDB_APIManager()
        
        let queue = DispatchQueue.global(qos: .userInitiated)

        queue.async { apiManager.request(id: self.movieForIMDB_ID.imdb_id) }
        
    }
    
    
    func completion1(sender: Notification) {
        
        switch sender.object {
            
            case let movie as MovieForIMDB_ID:
            
                self.movieForIMDB_ID = movie
                connect2()
            
            default: break
            
        }
        
    }
    
    
    func completion2(sender: Notification) {
        
        switch sender.object {
            
            case let movie as OMDB_Movie:
            
                self.movie = movie
                
                print(self.movie)
            
                
            
            default: break
            
        }
        
        
        
    }
    
    
}
