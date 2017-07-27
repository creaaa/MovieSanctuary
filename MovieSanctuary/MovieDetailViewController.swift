
import UIKit
import RealmSwift

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel:      UILabel!
    @IBOutlet weak var directorLabel:   UILabel!
    @IBOutlet weak var genresLabel:     UILabel!
    @IBOutlet weak var actorsLabel:     UILabel!
    @IBOutlet weak var plotLabel:       UILabel!
    @IBOutlet weak var rateStackView:   UIStackView!

    // APIコールに用いられる、映画のユニークID
    // var movieID: Int!
    
    // セルタップからか、Realmから直接か...わからんが、
    // とりあえず「映画1本ぶん」のモデル
    var movie: Movieable?
    
    // 上記の、Realmナイズされたモデル
    var myRLMMovie: RLMMovie!

    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* if idが存在するなら(= セルタップからの遷移なら) */
        connectForMovieDetail()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        Thread.sleep(forTimeInterval: 5)
        addFavorite()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func addFavorite() {
        
        guard let movie = self.movie else { return }
        
        try! Realm().write {
            
            // RLMMovie == nil → 検索結果から遷移してきた   = 新たにRLMObjectを作る
            // RLMMovie != nil → お気に入りから遷移してきた = 既存のRLMObjectを使う
            if self.myRLMMovie == nil {
                self.myRLMMovie = RLMMovie()
            }
            
            myRLMMovie.id = movie.id
            myRLMMovie.title = movie.title
            myRLMMovie.poster_path = movie.poster_path
            
            //myRLMMovie.genres = movie.genres
            
            myRLMMovie.vote_average = movie.vote_average
            myRLMMovie.vote_count = movie.vote_count
            
            // myRLMMovie.videos = movie.videos
            // myRLMMovie.credits = movie.credits
            
            try! Realm().add(self.myRLMMovie)
            
            print("保存した")
            
        }
        

    }
    

    //////////////////////////
    // MARK: - API connection
    //////////////////////////

    func connectForMovieDetail() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request(id: (self.movie?.id)!) { result in
                
                print(result)
                
                // self.movies.append(result)
                
            }
        }
    }
    
    
    /*
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
    */


    ///////////////////////////////////
    // MARK: - Configure & Render View
    ///////////////////////////////////

    func showAlert() {

        let alert = UIAlertController(title: "No data", message: "No data for this movie", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)

    }

    func render() {

        /*
        if let imagePath = self.tmdb_movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            self.posterImageView.kf.setImage(with: url)
        }

        self.titleLabel.text    = self.tmdb_movie.name
        self.directorLabel.text = self.movie.director
        self.genresLabel.text   = genre()
        self.actorsLabel.text   = self.movie.actors
        self.plotLabel.text     = self.movie.plot

        renderStars()
        */
    }

    /*
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
     */

    /*
    func renderStars() {

        let rateScore: Int? = Double(self.movie.rate).map{ Int($0 + 0.5) }

        rateScore.map { rate in
            var rate = rate
            self.rateStackView.subviews.forEach { starImg in
                starImg.alpha = rate > 0 ? 1 : 0
                rate -= 1
            }
        }
    }
    */

}

