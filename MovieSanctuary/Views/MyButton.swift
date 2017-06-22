
import UIKit

extension MyButton {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        
        if self.bounds.contains(point) {
            
            NotificationCenter.default.post(name: Notification.Name("ResultByGenre"),
                                            object: nil,
                                            userInfo: ["buttonTag": self.tag])
            
        }
        
        self.titleLabel?.textColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        self.titleLabel?.alpha = 1
        
    }
    
}

class MyButton: UIButton {}

