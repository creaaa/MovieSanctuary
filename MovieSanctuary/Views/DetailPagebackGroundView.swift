
import UIKit

class DetailPagebackGroundView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
    }
    
    override func layoutSubviews() {
        
        // この初期化作業、↑のイニシャライザやawakeでやるとおかしくなる
        // (おそらくframeの設定に不具合があるのが原因。この時点だとboundsがふさわしくないのでは)
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor(red:0.29, green:0.42, blue:0.72, alpha:1.0).cgColor,
            UIColor(red:0.09, green:0.16, blue:0.28, alpha:1.0).cgColor
        ]
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    
    

}
