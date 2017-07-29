//
//import UIKit
//
//func generateRandomData() -> [[UIColor]] {
//    
//    let numberOfRows        = 10
//    let numberOfItemsPerRow = 10
//    
//    let hoge = (0..<numberOfRows).map { _ in
//        (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
//    }
//    
//    return hoge  // [[UIColor]]
//    
//}
//
//
//extension UIColor {
//    class func randomColor() -> UIColor {
//        let hue        = CGFloat(arc4random() % 100) / 100
//        let saturation = CGFloat(arc4random() % 100) / 100
//        let brightness = CGFloat(arc4random() % 100) / 100
//        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//    }
//}
