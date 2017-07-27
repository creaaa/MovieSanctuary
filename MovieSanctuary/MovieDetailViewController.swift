
import UIKit
import RealmSwift

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel:      UILabel!
    @IBOutlet weak var directorLabel:   UILabel!
    @IBOutlet weak var genresLabel:     UILabel!
    @IBOutlet weak var actorsLabel:     UILabel!
    @IBOutlet weak var plotLabel:       UILabel!
    @IBOutlet weak var rateStackView:   UIStackView!

    
    // 上記の、Realmナイズされたモデル
    var myRLMMovie: RLMMovie!
    
    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addFavorite))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        // Thread.sleep(forTimeInterval: 3)
        // addFavorite()
    }
    
    // will・didDisappear、ブレイク打っても突入しないんだが、デバッグできないのか？？
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addFavorite() {
        try! Realm().write {
            // これ、update = trueって明示しないと落ちる。
            // よって、defaultはfalseってことか...
            // true = 既存のオブジェクトを参照し、存在すればそれに対しアップデートをかける。
            // false = 既存のオブジェクトを参照しようとせず、新たに作る。
            // もちろんそのとき、既にあるprimary key で作成しようとすると実行時エラーとなる。
            try! Realm().add(self.myRLMMovie, update: true)
            print("保存した")
        }
    }
    

    //////////////////////////
    // MARK: - API connection
    //////////////////////////

    func connectForMovieDetail(movieID: Int) {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request(id: movieID) { result in
                self.myRLMMovie = result
                print(self.myRLMMovie)
                self.render()
            }
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

        if let imagePath = self.myRLMMovie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            self.posterImageView.kf.setImage(with: url)
        }

        self.titleLabel.text    = self.myRLMMovie.title
        self.directorLabel.text = self.myRLMMovie.credits.crews[0].name
        self.genresLabel.text   = self.myRLMMovie.genres[0].name
        self.actorsLabel.text   = self.myRLMMovie.credits.casts[0].name
        
    }

}
