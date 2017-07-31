
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView:  UIImageView!
    @IBOutlet weak var titleLabel:       UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel:   UILabel!
    
    override func awakeFromNib() {
        self.posterImageView = nil
        self.titleLabel = nil
        self.voteAverageLabel = nil
        self.voteCountLabel = nil
    }
    
}
