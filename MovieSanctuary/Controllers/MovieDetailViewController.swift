
import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imgMovie:      UIImageView!
    @IBOutlet weak var titleMovie:    UITextView!
    @IBOutlet weak var directorMovie: UITextView!
    @IBOutlet weak var genreMovie:    UITextView!
    @IBOutlet weak var starsMovie:    UITextView!
    @IBOutlet weak var storyMovie:    UITextView!
    @IBOutlet weak var stackStar:     UIStackView!
    
    // passed from privious ViewController
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
                self.render()
            }
        }
    }
    
    func render() {
        
        if let imagePath = self.tmdb_movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            self.imgMovie.kf.setImage(with: url)
        }
        
        self.titleMovie.text    = self.tmdb_movie.name
        self.directorMovie.text = self.movie.director
        self.genreMovie.text    = genre()
        self.starsMovie.text    = self.movie.actors
        self.storyMovie.text    = self.movie.plot
        
        
        // TODO: changes depending on rate
        // use 'self.movie.rate' property to get rate
        
        // self.stackStar
        
    }
    
    
    func genre() -> String {
        
        var result: String = ""
        
        // Genre 1
        if let genre1 = self.tmdb_movie.genres.first {
            result += SearchMovieViewController.genreIdToName(genre1)
        }
        
        // Genre 2
        if self.tmdb_movie.genres.count >= 2 {
            result += ", " + SearchMovieViewController.genreIdToName(self.tmdb_movie.genres[1])
        }
        
        return result
        
    }
    

}


