
import UIKit

extension SearchVCCategoryScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}


class SearchMovieViewController: UIViewController {

    let names = ["1", "2", "3", "4", "5"]
    
    var scrollView: SearchVCCategoryScrollView!
    var tableView:  UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonTapped), name: Notification.Name("Toggle"), object: nil)
        
        self.scrollView = makeScrollView()
        // self.tableView  = makeTableView()
        
        
        if let searchBar = scrollView.subviews[0].subviews[0].subviews[0] as? UISearchBar {
            print("ほんとにきたよ...")
            searchBar.delegate = self
        }
        
        self.view.addSubview(scrollView)
        
    }
    
    
    func makeScrollView() -> SearchVCCategoryScrollView {
        return SearchVCCategoryScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    }
    
    
    func makeTableView() {
        
        print("ほえええええきたーーーー")
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        
        self.view.addSubview(searchBar)
        
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        // FIXME: - Emergency
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65).isActive = true
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        // FIXME: - Emergency
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        
        tableView.register(xib, forCellReuseIdentifier: "Cell")
        
    }
    
    
    /* observe method */
    
    func buttonTapped() {
        
        /*
        let scrollView = self.view.subviews[0]
        print(scrollView)
        */
        
        makeTableView()
        
    }
    
}


extension SearchMovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = self.names[indexPath.row]
        cell.subtitleLabel.text = "Hello, World"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // ここで indexPathつきのほうでやると無限ループになるので、こっちにしろ
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        return cell.bounds.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ほげーーーー")
    }
    
}


extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        if searchBar.text?.characters.count == 0 {
            print("owata")
        } else {
            print("non-non-non")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("cancel")
        
        // self.view = nil  // これやるとだめ
        
        self.view.endEditing(true)
        
        self.view.addSubview(makeScrollView())
    }
    
}




