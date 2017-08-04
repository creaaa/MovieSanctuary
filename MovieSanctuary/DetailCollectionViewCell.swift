
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView:  UIImageView!
    @IBOutlet weak var titleLabel:       UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel:   UILabel!
    
    // 万死に値するnil化の罪　一生深く心に刻め
    // てかこれ、prepareForReuseの間違いでは、、どうゆうわけかちゃんと発動してるけど
    override func awakeFromNib() {
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.voteAverageLabel.text = nil
        self.voteCountLabel.text = nil
    }
    
}
