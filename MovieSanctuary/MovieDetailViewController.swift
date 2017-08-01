
import UIKit
import RealmSwift
import Kingfisher

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView:        UITableView!
    @IBOutlet weak var collectionView:   UICollectionView!
    
    @IBOutlet weak var posterImageView:  UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel:   UILabel!
    @IBOutlet weak var overviewLabel:    UILabel!
    
    @IBOutlet weak var posterImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight:       NSLayoutConstraint!
    
    
    // 上記の、Realmナイズされたモデル
    var myRLMMovie: RLMMovie!
    
    // 1 → 3遷移時 or 2 → 3遷移時、前画面から受け渡されてくる。
    // ↑の変数もありながらもう1個作るのかよ...って思うが、仕方ない...
    var movieID: Int!
    
    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Realmのパス
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.view.backgroundColor = .white
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        // お気に入り → 詳細画面 の場合なら、Favボタンが必要なわけない,,,
        // ただし、詳細 → 詳細 の場合ならいる。のでこれ直せ。↓
        if self.tabBarController?.selectedIndex == 0 {
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addFavorite))
        }
        
        // 次のpushVCのバーに表示される "< back" ボタンのラベルは、遷移元で定義せねばなりません。
        // ここの記述は、 3→3の遷移時、遷移後のほうのVCの戻るボタンのラベルを空白にするため書いてます。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
        connectForMovieDetail()
        
    }

    override func viewDidLayoutSubviews() {
    
        let screenHeight = UIApplication.shared.keyWindow?.bounds.height
        screenHeight.map {
            // (64: ステバー+ナビバー) - (49: タブバー) - (60: スコアビュー)
            // print("画像高さ", $0 - 64 - 49 - 60)
            self.posterImageViewHeight.constant = $0 - 64 - 49 - 60
        }
        
        
        // このサイトがまじで神だった。。。
        // http://blog.ch3cooh.jp/entry/20160108/1452249000
        // ちなみにこのconstant, 決め打ちで200とかやるとスクロールおかしくなる
        // (TableViewのほうにスクロールが奪われ、この画面全体のスクロールが効かなくなる)
        // いや、ほんとこのサイトまじ助かった...
        self.tableViewHeight.constant = self.tableView.contentSize.height
    
    }
    

    // will・didDisappear、ブレイク打っても突入しないんだが、デバッグできないのか？？
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit { print("消滅した") }

    func addFavorite() {
        // これ、update = trueって明示しないと落ちる。
        // よって、defaultはfalseってことか...
        // true = 既存のオブジェクトを参照し、存在すればそれに対しアップデートをかける。
        // false = 既存のオブジェクトを参照しようとせず、新たに作る。
        // もちろんそのとき、既にあるprimary key で作成しようとすると実行時エラーとなる。
        do {
            
            
            let realm = try Realm()
            
            try realm.write {
                realm.add(self.myRLMMovie, update: true)
                showAlert(title: "Saved!")
            }
        } catch {
            showAlert(title: "Save failed...", message: "unexpected error happned")
        }
        
    }
    

    //////////////////////////
    // MARK: - API connection
    //////////////////////////

    func connectForMovieDetail() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            // このコールバックは .success時のみに実行される...つまり
            // .failureだったら、myRLMMovie = nil の可能性がある、ということ！やばい
            manager.request(id: self.movieID) { result in
                self.myRLMMovie = result
                print(self.myRLMMovie)
                self.render()
            }
        }
    }

    
    ///////////////////////////////////
    // MARK: - Configure & Render View
    ///////////////////////////////////
    
    func render() {

        guard let movie = self.myRLMMovie else {
            showAlert(title: "No Movie", message: "failed to find the movie.")
            return
        }
        
        self.title = movie.title

        if let imagePath = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            self.posterImageView.kf.setImage(with: url,
                                             placeholder: nil,
                                             options: [.transition(.fade(0.4)), .forceTransition])
        }
        
        self.voteAverageLabel.text = Int(movie.vote_average * 10).description + "%"
        self.voteCountLabel.text   = movie.vote_count.description
        
        self.overviewLabel.text = movie.overview
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
    }
    
}


