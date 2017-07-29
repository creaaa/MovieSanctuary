
import UIKit


// MEMO: 各VCで個別に設定したい場合は...

// タブバーの色
// self.tabBarController?.tabBar.barTintColor = .orange
// アイコンの色
// self.tabBarController?.tabBar.tintColor = .black
// 選択されていないアイコンの色
// self.tabBarController?.tabBar.unselectedItemTintColor = .white


class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 全部に反映させたい場合はこうすればOK.
        // self.tabBar.barTintColor = .black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

