
import UIKit

final class SearchView: UIView, InstantiatableFromNib {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /*
    
    // コード時は、こっちだけが呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //loadNib()
    }
    
    /*
    func loadNib() {
        
        /*
        let view = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        */
    }
     */
 
 
 
    */
 

}



