
import UIKit
import Kingfisher


final class SearchMovieViewController: UIViewController {
    
    // Model
    var movies: [ConciseMovieInfoResult] = []
    
    // Views
    private lazy var pastelView: UIView = {

        let view = UIView(frame: self.view.bounds)
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(red:0.29, green:0.42, blue:0.72, alpha:1.0).cgColor,
            UIColor(red:0.09, green:0.16, blue:0.28, alpha:1.0).cgColor
        ]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
 
    }()
    
    
    fileprivate lazy var searchView: SearchView = {
        
        let searchView = SearchView.instantiateFromNib()
        searchView.frame = self.view.bounds // If you miss this, HELL comes

        searchView.searchBar.delegate = self
        
        if let textField = searchView.searchBar.subviews[0].subviews[1] as? UITextField {
            textField.clearButtonMode = .never
            textField.font = UIFont(name: "Quicksand", size: 14)
            textField.textColor = .white
            
            // can't set placeholder here yet; do in viewDidAppear
        }
        
        if let button = searchView.searchBar.subviews[0].subviews[2] as? UIButton {
            button.setTitleColor(.white, for: .normal)
            button.setTitleShadowColor(.red, for: .normal)
            button.titleLabel?.font = UIFont(name: "Quicksand", size: 14)
        }
        
        return searchView

    }()
    
    
    fileprivate lazy var resultView: ResultView = {
        
        let resultView = ResultView.instantiateFromNib()
        resultView.frame = self.view.bounds  // If you miss this, HELL comes
        
        resultView.tableView.delegate   = self
        resultView.tableView.dataSource = self
        
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        resultView.tableView.register(xib, forCellReuseIdentifier: "Cell")
        
        // resultView.tableView.register(TableViewCell.self)
        
        return resultView
        
    }()
    
    
    ////////////////////////
    // MARK: - Life Cycle
    ////////////////////////
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(genreButtonTapped(sender:)), name: Notification.Name("ResultByGenre"), object: nil)
        
        // this is invalid cuz it's removed from view hierarchy
        // self.tableView.isHidden = true
        
        self.resultView.alpha = 0
    
        // cause ambiguity for some reason...😡
        // self.view = pastelView
    
        //self.view.addSubview(self.pastelView)
        
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(red:0.29, green:0.42, blue:0.72, alpha:1.0).cgColor,
            UIColor(red:0.09, green:0.16, blue:0.28, alpha:1.0).cgColor
        ]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        self.view.addSubview(self.resultView)
        self.view.addSubview(self.searchView)
                
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(backToSearchView)).apply {
                $0.isEnabled = false
                $0.tintColor = .clear
                $0.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!], for: .normal)
            }
        
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!]
        
        // navibar's back button setting
        let backButton = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        
        backButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!], for: .normal)
        
        self.navigationItem.backBarButtonItem = backButton
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = self.resultView.tableView.indexPathForSelectedRow {
            self.resultView.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if let textField = self.searchView.searchBar.subviews[0].subviews[1] as? UITextField {
            if let placeHolder = textField.subviews[2] as? UILabel {
                placeHolder.textColor = .white
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ////////////////////////
    // MARK: - Change View
    ////////////////////////
    
    func genreButtonTapped(sender: Notification) {
        
        toggleLeftBarButton()
        flipView()
        
        if let tag = sender.userInfo?["buttonTag"] as? Int {
            print(tag)
            connect(btnTag: tag)
        }
    }
    

    
    func backToSearchView() {
        
        self.movies = []
        self.APIManager = nil
        
        self.resultView.tableView.reloadData()
        
        toggleLeftBarButton()
        flipView()
        
    }
    
    func flipView() {
        
        // FIXME: tell me more better judging way🤔
        let isSearchViewFront = self.resultView.alpha == 0
        
        (isSearchViewFront ? resultView : searchView).alpha = 1
        
        UIView.transition(from: isSearchViewFront ? searchView : resultView,
                          to:   isSearchViewFront ? resultView : searchView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          completion: {_ in print("transition!") }
        )
        
        (isSearchViewFront ? searchView : resultView).alpha = 0
        
        self.view.insertSubview(isSearchViewFront ? searchView : resultView,
                                belowSubview: isSearchViewFront ? resultView : searchView)
        
    }
    
    
    func toggleLeftBarButton() {
        
        let isEnabled = self.navigationItem.leftBarButtonItem!.isEnabled
        
        if isEnabled {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = .clear
        } else {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.tintColor = .blue
        }
        
    }
    
    
    //////////////////////////
    // MARK: - API connection
    //////////////////////////
    
    var APIManager: Manager!
    
    // API Connection
    func connect(btnTag: Int = 0) {
        
        guard self.movies.count <= 90 else {
            print("can't get data over 100")
            return
        }
        
        // ジャンル
        if btnTag != 0 {
            
            // APIManagerがなければ生成
            if self.APIManager == nil {
                self.APIManager = TMDB_Genre_Manager(genreID: btnTag) as Manager
            }

            if let APIManager = self.APIManager as? TMDB_Genre_Manager {
                APIManager.request { res in
                    self.movies.append(contentsOf: res.results)
                    self.resultView.tableView.reloadData()
                }
            }
            
        } else {  // キーワード
            
            let text = self.searchView.searchBar.text
            
            if self.APIManager == nil {
                self.APIManager = TMDB_APIManager(query: text!) as Manager
            }

            if let APIManager = self.APIManager as? TMDB_APIManager {
                APIManager.request { res in
                    self.movies.append(contentsOf: res.results)
                    self.resultView.tableView.reloadData()
                }
            }
        }
    }
}


////////////
// MARK: -
////////////

extension SearchMovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        // let cell = tableView.dequeueReusableCell(with: TableViewCell.self, for: indexPath)
        
        cell.titleLabel.text = self.movies[indexPath.row].name
        
        if let genre1 = self.movies[indexPath.row].genres.first {
            cell.genre1Label.text = SearchMovieViewController.genreIdToName(genre1)
        } else {
            cell.genre1Label.isHidden = true
        }
        
        if self.movies[indexPath.row].genres.count >= 2 {
            cell.genre2Label.text = SearchMovieViewController.genreIdToName(self.movies[indexPath.row].genres[1])
        } else {
            cell.genre2Label.isHidden = true
        }
        
        if let imagePath = self.movies[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            cell.posterImageView.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // dequeue(withIdentifier:indexPath) causes infinite roop...😨 so use this;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        // let cell = tableView.dequeueReusableCell(with: TableViewCell.self, for: indexPath)
        
        return cell.bounds.height
 
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        
        if let nextVC = storyboard.instantiateInitialViewController() as? MovieDetailViewController {
            
            nextVC.tmdb_movie = movies[indexPath.row]
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
}


extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.characters.count != 0 {
            
            toggleLeftBarButton()
            flipView()
            
            connect()
            
        }
        
        self.view.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyBoard(searchBar)
    }
    
    func dismissKeyBoard(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.view.endEditing(true)
    }
    
}


extension SearchMovieViewController {
    
    // convert genre ID to genre name
    static func genreIdToName(_ genreID: Int) -> String {
        
        func convert(ID: Int) -> String {
            switch ID {
            case 12:
                return "Adventure"
            case 14:
                return "Fantasy"
            case 16:
                return "Animation"
            case 18:
                return "Drama"
            case 27:
                return "Horror"
            case 28:
                return "Action"
            case 35:
                return "Comedy"
            case 36:
                return "History"
            case 37:
                return "Western"
            case 53:
                return "Thriller"
            case 80:
                return "Crime"
            case 99:
                return "Documentary"
            case 878:
                return "Science Fiction"
            case 9648:
                return "Mystery"
            case 10402:
                return "Music"
            case 10749:
                return "Romance"
            case 10769:
                return ""
            case 10751:
                return "Family"
            case 10752:
                return "War"
            case 10770:
                return "TV Movie"
            default:
                fatalError("Check ID \(ID)")
            }
        }
        
        return convert(ID: genreID)
        
    }
}



// disable scrollView from touch event

/*
extension SearchView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
*/


