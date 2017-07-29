
import UIKit

class WelcomeViewControllerCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
}


extension WelcomeViewControllerCell {
    
    // いうまでもなく、セルは再利用される。
    // そのため、スクロールしたぶんの位置のまま再表示されてしまう。
    // それを防ぐための措置
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x}
        set { collectionView.contentOffset.x = newValue }
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate   = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag        = row
        
        // Stops collection view if it was scrolling
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        
        collectionView.reloadData()
    
    }
    
}
