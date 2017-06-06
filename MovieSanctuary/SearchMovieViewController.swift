
import UIKit

extension UIScrollView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
}

class SearchMovieViewController: UIViewController, UISearchBarDelegate {

    var toggledTableView: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        toggledTableView = GomiView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        view.addSubview(toggledTableView)
        
        
    }
    
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            print(touch.view?.tag)
            removeAllSubviews(parentView: self.view)
            
        }
    }
    */
    
    
    func removeAllSubviews(parentView: UIView) {
        
        let subviews = parentView.subviews
        
        subviews.forEach{ $0.removeFromSuperview() }
        
        self.loadViewIfNeeded()
        
    }
    
    
    
}
