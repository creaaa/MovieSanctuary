
import UIKit
import Pastel


class SearchVCCategoryScrollView: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        loadNib()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        loadNib()
        
    }
    
    func loadNib() {
        
        let pastelView = PastelView(frame: self.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
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
        
        // FIXME: - Magic Number
        // view.insertSubview(pastelView, at: 2)
        self.addSubview(pastelView)
        
        
        
    
        
        let view = Bundle.main.loadNibNamed("SearchCategoryView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        // self.addSubview(view)
        pastelView.addSubview(view)
        
        
        
//        let pastelView = PastelView(frame: view.bounds)
//        
//        // Custom Direction
//        pastelView.startPastelPoint = .bottomLeft
//        pastelView.endPastelPoint = .topRight
//        
//        // Custom Duration
//        pastelView.animationDuration = 3.0
//        
//        // Custom Color
//        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
//                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
//                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
//                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
//                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
//                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
//                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
//        
//        pastelView.startAnimation()
//        
//        // FIXME: - Magic Number
//        view.insertSubview(pastelView, at: 2)
        
        
        
        
        
        
        
        
        
        
        
        
        
    }

}
