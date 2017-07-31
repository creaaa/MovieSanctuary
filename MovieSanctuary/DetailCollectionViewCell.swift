
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView:  UIImageView!
    @IBOutlet weak var titleLabel:       UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel:   UILabel!
    
    override func awakeFromNib() {
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.voteAverageLabel.text = nil
        self.voteCountLabel.text = nil
    }
    
}
