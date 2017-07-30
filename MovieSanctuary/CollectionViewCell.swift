
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel:       UILabel!
    @IBOutlet weak var imageView:        UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel:   UILabel!
    
    override func prepareForReuse() {
        titleLabel.text       = nil
        imageView.image       = #imageLiteral(resourceName: "noimage")
        voteAverageLabel.text = nil
        voteCountLabel.text   = nil
    }
    
}
