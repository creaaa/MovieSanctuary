
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = #imageLiteral(resourceName: "noimage")
    }
    
}
