
import UIKit
import Kingfisher
import APIKit
import Himotoki
import RealmSwift

import SystemConfiguration


final class MovieListViewController: UIViewController {
    
    // Model
    
    // このVCがタブ2で使われる場合: お気に入り追加した映画たちが入る(Realmから取得、APIコールなし)
    // このVCがキーワード検索で使われる場合: 検索結果の映画たちが入る(APIコールあり)
    var movies: [Movieable] = []
    
    fileprivate lazy var resultView: ResultView = {
        
        let resultView = ResultView.instantiateFromNib()
        resultView.frame = self.view.bounds  // If you miss this, HELL comes
        
        resultView.tableView.delegate   = self
        resultView.tableView.dataSource = self
        
        /*
         let xib = UINib(nibName: "TableViewCell", bundle: nil)
         resultView.tableView.register(xib, forCellReuseIdentifier: "Cell")
         */
        
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
        if self.tabBarController?.selectedIndex == 0 {
            let edgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            resultView.tableView.contentInset          = edgeInsets
            resultView.tableView.scrollIndicatorInsets = edgeInsets
        }
        
        
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!]
        
        
        // テーブル内のモデル取得方法の分岐
        // この画面がお気に入り画面なら
        if self.tabBarController?.selectedIndex == 0 {
            
            let realm = try! Realm()
            let res: Results<RLMMovie> = realm.objects(RLMMovie.self)
            
            // Results<RLMMovie> → [Movieable]
            res.forEach {self.movies.append($0) }
            
            // 編集ボタン
            self.navigationItem.leftBarButtonItem = editButtonItem
            
        }
        
        // 検索からの遷移時( ↓のコード)は、前の画面で呼ぶことにしました
        /*
        else if self.tabBarController?.selectedIndex == 1 {
            connectForMovieSearch(query: "Saw")
        }
        */
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = self.resultView.tableView.indexPathForSelectedRow {
            self.resultView.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ////////////////////////////////////
    // MARK: - Configure & Render View
    ////////////////////////////////////
    
    func configureCell(_ tableView: UITableView, _ indexPath: IndexPath) -> TableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: TableViewCell.self, for: indexPath)
        
        cell.titleLabel.text = self.movies[indexPath.row].title
        
        
        if let genre1 = self.movies[indexPath.row].genres.first {
            cell.genre1Label.text = genre1.name
        } else {
            cell.genre1Label.isHidden = true
        }
        
        if self.movies[indexPath.row].genres.count >= 2 {
            cell.genre2Label.text = self.movies[indexPath.row].genres[1].name
        } else {
            cell.genre2Label.isHidden = true
        }
 
        if let imagePath = self.movies[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            cell.posterImageView.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    
    //////////////////////////
    // MARK: - API connection
    //////////////////////////
    
    // API Connection
    
    func connectForMovieSearch(query: String) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        guard self.movies.count <= 90 else {
            print("can't get data over 100")
            return
        }
        
        let manager = MovieSearchManager()
                
        DispatchQueue.global().async {
            manager.request(query: query) { result in
                self.movies = result.results
                self.resultView.tableView.reloadData()
            }
        }
    }
    
}


////////////
// MARK: -
////////////

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        // infitite scroll
        if movies.count >= 20 && movies.count - indexPath.row <= 4 {
            
            self.APIManager.page += 1
            
            if let mng = self.APIManager as? TMDB_Genre_Manager {
                connect(btnTag: mng.genreID)
            } else if let _ = self.APIManager as? TMDB_APIManager {
                connect()
            }
            
            print("current page", self.APIManager)
            
        } else {
            print(indexPath.row)
        }
        */
        
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
            try! Realm().write {
                try! Realm().delete(self.movies[indexPath.row])
            }
            self.resultView.tableView.reloadData()
        }
    }
    
    
}


extension MovieListViewController:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("タッチ")
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! MovieDetailViewController
        
        /*
         // FIXME: もし、遷移元(この画面)が「検索結果一覧VC」だったら
         // 本来はここ 0ではなく、1です。お間違えなきよう...
         if self.tabBarController?.selectedIndex == 0 {
         vc.movieID = self.movies[indexPath.row].id
         }
         */
        
        vc.connectForMovieDetail(movieID: self.movies[indexPath.row].id)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension MovieListViewController {}

