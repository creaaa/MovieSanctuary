
// https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {

    var storedOffsets = [Int : CGFloat]()

    var img: UIImage?

    // これ、こうしないとダメ！ []だと最初のnumberOfRowを通過できない！！ /*11*/
    var movies: [[Movieable]] = [[], [], [], [], [],[],[],[],[],[],[]]
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        let searchBar = UISearchBar(frame: .zero)
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle    = .minimal
        searchBar.delegate          = self
        
        self.navigationItem.titleView = searchBar
        // tableView.reloadData()  // viewDidLoad = まだappearしてないので、書かなくてもよい
        
        // ネットワークチェック
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        // グループ作っても意味なかった。なぜなら各タスク内でさらに非同期処理コールしてるので、
        // タスクはソッコー「終わった」扱いになり、すぐ notify されちまう。
        // かわりにタスク終了カウンタをつけることにした。
        connectForNowShowing()
        connectForDiscover()
        connectForMade4U()
        connectForGenre()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("消滅した")
    }
    
    
    // API Connection
    
    var taskDoneCount = 0 {
        didSet {
            if taskDoneCount >= 11 {
                print("全タスクdone!")
                self.tableView.reloadData()
            }
        }
    }
    
    // セクション0: NOW SHOWING
    private func connectForNowShowing() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request { result in
                self.movies[0] = result.results
                self.taskDoneCount += 1
            }
        }
        
    }
    
    // セクション1: MASTERPIECE
    private func connectForDiscover() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            manager.request { result in
                self.movies[1] = result.results
                self.taskDoneCount += 1
            }
        }
    }
    
    // セクション2: MADE4U
    // (ここだけResponseがRLMMovieを使っているため、描写処理が他と違う！要警戒！！)
    private func connectForMade4U() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request(id: 550) { result in
                self.movies[2] = [result]
                self.taskDoneCount += 1
            }
        }
        
    }
    
    // セクション3-10: GENRE
    private func connectForGenre() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            var i = 3
            Genre.genres.forEach {
                manager.request(genre: $0) { result in
                    // ジャンル1なら[3], ジャンル8なら[10]...
                    self.movies[i] = result.results
                    i += 1
                }
                self.taskDoneCount += 1
            }
        }
    }
    
}


extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // NOW ON AIR, MASTERPIECE, MADE 4 YOU
    func numberOfSections(in tableView: UITableView) -> Int { return 11 }
    
    // 1個
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ↓ 実はこのas! サブクラスが持つプロパティを使いたい、とかじゃなければ別にやらんでもよい。
        // 問題なく描画される。@IBOutletを持つ場合でもいける。。奇妙やけど。まぁやめとこう
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! WelcomeViewControllerCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? WelcomeViewControllerCell else { return }
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? WelcomeViewControllerCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    /// header ///
    
    // 注意) おそらく、↓のviewForHeaderを実装した場合は、こっちはシカトされる
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel(frame: .zero)
        
        let headerTitle = ["NOW SHOWING", "MASTERPIECE", "MADE 4 YOU", "ADVENTURE",
                           "FANTASY", "HORROR", "ACTION", "COMEDY",
                           "MYSTERY", "ROMANCE", "FAMILY"]
        
        label.text = headerTitle[section]
        
        label.font = UIFont(name: "Quicksand", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
        
    }
    
}


extension WelcomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        
        let movieID: Int
        
        // 2だけ RLMMovieを使ってるだけで取り方が違うんだ。すべては俺の罪だ
        if collectionView.tag != 2 {
            movieID = self.movies[collectionView.tag][indexPath.row].id
        } else {
            movieID = (self.movies[2] as! [RLMMovie])[0].recommendations.results[indexPath.row].id
        }
        
        vc.connectForMovieDetail(type: .standard(movieID))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension WelcomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("おれのtag: \(collectionView.tag)")
        
        if collectionView.tag == 2 {
            // この書き方だと最初にバグる。なんかいい方法教えてくれ
            // let res = (self.movies[2] as! [RLMMovie])[0].recommendations.results.count
            if self.movies.count > 2 && (self.movies[2] as! [RLMMovie]).count > 0 {
                return (self.movies[2] as! [RLMMovie])[0].recommendations.results.count
            } else {
                return 0
            }
        } else {
            let result = self.movies[collectionView.tag].count
            return result
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // UICollectionViewCell
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item",
                                                      for: indexPath) as! CollectionViewCell
        
        switch collectionView.tag {
            
            case let tag where (0...1).contains(tag) || (3...10).contains(tag):
                
                item.titleLabel.text = self.movies[tag][indexPath.row].title
                
                if let posterPath = self.movies[tag][indexPath.row].poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterPath)
                    item.imageView.kf.setImage(with: url)
                }
            
            case 2:
                
                // ここにある2つの if は、こうしないと最初のここのコールで落ちるから、苦肉の策。
                if self.movies[2].count > 0 {
                    
                    let myRLMMovie = (self.movies[2] as! [RLMMovie])[0]
                    
                    if myRLMMovie.recommendations.results.count != 0 {
                        item.titleLabel.text = myRLMMovie.recommendations.results[indexPath.row].title
                    }
                    
                    if let posterPath = myRLMMovie.recommendations.results[indexPath.row].poster_path {
                        let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterPath)
                        item.imageView.kf.setImage(with: url)
                    }
                    
                }
            
            
            default:
                break
        }
        
        return item
        
    }
    
}


extension WelcomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") else {
            print("no network. try later...")
            showAlert(title: "No network", message: "try again later...")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc   = storyboard.instantiateViewController(withIdentifier: "SearchResult") as! MovieListViewController
        vc.query = searchBar.text!
        
        vc.connectForMovieSearch(query: searchBar.text!)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        // 遷移後、なにげにsearchBarTextDidEndEditingも呼ばれます
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // これでDidEndEditingが呼ばれる
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("呼ばれた")
    }
    
}

