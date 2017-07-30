
import UIKit
import RealmSwift

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
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
    
    deinit {
        print("消滅した")
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
            
            // この書き方で大丈夫け??
            guard let navVC = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                let vc = navVC.viewControllers.first as? MovieListViewController else {
                return
            }
            
            vc.reload()
            
        }
    }
    

    //////////////////////////
    // MARK: - API connection
    //////////////////////////

    
    func connectForMovieDetail(type: MovieRequestType) {
        
        let manager = MovieDetailManager()
        
        // スタンダード
        DispatchQueue.global().async {
            switch type {
                case .standard(let movieID):
                    manager.request(id: movieID) { result in
                        self.myRLMMovie = result
                        print(self.myRLMMovie)
                        self.render()
                    }
                case .now_playing:
                    // このViewControllerで使われる限りは、now_playingでコールされることはない
                    fatalError()
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
        
        /* おちる　なおせ
        self.genresLabel.text =
            self.myRLMMovie.genres.map { $0.name }
                .dropLast(self.myRLMMovie.genres.map { $0.name }.count - 2)
                .joined(separator: ", ")
        */
        
        self.actorsLabel.text = self.myRLMMovie.credits.casts[0].name
        
    }

}


extension MovieDetailViewController: UITableViewDelegate {
    
}

extension MovieDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0...2:
                
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                
                cell.textLabel?.text       = "unk"
                cell.textLabel?.textColor = .gray
                
                cell.detailTextLabel?.text = "tnk"
                cell.detailTextLabel?.textColor = .black
                
                
                
                return cell
            
            default:
                fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 5
            default:
                return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "HOGE"
    }
    
    
}