extension MovieDetailViewController: UITableViewDelegate {}

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
                
                cell.detailTextLabel?.textColor = .black
                cell.detailTextLabel?.font = UIFont(name: "Montserrat", size: 14)
                
                // これしないと、初回にエラーで落ちる
                guard let movie = self.myRLMMovie else { return cell }
                
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
                    var genreText: String = ""
                    if movie.genres.count >= 1 {
                        genreText.append(movie.genres[0].name)
                    }
                    if movie.genres.count >= 2 {
                        genreText.append(", ")
                        genreText.append(movie.genres[1].name)
                    }
                    cell.detailTextLabel?.text = genreText
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
//                cell.detailTextLabel?.textColor = .black
//                cell.detailTextLabel?.font = UIFont(name: "Montserrat", size: 14)
                
                return cell
            
            case 1...3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell

                // これないと初回エラー
                guard let movie = self.myRLMMovie else { return cell }
                    
                // for section 1 & 2
                var crews: [RLMCrew] = []
                movie.credits.crews.forEach {
                    crews.append($0)
                }
                
                // for section 3
                var casts: [RLMCast] = []
                movie.credits.casts.forEach {
                    casts.append($0)
                }
                
                switch indexPath.section {
                case 1:
                    let directors = crews.filter{ $0.job == "Director" }
                    if let profilePath = directors[indexPath.row].profile_path {
                        let url = URL(string: "https://image.tmdb.org/t/p/original/" + profilePath)
                        cell.personImageView.kf.setImage(with: url,
                                                         placeholder: nil,
                                                         options: [.transition(.fade(0.4)), .forceTransition])
                    }
                    cell.nameLabel.text = directors[indexPath.row].name
                case 2:
                    let screenplays =
                        crews.filter{ $0.job == "Screenplay" || $0.job == "Writer" }
                    if let profilePath = screenplays[indexPath.row].profile_path {
                        let url = URL(string: "https://image.tmdb.org/t/p/original/" + profilePath)
                        cell.personImageView.kf.setImage(with: url,
                                                         placeholder: nil,
                                                         options: [.transition(.fade(0.4)), .forceTransition])
                    }
                    cell.nameLabel.text = screenplays[indexPath.row].name
                case 3:
                    if let profilePath = casts[indexPath.row].profile_path {
                        let url = URL(string: "https://image.tmdb.org/t/p/original/" + profilePath)
                        cell.personImageView.kf.setImage(with: url,
                                                         placeholder: nil,
                                                         options: [.transition(.fade(0.4)), .forceTransition])
                    }
                    cell.nameLabel.text = casts[indexPath.row].name
                default:
                    fatalError()
                }

                return cell
        
            default:
                fatalError()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 5
            case 1:
                // これないと初回エラー。
                guard let movie = self.myRLMMovie else { return 0 }
                
                var crews: [RLMCrew] = []
                
                movie.credits.crews.forEach {
                    crews.append($0)
                }
                
                let directors =
                    crews.filter{ $0.job == "Director" }
                return directors.count
            case 2:  // Screenplay&Writer
                guard let movie = self.myRLMMovie else { return 0 }
                
                var crews: [RLMCrew] = []
                movie.credits.crews.forEach {
                    crews.append($0)
                }
                
                let screenplays =
                    crews.filter{ $0.job == "Screenplay" || $0.job == "Writer" }
                return screenplays.count
            case 3:
                guard let movie = self.myRLMMovie else { return 0 }
                
                if movie.credits.casts.count >= 5 {
                    return 5
                } else {
                    return movie.credits.casts.count
                }
            
            default:
                fatalError()
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


/////////////////////
// Collection View //
/////////////////////

extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            showAlert(title: "No network", message: "try again later...")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // そもそもセルアイテムをタップできる時点で recommendationsがnilなわけないと思うのだが。。。
        // いかんせん不可解なエラーが出てるので、防御的に書く。
        // デバッガビリティ高めるため、ここ、わざと冗長的に書いてます...
        guard let movie = self.myRLMMovie else {
            showAlert(title: "couldn't open page", message: "try again later.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        // この書き方、recommendationsがnilだった場合に実行時エラー引き起こさないのか?意味あるか??
        // → あった。recommendationsがnilの場合、else節が実行される
        // とりあえずの対処法...
        // アラート出して、popさせてこの画面から離脱させる...
        // ↑のguard節ではなく、ここがやばいっぽいな。recommendataionsがnilになる
        guard let rcm = movie.recommendations else {
            
            // self.navigationController?.popViewController(animated: true)
            // showAlert(title: "couldn't open page", message: "try again later.")
            
            popViewController(animated: true, completion: showAlertRemotely)
            
            return
            
        }
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        
        
        // まじか！！！ここでrecommendationsがnilで落ちてる。
        // ちゃんとcollectionセルたち表示されてるのに　ちょっと意味わからんですね
        // recommendationsの配列、なぜか[1]から始まってる！
        // それで[0]のセルタップしたとき落ちてる、あやしい
        
        // po self.myRLMMovie するとちゃんと, recommendationsちゃんとあるのに
        // po self.myRLMMovie.recommendations すると nil は？？？？？？
        // vc.connectForMovieDetail(type: .standard(self.myRLMMovie.recommendations.results[indexPath.row].id))
        // ↑のコールバックで遷移、とかにしないとやばくないか。
        
        vc.movieID = rcm.results[indexPath.row].id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func showAlertRemotely() {

        // nilになってしまう...detailVCがもう開放されているからってことか..?
        // ちがう。VC自体はまだ生存しているが、navigationControllerが既にnil...
        
//        let idx: Int? = self.navigationController?.viewControllers.index(of: self)
//        
//        if let vc = self.navigationController?.viewControllers[idx!-1] as? WelcomeViewController {
//            vc.showAlert(title: "un", message: "unn")
//        }
        
    }
    
    
}


extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let movie = self.myRLMMovie,
            // この書き方、recommendationsがnilだった場合に実行時エラー引き起こさないのか?意味あるか??
              let rcm = movie.recommendations else { return 0 }
        
        return rcm.results.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! DetailCollectionViewCell
        
        guard let movie = self.myRLMMovie,
              let rcm = movie.recommendations else { return cell }
        
        ///////////////
        
        // ここでも落ちた。
        if let imagePath = rcm.results[indexPath.row].poster_path {
            if let url = URL(string: "https://image.tmdb.org/t/p/original" + imagePath) {
                cell.posterImageView.kf.setImage(with: url,
                                                 placeholder: nil,
                                                 options: [.transition(.fade(0.4)), .forceTransition])
            }
        }
        
        cell.titleLabel.text       = rcm.results[indexPath.row].title
        cell.voteAverageLabel.text = Int(rcm.results[indexPath.row].vote_average * 10).description + "%"
        cell.voteCountLabel.text   = rcm.results[indexPath.row].vote_count.description
        
        return cell
        
    }
    
}


