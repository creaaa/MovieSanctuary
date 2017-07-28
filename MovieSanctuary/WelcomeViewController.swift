
// https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {

    let model: [[UIColor]] = generateRandomData()
    var storedOffsets      = [Int : CGFloat]()

    var img: UIImage?

    // これが本チャンです。たぶん。
    // var movies: [[SearchMovieResult.Movie]] = [[],[],[],[]]
    
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
        
        connectForNowShowing()
        connectForMade4U()
        connectForDiscover()
        connectForAction()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("消滅した")
    }
    
    
    
    enum FetchImgError: Error {
        case urlCreationFailed
        case dataCreationFailed
        case imageCreationFailed
    }
        
    func fetchImgFromUrlStr(urlStr: String) throws -> UIImage? {
        
        guard let url  = URL(string: urlStr) else {
            throw FetchImgError.urlCreationFailed
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw FetchImgError.dataCreationFailed
        }
        
        guard let image = UIImage(data: data) else {
            throw FetchImgError.imageCreationFailed
        }
        
        return image
        
    }
    

    // API Connection
    
    // セクション0: NOW SHOWING
    private func connectForNowShowing() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request { result in
                self.movies[0] = result.results
                // print("おら！", self.movies[1])
                // print("いまや: ", self.movies[1].count)
                
                // FIXME: そもそもこのコールバックは、 .successのときしか実行されない
                // reloadDataのロジック、ちゃんとなおせ
                // self.tableView.reloadData()
            }
        }
    }
    
    // セクション1: MASTERPIECE
    private func connectForDiscover() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            manager.request { result in
                self.movies[1] = result.results
                // print("おら！", self.movies[1])
                // print("いまや: ", self.movies[1].count)
                
                // FIXME: そもそもこのコールバックは、 .successのときしか実行されない
                // reloadDataのロジック、ちゃんとなおせ
                // self.tableView.reloadData()
            }
        }
    }
    
    // セクション2: MADE4U (ここだけResponseがRLMMovieを使っているため、描写処理が他と違う！要警戒！！)
    private func connectForMade4U() {
        
        let manager = MovieDetailManager()
        
        DispatchQueue.global().async {
            manager.request(id: 550) { result in
                self.movies[2] = [result]
                // print("おら！", self.movies[2])
                print("いまや: ", self.movies[2].count) // 一個。あたりまえ。
                // self.tableView.reloadData()
            }
        }
        
    }
    
    // セクション3: GENRE -> ACTION
    private func connectForAction() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            manager.request(genre: .Adventure) { result in
                self.movies[3] = result.results
                // print("おら！", self.movies[3])
                // print("いまや: ", self.movies[3].count)
                self.tableView.reloadData()
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
        label.text = {
            switch section {
                
                case 0:
                    return "NOW SHOWING"
                case 1:
                    return "MASTERPIECE"
                case 2:
                    return "MADE 4 YOU"
                
                case 3:
                    return "ADVENTURE"
                case 4:
                    return "FANTASY"
                case 5:
                    return "HORROR"
                case 6:
                    return "ACTION"
                case 7:
                    return "COMEDY"
                case 8:
                    return "MYSTERY"
                case 9:
                    return "ROMANCE"
                case 10:
                    return "FAMILY"

                default:
                    fatalError()
            }
        }()
        
        label.font = UIFont(name: "Quicksand", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
        
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    */
    
    /// footer
    /*
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "ffff"
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    */
    
}


extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("おれのtag: \(collectionView.tag)")
        
        if collectionView.tag == 2 {
            
            // この書き方だと最初にバグる。なんかいい方法教えてくれ
            // let res = (self.movies[2] as! [RLMMovie])[0].recommendations.results.count
            
            return 20
            
        }
        
        let result = self.movies[collectionView.tag].count
        return result
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // UICollectionViewCell
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item",
                                                      for: indexPath) as! CollectionViewCell
        
        switch collectionView.tag {
            
            case let tag where (0...1).contains(tag) || (3...3).contains(tag):
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
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
        
        let vc         = storyboard.instantiateViewController(withIdentifier: "SearchResult") as! MovieListViewController
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






