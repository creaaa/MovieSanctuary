
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = #imageLiteral(resourceName: "noimage")
    }
    
}
