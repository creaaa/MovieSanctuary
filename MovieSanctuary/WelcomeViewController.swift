
// https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {

    let model: [[UIColor]] = generateRandomData()
    var storedOffsets      = [Int : CGFloat]()

    var img: UIImage?

    // これが本チャンです。たぶん。
    var movies: [[SearchMovieResult.Movie]] = [[],[],[],[]]
    
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
    
    // セクション1: MASTERPIECE
    func connectForDiscover() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            manager.request { result in
                self.movies[1] = result.results
                // print("おら！", self.movies[1])
                // print("いまや: ", self.movies[1].count)
                
                // FIXME: そもそもこのコールバックは、 .successのときしか実行されない
                // reloadDataのロジック、ちゃんとなおせ
                self.tableView.reloadData()
            }
        }
    }
    
    // セクション3: GENRE -> ACTION
    func connectForAction() {
        
        let manager = DiscoverManager()
        
        DispatchQueue.global().async {
            manager.request(genre: .Animation) { result in
                self.movies[3] = result.results
                print("おら！", self.movies[3])
                print("いまや: ", self.movies[3].count)
                // self.tableView.reloadData()
            }
        }
        
    }
    
    
}


extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // NOW ON AIR, MASTERPIECE, MADE 4 YOU
    func numberOfSections(in tableView: UITableView) -> Int { return 4 }
    
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
                    return "NOW ON AIR"
                case 1:
                    return "MASTERPIECE"
                case 2:
                    return "MADE 4 YOU"
                case 3:
                    return "ACTION"
                /*
                case 4:
                    return "SUSPENSE"
                case 5:
                    return "KIDS"
                */
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
        
        // 最後はこっちになる
        let result = self.movies[collectionView.tag].count
        return result
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // UICollectionViewCell
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item",
                                                      for: indexPath) as! CollectionViewCell
                
        if case collectionView.tag = 1 {
            
            // print("アイテムNo: \(indexPath.row)")
            
            if let posterPath = self.movies[1][indexPath.row].poster_path {
                let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterPath)
                item.imageView.kf.setImage(with: url)
            }
            
        }
        
        
        if case collectionView.tag = 3 {
            
            // print("アイテムNo: \(indexPath.row)")
            
            if let posterPath = self.movies[3][indexPath.row].poster_path {
                let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterPath)
                item.imageView.kf.setImage(with: url)
            }
            
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






