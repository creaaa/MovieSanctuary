
import UIKit

class MovieDetailViewController: UIViewController {


    var tmdb_movie: ConciseMovieInfoResult!
    var movie:      OMDB_Movie!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("tmdb_movie from previous scene: ", tmdb_movie)
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


    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var titleMovie: UITextView!
    @IBOutlet weak var directorMovie: UITextView!
    @IBOutlet weak var genreMovie: UITextView!
    @IBOutlet weak var starsMovie: UITextView!
    @IBOutlet weak var storyMovie: UITextView!
    @IBOutlet weak var stackStar: UIStackView!
    


}
