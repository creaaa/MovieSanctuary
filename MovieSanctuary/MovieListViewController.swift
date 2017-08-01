
import UIKit
import Kingfisher
import APIKit
import Himotoki
import RealmSwift

import SystemConfiguration


final class MovieListViewController: UIViewController {
    
    var realm = try! Realm()
    
    // Model
    
    // このVCがタブ2で使われる場合: お気に入り追加した映画たちが入る(Realmから取得、APIコールなし)
    // このVCがキーワード検索で使われる場合: 検索結果の映画たちが入る(APIコールあり)
    var movies: [Movieable] = []
    
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
        
        // tableViewがナビゲーションバーに食い込まないようにする設定
        // (お気に入り画面として使うときだけ食い込むため、そのときのみ矯正)
        if self.tabBarController?.selectedIndex == 1 {
            let edgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
            resultView.tableView.contentInset          = edgeInsets
            resultView.tableView.scrollIndicatorInsets = edgeInsets
        }

        // この画面が検索結果表示なら  → 1  となる
        // この画面がお気に入り画面なら → 0  となる
        // 0(=お気に入り画面)のときだけleft buttonを表示。
        if self.navigationController?.viewControllers.index(of: self) == 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        
        // 1 = 検索結果の表示画面として使われるときだけ、APIコール
        if self.navigationController?.viewControllers.index(of: self) == 1 {
            // connectForMovieSearch(query: self.query) // page = 1 を暗黙的に渡している
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = self.resultView.tableView.indexPathForSelectedRow {
            self.resultView.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if self.navigationController?.viewControllers.index(of: self) == 0  {
            reload()
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("消滅した")
    }
    
    
    ////////////////////////////////////
    // MARK: - Configure & Render View
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
    
    
    fileprivate func reload() {
        
        let res: Results<RLMMovie> = realm.objects(RLMMovie.self)

        // 整合性を保つ
        // Results<RLMMovie> → [Movieable]
        self.movies = []
        res.forEach {self.movies.append($0) }
        
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
}


extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // デフォルトでは20件を取得
        // infitite scroll
        if self.movies.count >= 20 && self.movies.count - indexPath.row <= 4 {
            print("無限スクロール発動！")
            self.page += 1
            connectForMovieSearch(query: self.query, page: self.page)
        } else {
            print(indexPath.row)
        }
        
        return configureCell(tableView, indexPath)
        
    }
    
    // need this if you use xib for cell
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
    
}


extension MovieListViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
   
        vc.connectForMovieDetail(type: .standard(self.movies[indexPath.row].id))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}




