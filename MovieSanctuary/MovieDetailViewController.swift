
import UIKit
import RealmSwift
import Kingfisher

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView:       UITableView!
    @IBOutlet weak var collectionView:  UICollectionView!
    
    // @IBOutlet weak var posterImageView: UIImageView!
    //@IBOutlet weak var titleLabel:      UILabel!
    //@IBOutlet weak var directorLabel:   UILabel!
    //@IBOutlet weak var genresLabel:     UILabel!
    //@IBOutlet weak var actorsLabel:     UILabel!
    //@IBOutlet weak var plotLabel:       UILabel!
    //@IBOutlet weak var rateStackView:   UIStackView!

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var posterImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    
    // 上記の、Realmナイズされたモデル
    var myRLMMovie: RLMMovie!
    
    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("おら！", UIApplication.shared.keyWindow?.bounds.height)
        
        self.view.backgroundColor = .white
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addFavorite))
        
    }

    override func viewDidLayoutSubviews() {
    
        let screenHeight = UIApplication.shared.keyWindow?.bounds.height
        screenHeight.map {
            // (64: ステバー+ナビバー) - (49: タブバー) - (60: スコアビュー)
            print("くそ", $0 - 64 - 49 - 60)
            self.posterImageViewHeight.constant = $0 - 64 - 49 - 60
        }
            
        
        // このサイトがまじで神だった。。。
        // http://blog.ch3cooh.jp/entry/20160108/1452249000
        // ちなみにこのconstant, 決め打ちで200とかやるとスクロールおかしくなる。どうなってんの
        // いや、ほんとまじ助かった...
        self.tableViewHeight.constant = self.tableView.contentSize.height
    
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

        self.title = self.myRLMMovie.title

        if let imagePath = self.myRLMMovie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            self.posterImageView.kf.setImage(with: url,
                                             placeholder: nil,
                                             options: [.transition(.fade(0.4)), .forceTransition])
        }
        
        self.voteAverageLabel.text = Int(self.myRLMMovie.vote_average * 10).description + "%"
        self.voteCountLabel.text   = self.myRLMMovie.vote_count.description
        
        self.overviewLabel.text = self.myRLMMovie.overview
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
        /* おちる　なおせ
        self.genresLabel.text =
            self.myRLMMovie.genres.map { $0.name }
                .dropLast(self.myRLMMovie.genres.map { $0.name }.count - 2)
                .joined(separator: ", ")
        */
        
        
        
    }

}


extension MovieDetailViewController: UITableViewDelegate {
    
}

extension MovieDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
            case 0:
                
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.selectionStyle = .none
                
                let titleLabels = ["Release Date", "Runtime", "Genre", "Budget", "Revenue"]
                
                cell.textLabel?.text      = titleLabels[indexPath.row]
                cell.textLabel?.textColor = .gray
                cell.textLabel?.font = UIFont(name: "Montserrat", size: 12)
                
                // これしないと、初回にエラーで落ちる
                if let movie = self.myRLMMovie {
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.groupingSeparator = ","
                    formatter.groupingSize = 3
                    
                    switch indexPath.row {
                        case 0:
                             cell.detailTextLabel?.text = movie.release_date
                        case 1:
                            cell.detailTextLabel?.text =
                                (movie.runtime?.description).map { $0 + " mins"}
                        case 2:
                            cell.detailTextLabel?.text = movie.genres.first?.name
                        case 3:
                            cell.detailTextLabel?.text =
                                self.myRLMMovie.budget != 0 ?
                                    formatter.string(from: movie.budget as NSNumber).map{"$ \($0)"} : ""
                        case 4:
                            cell.detailTextLabel?.text =
                                self.myRLMMovie.revenue != 0 ?
                                    formatter.string(from: movie.revenue as NSNumber).map{"$ \($0)"} : ""

                        default:
                            fatalError()
                    }
                }
                
                cell.detailTextLabel?.textColor = .black
                cell.detailTextLabel?.font = UIFont(name: "Montserrat", size: 14)
                
                return cell
            
            case 1...3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell
                
                /*
                cell.selectionStyle = .none
                cell.detailTextLabel?.font = UIFont(name: "Montserrat", size: 14)
                cell.personImageView.layer.masksToBounds = true
                cell.personImageView.layer.cornerRadius  = cell.personImageView.frame.width / 2
                */
                
//                if let imagePath = self.myRLMMovie.poster_path {
//                    let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
//                    cell.personImageView.kf.setImage(with: url)
//                }
            
                return cell
        
            default:
                fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 5
            case 3:
                return 1
            default:
                return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case 0:
                return "Info"
            case 1:
                return "Director"
            case 2:
                return "Screenplay"
            case 3:
                return "Casts"
            default:
                fatalError()
        }
    }
    
    // groupedなテーブルのheader / footerの余白調整
    // http://qiita.com/usagimaru/items/9e821ec0c3d9028f8527 ← 神
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}


extension MovieDetailViewController: UICollectionViewDelegate {
    
}

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath)
        
        return cell
        
    }
    
}








