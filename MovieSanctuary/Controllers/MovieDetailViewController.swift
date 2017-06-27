
import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imgMovie:      UIImageView!
    @IBOutlet weak var titleMovie:    UILabel!
    @IBOutlet weak var directorMovie: UILabel!
    @IBOutlet weak var genreMovie:    UILabel!
    @IBOutlet weak var starsMovie:    UILabel!
    @IBOutlet weak var storyMovie:    UILabel!
    @IBOutlet weak var stackStar:     UIStackView!
    
    // passed from privious ViewController
    var tmdb_movie: ConciseMovieInfoResult!
    var movie:      OMDB_Movie!
    

    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tmdb_movie from previous scene: ", tmdb_movie)
        TMDBconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //////////////////////////
    // MARK: - API connection
    //////////////////////////
    
    func TMDBconnect() {
        TMDB_OMDBidManager().request(id: self.tmdb_movie.id) { res1 in
            
            OMDB_APIManager().request(id: res1.imdb_id,
                                      { res2 in
                                        self.movie = res2
                                        print(self.movie)
                                        self.render()
            }, self.showAlert)
            
        }
    }
    
    
    ///////////////////////////////////
    // MARK: - Configure & Render View
    ///////////////////////////////////
    
    func showAlert() {
        
        let alert = UIAlertController(title: "No data", message: "No data for this movie", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
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
        
        renderStars()
        
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
    
    
    func renderStars() {
        
        /*
        let rate = Double(self.movie.rate).map{ Int($0 + 0.5) }
        
        if var rate = rate {
            for star in stackStar.subviews {
                if rate > 0 {
                    star.alpha = 1
                    rate -= 1
                }
            }
        }
        */
        
        
        let rateScore: Int? = Double(self.movie.rate).map{ Int($0 + 0.5) }

        rateScore.map { rate in
            var rate = rate
            self.stackStar.subviews.forEach { starImg in
                starImg.alpha = rate > 0 ? 1 : 0
                rate -= 1
            }
        }
        
        
        
    }
    
}

