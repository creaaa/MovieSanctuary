

import UIKit

class MovieDetailViewController: UIViewController {

    var tmdb_movie: ConciseMovieInfoResult!
    var movie:      OMDB_Movie!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("前画面から来た tmdb_movie: ", tmdb_movie)
        TMDBconnect()
        
    }
    
    func TMDBconnect() {
        TMDB_OMDBidManager().request(id: self.tmdb_movie.id) { res1 in
            OMDB_APIManager().request(id: res1.imdb_id) { res2 in
                self.movie = res2
                print(self.movie)
            }
        }
    }
    
}

