
import UIKit

class SearchVCResultTableView: UIView {

    // コード時は、こっちだけが呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        
        let view = Bundle.main.loadNibNamed("ResultTableView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
    }

}
