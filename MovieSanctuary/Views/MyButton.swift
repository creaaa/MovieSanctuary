
import UIKit

extension MyButton {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        
        if self.bounds.contains(point) {
            NotificationCenter.default.post(name: Notification.Name("ResultByGenre"), object: nil)
        }
        
        self.titleLabel?.textColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        self.titleLabel?.alpha = 1
        
    }
    
    /*
    func removeAllSubviews(parentView: UIView) {
        let subviews = parentView.subviews
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    
    func parentViewControllerRootView() -> UIView? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                // return viewController.view.subviews[0]
                return viewController.view
            }
            parentResponder = nextResponder
        }
    }
    */
    
}

class MyButton: UIButton {}
