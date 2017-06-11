
import UIKit
import Pastel
import Kingfisher

extension SearchVCCategoryScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}


class SearchMovieViewController: UIViewController {

    let hoge: Int

    
    required init?(coder aDecoder: NSCoder) {
        self.hoge = 3
        super.init(coder: aDecoder)
    }
    
    
    
    // Model
    var movies: [ConciseMovieInfoResult] = []
    
    var pastelView: PastelView = {
    
        let pastelView = PastelView()
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint   = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0

        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255,  blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255,  blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255,  blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255,  green: 76/255,  blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255,  green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255,  green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255,  green: 255/255, blue: 217/255, alpha: 1.0)])
 
        
        // pastelView.setPastelGradient(.juicyPeach)
        
        pastelView.startAnimation()
        
        pastelView.translatesAutoresizingMaskIntoConstraints = false
        
        return pastelView
        
    }()
    
 
    var scrollView: SearchVCCategoryScrollView!
    var tableView:  SearchVCResultTableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(hoge)
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonTapped), name: Notification.Name("Toggle"), object: nil)
        
        // APImanagerから送信されるNotifを受信
         NotificationCenter.default.addObserver(self, selector: #selector(didReceiveJSON(sender:)), name: Notification.Name("JSONresult"), object: nil)
        
        self.scrollView = makeScrollView()
        self.tableView  = makeTableView()
        
        // isHiddenすると、「まじでビュー階層から除去される」から、これはダメ
        // self.tableView.isHidden = true
        
        self.tableView.alpha = 0
        
        self.view.addSubview(pastelView)
        
        self.view.addSubview(tableView)
        self.view.addSubview(scrollView)
        
        
        pastelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive   = true
        pastelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pastelView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive           = true
        pastelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive     = true
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = .clear
        
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!]
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Quicksand", size: 15)!], for: .normal)
    }
    
    
 
    func makeScrollView() -> SearchVCCategoryScrollView {
        
        let view = SearchVCCategoryScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        if let searchBar = view.subviews[0].subviews[0] as? UISearchBar {
            
            searchBar.delegate = self
            
            // text field
            if let textField = searchBar.subviews[0].subviews[1] as? UITextField {
                textField.clearButtonMode = .never
                textField.font = UIFont(name: "Quicksand", size: 14)
                
                // placeholderの設定は、まだここではできない。viewDidAppearでやる。
                
            }
            
            // cancel button
            if let button = searchBar.subviews[0].subviews[2] as? UIButton {
                button.setTitleColor(.white, for: .normal)
                button.setTitleShadowColor(.red, for: .normal)
                button.titleLabel?.font = UIFont(name: "Quicksand", size: 14)
            }
            
            // placeholder
            if let placeholder = searchBar.subviews[0].subviews[1] as? UITextField {
                placeholder.textColor = .white
            } else {
                print(searchBar.subviews[0].subviews[1])
            }
            
            
            if let searchField = searchBar.value(forKey: "_searchField") as? UITextField {
                searchField.textColor = .white
            }
        }
        
        return view
        
    }
    
    
    func makeTableView() -> SearchVCResultTableView {
        
        let view = SearchVCResultTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        if let tableView = view.subviews[0].subviews[0] as? UITableView {
            
            tableView.delegate   = self
            tableView.dataSource = self
            
            let xib = UINib(nibName: "TableViewCell", bundle: nil)
            
            tableView.register(xib, forCellReuseIdentifier: "Cell")
            
        }
        
        return view
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let tableView = self.tableView.subviews[0].subviews[0] as? UITableView {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // なぜ、これもviewDidLoadでやればよさそうなものを、わざわざここでやってるのか?
        // なんと、 viewDidLoad時、viewDidAppear時で、UISearchBarのツリー状態が違うのだ！
        // そしてなんと、viewDidLoad時には、プレースホルダーがまだ生成されていない！！
        // だからここでやるしかないのだ。なんてこった。クソはまった。
        if let searchBar = self.scrollView.subviews[0].subviews[0] as? UISearchBar {
            if let textField = searchBar.subviews[0].subviews[1] as? UITextField {
                if let placeHolder = textField.subviews[2] as? UILabel{
                    placeHolder.textColor = .white
                }
            }
        }
        

        
    }
    
    
    /* observe method */
    
    func buttonTapped() {
        
        self.tableView.alpha  = 1

        // これやると、scrollViewがツリー階層から除去されるのがキツイ...
        UIView.transition(from: scrollView,
                          to: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          completion: {_ in print("transition!") }
                         )
        
        // ここじゃないとダメなのは、↑のメソッド実行するとscrollViewが消えるから
        self.scrollView.alpha = 0
        
        self.view.insertSubview(scrollView, belowSubview: tableView)
        
        // transiton時にツリー階層の位置関係が自動で変わるので、もうこれは必要ない
        // view.bringSubview(toFront: tableView)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.tintColor = .blue
    }
    
    
    func didReceiveJSON(sender: Notification) {
        
        switch sender.object {
            
            case let movie as ConciseMovieInfo:
                
                self.movies = movie.results
                self.movies.forEach{ print($0) }
            
                if let tableView = self.tableView.subviews[0].subviews[0] as? UITableView {
                    tableView.reloadData()
                }
            
            default: break
        }
    }
    
    
    func back() {
        
        self.view.endEditing(true)
        
        self.scrollView.alpha = 1
        self.tableView.alpha  = 0
        
        // これやると、scrollViewがツリー階層から除去されるのがキツイ...
        UIView.transition(from: tableView,
                          to: scrollView,
                          duration: 1.0,
                          options: .transitionCurlDown,
                          completion: {_ in print("transition!") }
        )
        
        // ここじゃないとダメなのは、↑のメソッド実行するとscrollViewが消えるから
        self.tableView.alpha = 0
        
        self.view.insertSubview(tableView, belowSubview: scrollView)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = .clear
        
    }
    
    
    // API Connection
    func connect() {
        
        let apiManager = TMDB_APIManager()
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        let text = (self.scrollView.subviews[0].subviews[0] as! UISearchBar).text
        
        queue.async { apiManager.request(query: text!) }
    }
    
    
    // convert genre ID to genre name
    func genreIdToName(_ genreID: Int) -> String {
        
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
                case 10751:
                    return "Family"
                case 10752:
                    return "War"
                case 10770:
                    return "TV Movie"
                default:
                    fatalError("Check ID")
            }
        }
        
        return convert(ID: genreID)
        
    }
    
}


