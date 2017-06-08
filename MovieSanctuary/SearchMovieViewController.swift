
import UIKit
import Pastel

extension SearchVCCategoryScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}


class SearchMovieViewController: UIViewController {

    let names = ["The Butterfly Effect", "Inception", "Star Wars 8", "Seven", "Citizen Kane"]
    
    var pastelView: PastelView = {
    
        let pastelView = PastelView()
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint   = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        
        pastelView.translatesAutoresizingMaskIntoConstraints = false
        
        return pastelView
        
    }()
    
    var scrollView: SearchVCCategoryScrollView!
    var tableView:  SearchVCResultTableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonTapped), name: Notification.Name("Toggle"), object: nil)
        
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
        }
        
        return view
        
    }
    
    
    func makeTableView() -> SearchVCResultTableView {
        
        let view = SearchVCResultTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        /*
        if let searchBar = view.subviews[0].subviews[0] as? UISearchBar {
            searchBar.delegate = self
        }
        */
        
        if let tableView = view.subviews[0].subviews[0] as? UITableView {
            
            tableView.delegate   = self
            tableView.dataSource = self
            
            let xib = UINib(nibName: "TableViewCell", bundle: nil)
            
            tableView.register(xib, forCellReuseIdentifier: "Cell")
            
        }
        
        return view
        
    }

    
    
    /* observe method */
    
    func buttonTapped() {
        
        // self.scrollView.alpha = 0
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
    
    
}


extension SearchMovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = self.names[indexPath.row]
        cell.genre1Label.text = "Thriller"
        cell.genre2Label.text = "Mystery"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // ここで indexPathつきのほうでやると無限ループになるので、こっちにしろ
        // なお、もちろん、tableViewにregisterを忘れることで。ここがぬるぽとなる
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        return cell.bounds.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ほげーーーー")
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
            
            
        }
        
        self.view.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
//        self.view.endEditing(true)
//        
//        self.scrollView.alpha = 1
//        self.tableView.alpha  = 0
//        
//        // これやると、scrollViewがツリー階層から除去されるのがキツイ...
//        UIView.transition(from: tableView,
//                          to: scrollView,
//                          duration: 1.5,
//                          // transitionCrossDissolve 0.5
//                          options: .transitionCurlUp,
//                          completion: {_ in print("transition!") }
//        )
//        
//        // ここじゃないとダメなのは、↑のメソッド実行するとscrollViewが消えるから
//        self.tableView.alpha = 0
//        
//        self.view.insertSubview(tableView, belowSubview: scrollView)
//        
        
    }
    
}


