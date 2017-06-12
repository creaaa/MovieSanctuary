

import UIKit

class MovieDetailViewController: UIViewController {

    var tmdb_movie: ConciseMovieInfoResult!
    
    var movie: OMDB_Movie!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("前画面から来た tmdb_movie: ", tmdb_movie)

        NotificationCenter.default.addObserver(self, selector: #selector(completion(sender:)), name: Notification.Name("TMDB_OMDB"), object: nil)
        
        connect()
        
    }
    
    
    func connect() {
        
        let apiManager = TMDB_OMDBidManager()
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async { apiManager.request(id: self.tmdb_movie.id) }
        
    }
    
    
    func completion(sender: Notification) {
        
        switch sender.object {
            
            case let movie as OMDB_Movie:
                self.movie = movie
                print(self.movie)
            
            default:
                break
        }
    }
    
}