extension SearchMovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text  = self.movies[indexPath.row].name
        
        if let genre1 = self.movies[indexPath.row].genres.first {
            cell.genre1Label.text = genreIdToName(genre1)
        }
        
        if self.movies[indexPath.row].genres.count >= 2 {
            cell.genre2Label.text = genreIdToName(self.movies[indexPath.row].genres[1])
        }
        
        if let imagePath = self.movies[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/" + imagePath)
            cell.posterImageView.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // ここで indexPathつきのほうでやると無限ループになるので、こっちにしろ
        // なお、もちろん、tableViewにregisterを忘れることで。ここがぬるぽとなる
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        return cell.bounds.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        
        if let nextVC = storyboard.instantiateInitialViewController() as? MovieDetailViewController {
            
            // self.present(nextVC, animated: true, completion: nil)
            
            nextVC.tmdb_id = movies[indexPath.row].id
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        }
    
    }
    
}


extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.characters.count != 0 {

            // TODO: DRYじゃねーからまとめとけ
            
            self.tableView.alpha  = 1
            
            // これやると、scrollViewがツリー階層から除去されるのがキツイ...
            UIView.transition(from: scrollView,
                              to: tableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              completion: {_ in print("transition!") }
            )
            
            // ここじゃないとダメなのは、↑のメソッド実行するとscrollViewが消えるから
            self.scrollView.alpha = 0
            
            self.view.insertSubview(scrollView, belowSubview: tableView)
            
            // transiton時にツリー階層の位置関係が自動で変わるので、もうこれは必要ない
            // view.bringSubview(toFront: tableView)
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.tintColor = .blue
            
          
            connect()
        }
        
        searchBar.text = nil
        self.view.endEditing(true)
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.text = nil
        self.view.endEditing(true)
    }
    
}


