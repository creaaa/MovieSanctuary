
import UIKit

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}


extension UIButton {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
                       
            removeAllSubviews(parentView: parentViewControllerRootView()!)
            
            NotificationCenter.default.post(name: Notification.Name("Toggle"), object: nil)
            
        }
    }

    func removeAllSubviews(parentView: UIView) {
        
        parentView.backgroundColor = .orange
        
        print("おら、子は", parentView.subviews)
        
        let subviews = parentView.subviews
        
        subviews.forEach{ $0.removeFromSuperview() }
        
    }
    
    
    func parentViewControllerRootView() -> UIView? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                // return viewController.view.subviews[0] // こっちだとinsetが正しい
                return viewController.view  // こっちだとinsetがおかしい
            }
            parentResponder = nextResponder
        }
    }
    
}



class SearchMovieViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    let names = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(makeTableView), name: Notification.Name("Toggle"), object: nil)
        
        self.view.addSubview(makeScrollView())
        
    }
    
    
    func makeScrollView() -> SearchVCCategoryScrollView {
        return SearchVCCategoryScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
    }
    
    
    func makeTableView() {
        
        print("ほえええええきたーーーー")
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.delegate   = self  // これらは、assSubViewしたあとに呼ばないとだめっぽい？？
        tableView.dataSource = self  // こっちもね
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        
        tableView.register(xib, forCellReuseIdentifier: "Cell")
        
    }
    
}


extension SearchMovieViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = self.names[indexPath.row]
        cell.subtitleLabel.text = "さようなら"
        
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



