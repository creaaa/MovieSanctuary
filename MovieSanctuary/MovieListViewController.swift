
import UIKit
import Kingfisher
import APIKit
import Himotoki

import SystemConfiguration


final class MovieListViewController: UIViewController {
    
    // Model
    
    // このVCがタブ2で使われる場合: お気に入り追加した映画たちが入る
    // このVCがキーワード検索で使われる場合: 検索結果の映画たちが入る
    var movies: [Movie] = []
    
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
        
        self.view.addSubview(self.resultView)

        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!]
        
        connect()
        
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
        
        
        /*
        if let genre1 = self.movies[indexPath.row].genres.first {
            cell.genre1Label.text = MovieListViewController.genreIdToName(genre1)
        } else {
            cell.genre1Label.isHidden = true
        }
        
        if self.movies[indexPath.row].genres.count >= 2 {
            cell.genre2Label.text = MovieListViewController.genreIdToName(self.movies[indexPath.row].genres[1])
        } else {
            cell.genre2Label.isHidden = true
        }
        */
        
        
        if let imagePath = self.movies[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            cell.posterImageView.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    
    //////////////////////////
    // MARK: - API connection
    //////////////////////////
    
    private func insertMock() {
        
        
        
    }
    
    
    
    // API Connection
    func connect() {
     
        let manager = MovieDetailManager()
        
        guard self.movies.count <= 90 else {
            print("can't get data over 100")
            return
        }
        
        let id = 550
        
        manager.request(id: id) { result in
            print(result)
        }
        
    }
}


////////////
// MARK: -
////////////

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        // dequeue(withIdentifier:indexPath) causes infinite roop...😨 so use this;
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        return cell.bounds.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard MovieListViewController.isNetworkAvailable(host_name: "https://api.themoviedb.org/") &&
            MovieListViewController.isNetworkAvailable(host_name: "https://www.omdbapi.com/") else {
                print("no network. try later...")
                showAlert(title: "No network", message: "try again later...")
                return
        }
        print("タッチ")
        
        
        // FIXME: - なおせ
        
        /*
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        if let nextVC = storyboard.instantiateInitialViewController() as? MovieDetailViewController {
            
            nextVC.tmdb_movie = movies[indexPath.row]
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        */
    }
}


extension MovieListViewController {
    
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

