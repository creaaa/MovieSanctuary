
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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
            
            
        // [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBgImage"]];
        
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
        
        //Change text size if string is too long
        let ary = [titleMovie, starsMovie,directorMovie,genreMovie]
        
        
        for i in ary
        {
            if i?.tag == 1 {
                setSizeViews(view: i!, base: 4)
            }
            else
            {
                setSizeViews(view: i!, base: 0)
            }
        
            
        }
        
        renderStars()

        
    }
    
    func renderStars() {
        
        // var rate =  Int(Double(self.movie.rate)!)
        
        let rate = Double(self.movie.rate).map{ Int($0 + 0.5) }
        
//        if let rate = Int(self.movie.rate) {
//            print(rate)
//        } else {
//            print("")
//        }
        
        if var rate = rate {
            for star in stackStar.subviews {
                if rate > 0 {
                    star.alpha = 1
                    rate -= 1
                }
            }
        }
        
        
//        for star in stackStar.subviews {
//            if rate > 0 {
//                star.alpha = 1
//                rate -= 1
//            }
//        }
        
    }
    
    
    func setSizeViews(view : UIView, base : Int) {
        
        let size = base
        
        if let textview = view as? UITextView {
            
            
            if textview.text.characters.count < 12 {
                textview.font = .systemFont(ofSize: CGFloat(size + 20))
            }
            else if textview.text.characters.count > 25 {
                textview.font = .systemFont(ofSize: CGFloat(size + 12))
            }
            else if textview.text.characters.count > 18 {
                textview.font = .systemFont(ofSize: CGFloat(size + 16))
            }
            else if textview.text.characters.count > 12 {
                textview.font = .systemFont(ofSize: CGFloat(size + 18))
            }
        }
        
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


