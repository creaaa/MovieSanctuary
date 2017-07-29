
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let font = "Montserrat"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ナビゲーションバーのタイトルz
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: self.font, size: 18) as Any
        ]
        
        // ナビゲーションバーの背景色
        // (なんとサーチバーのテキストまで黒くなる...)
        UINavigationBar.appearance().barTintColor = .black
        
        // バーボタンアイテムの設定(なんとナビゲーションバーに設置されたサーチバーのキャンセルボタンにも有効)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [ NSFontAttributeName: UIFont(name: font, size: 16) as Any,
              NSForegroundColorAttributeName: UIColor.white
            ],
            for: .normal)
        
        
        
        /*
        // タブバー
        UITabBar.appearance().tintColor = .black
        
        // タブバーのアイコン(フォーカス(=選択された状態)時)
        UITabBar.appearance().tintColor = UIColor(red:0.13, green:0.55, blue:0.83, alpha:1.0)
        */
        
        
        // タブバーのテキストのラベル
        UITabBarItem.appearance().setTitleTextAttributes(
            [ NSFontAttributeName: UIFont(name: font, size: 10) as Any,
              NSForegroundColorAttributeName: UIColor(red:0.13, green:0.55, blue:0.83, alpha:1.0) as Any
            ]
            , for: .normal)
        
        return true
        
    }

}
