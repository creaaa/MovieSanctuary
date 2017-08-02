
import UIKit
import Kingfisher
import APIKit
import Himotoki
import RealmSwift

import SystemConfiguration


final class MovieListViewController: UIViewController {
    
    let realm = try! Realm()
    
    // Model
    
    // このVCがタブ2で使われる場合: お気に入り追加した映画たちが入る(Realmから取得、APIコールなし)
    // このVCがキーワード検索で使われる場合: 検索結果の映画たちが入る(APIコールあり)
    var movies: [Movieable] = []
    
    var unkoRLMs: [RLMMovie] = []
    
    // 無限スクロールを連続コールしないための変数
    var isFetching = false
    
    
    // ここ、fileprivateだったのに、internalにしちゃった理由はなに??
    // → もう片方のタブからここを操作したかったから。
    // やばかったら元に戻す。
    lazy var resultView: ResultView = {
        
        let resultView = ResultView.instantiateFromNib()
        resultView.frame = self.view.bounds  // If you miss this, HELL comes
        
        resultView.tableView.delegate   = self
        resultView.tableView.dataSource = self
        
        resultView.tableView.register(nibCell: TableViewCell.self)
        
        return resultView
        
    }()
    
    
    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Realmのパス
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.view.addSubview(self.resultView)
        
        // この画面が検索結果表示なら  → 1  となる
        // この画面がお気に入り画面なら → 0  となる
        // 0(=お気に入り画面)のときだけleft buttonを表示。
        if self.navigationController?.viewControllers.index(of: self) == 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
            // tableViewがナビゲーションバーに食い込まないようにする設定
            let edgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
            resultView.tableView.contentInset          = edgeInsets
            resultView.tableView.scrollIndicatorInsets = edgeInsets
        }

        
        if self.tabBarController?.selectedIndex == 1 {
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: #imageLiteral(resourceName: "info"),
                                style: .done,
                                target: self,
                                action: #selector(infoButtonTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = .white
        }
        
        
        if self.navigationController?.viewControllers.index(of: self) == 1 {
            connectForMovieSearch(query: self.query) // page = 1 を暗黙的に渡している
        }
        
        // 次のpushVCのバーに表示される "< back" ボタンのラベルは、遷移元で定義せねばなりません。
        // ここの記述は、 2→3の遷移時、遷移後のほうのVCの戻るボタンのラベルを空白にするため書いてます。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = self.resultView.tableView.indexPathForSelectedRow {
            self.resultView.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if self.navigationController?.viewControllers.index(of: self) == 0  {
            
            // self.movies = []
            
            /*** 1. メモリリークしないやつ ***/
            /*
            // これだとメモリリークしない
            let m = RLMMovie(id: 1, title: "", poster_path: "", vote_average: 1, vote_count: 1, overview: "", release_date: "", runtime: 1, budget: 1, revenue: 1, homepage: "")
            // まだしてない
            let g = RLMGenre(id: 100, name: "unnn")
            m.genres.append(g)
            // まだしてない
            // self.unkoRLMs.append(contentsOf: [m])
            // まだしてない
            self.movies.append(contentsOf: [m])
            
            self.resultView.tableView.reloadData()
            */
            
            // 2. メモリリークするやつ
            /*
            let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
            res.forEach {
                self.movies.append($0)
            }
            self.resultView.tableView.reloadData()
            */
            
            // 3.
            // しない
            /*
            let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
            
            let r: RLMMovie = res[0] // この型にして...
            self.movies.append(r)    // appendするとメモリリークしない
            
            self.resultView.tableView.reloadData()
            */
            
            // 3.5　よって、、、これは、、、いけた！！！！！！！！！！！！！！！！！
            reload()
            /*
            self.movies = []
            let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
            
            (0..<res.count).forEach {
                let movie: RLMMovie = res[$0]
                self.movies.append(movie)
            }
            self.resultView.tableView.reloadData()
            */
            
            
            // 4.リーク
            /*
            let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
            do {
                let mapped = try res.map(oreMyMap)
                self.movies = mapped // [Movieable] を [RLMMovie] で塗り替える形。。。
                self.resultView.tableView.reloadData()
            } catch {
            }
            */
            
        }
        
    }
    
    /* // ↑のパターン4で使うヘルパー
    private func oreMyMap(m: RLMMovie) throws -> RLMMovie {
        return m
    }
    */
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1 = 検索結果の表示画面として使われるときだけ、APIコール
        if self.tabBarController?.selectedIndex == 1 {
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: #imageLiteral(resourceName: "info"),
                                style: .done,
                                target: self,
                                action: #selector(infoButtonTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = .white
        }
        
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        print("消滅した")
    }
    
    
    
    fileprivate func reload() {
        
        self.movies = []
        let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
        
        (0..<res.count).forEach {
            let movie: RLMMovie = res[$0]
            self.movies.append(movie)
        }
        self.resultView.tableView.reloadData()

    }
    
    
    
    //////////////////////////
    // MARK: - API connection
    //////////////////////////
    
    var query: String! // 1 → 2遷移時、画面1から渡ってくる
    var page = 1
    
    // API Connection
    func connectForMovieSearch(query: String, page: Int = 1) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        guard self.movies.count <= 90 else {
            print("can't get data over 100")
            return
        }
        
        // 連続コールされないための処理
        guard self.isFetching == false else {
            print("連続コールすんなや")
            return
        }
        
        // 処理スタート！
        self.isFetching = true
        
        let manager = MovieSearchManager()
        
        // クエリ検索
        // このコールバックは.success時に発動する。。。つまり、
        // .failureのときは moviesは空のまま(nilにはならないが)、ってことだ。。。
        DispatchQueue.global().async {
            manager.request(query: query, page: page) { result in
                result.results.forEach {
                    self.movies.append($0)
                }
                self.resultView.tableView.reloadData()
                self.isFetching = false // これfailureのときには実行されないからやばい....。
            }
        }
    }
    
    
    func infoButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "AboutThisApp") as! UINavigationController
        vc.view.backgroundColor = .white
        present(vc, animated: true, completion: nil)
    }
    
}


extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // デフォルトでは20件を取得
        // infitite scroll
        if self.movies.count >= 20 &&
            self.movies.count - indexPath.row <= 4 &&
            // お気に入り画面(= 0)の中ではAPIコールしちゃダメよ。
            self.navigationController?.viewControllers.index(of: self) == 1 {
            print("無限スクロール発動！")
            self.page += 1
            connectForMovieSearch(query: self.query, page: self.page)
        } else {
            print(indexPath.row)
        }
        
        return configureCell(tableView, indexPath)
        
    }
    
    // need this if you use xib for cell(← マジだった。auto sizing できないみたい。)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // dequeue(withIdentifier:indexPath) causes infinite roop...😨 so use this.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        return cell.bounds.height
    }
    
    /* delete */
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.resultView.tableView.isEditing = editing
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            try! self.realm.write {
                let res: Results<RLMMovie> = self.realm.objects(RLMMovie.self)
                self.realm.delete(res[indexPath.row])
                reload()
            }
        }
    }
    
    ////////////////////////////////////
    // MARK: - Configure
    ////////////////////////////////////
    
    fileprivate func configureCell(_ tableView: UITableView, _ indexPath: IndexPath) -> TableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: TableViewCell.self, for: indexPath)
        
        cell.titleLabel.text = self.movies[indexPath.row].title
        
        if let genre1 = self.movies[indexPath.row].genres.first {
            cell.genre1Label.text = genre1.name
            if cell.genre1Label.text == "Science Fiction" {
                cell.genre1Label.text = "SF"
            }
        } else {
            cell.genre1Label.isHidden = true
        }
        
        if self.movies[indexPath.row].genres.count >= 2 {
            cell.genre2Label.text = self.movies[indexPath.row].genres[1].name
            if cell.genre2Label.text == "Science Fiction" {
                cell.genre2Label.text = "SF"
            }
        } else {
            cell.genre2Label.isHidden = true
        }
        
        if let imagePath = self.movies[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            cell.posterImageView.kf.setImage(with: url,
                                             placeholder: #imageLiteral(resourceName: "noimage"),
                                             options: [.transition(.fade(0.3))])
        }
        
        if self.movies[indexPath.row].vote_average != 0.0 {
            cell.voteAverageLabel.text = Int(self.movies[indexPath.row].vote_average * 10).description + "%"
        } else {
            cell.voteAverageImageView.isHidden = true
            cell.voteAverageLabel.isHidden     = true
        }
        
        if self.movies[indexPath.row].vote_count != 0 {
            cell.voteCountLabel.text = self.movies[indexPath.row].vote_count.description
        } else {
            cell.voteCountImageView.isHidden = true
            cell.voteCountLabel.isHidden     = true
        }
        
        return cell
        
    }
    
}


extension MovieListViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        
        vc.movieID = self.movies[indexPath.row].id
        
        //vc.connectForMovieDetail(type: .standard(self.movies[indexPath.row].id))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}



