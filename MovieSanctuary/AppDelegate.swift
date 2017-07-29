
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let font = "Montserrat"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ナビゲーションバーのタイトル
        
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: self.font, size: 18) as Any
        ]
        
        
//        let title = UILabel(frame: .zero)
//        title.textColor = .white
//        title.font = UIFont(name: font, size: 18)
//        title.text = "Movie Sanctuary"
        
        
        // ナビゲーションバーの背景色
        // (なんとサーチバーのテキストまで黒くなる...)
        UINavigationBar.appearance().barTintColor = .black
        
        // バーボタンアイテムの設定(なんとナビゲーションバーに設置されたサーチバーのキャンセルボタンにも有効)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [ NSFontAttributeName: UIFont(name: font, size: 16) as Any,
              NSForegroundColorAttributeName: UIColor.white
            ],
            for: .normal)
        
        return true
    }

}
