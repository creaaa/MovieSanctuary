
import UIKit

final class TableViewCell: UITableViewCell, Nibable {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genre1Label: UILabel!
    @IBOutlet weak var genre2Label: UILabel!

    @IBOutlet weak var voteAverageImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountImageView: UIImageView!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    override func prepareForReuse() {
        
        self.titleLabel.text = ""
        
        self.genre1Label.text     = ""
        self.genre1Label.isHidden = false
        self.genre2Label.text     = ""
        self.genre2Label.isHidden = false
        
        self.voteAverageImageView.isHidden = false
        self.voteAverageLabel.isHidden     = false
        self.voteAverageLabel.text         = ""
        
        self.voteCountImageView.isHidden = false
        self.voteCountLabel.isHidden     = false
        self.voteCountLabel.text         = ""
        
    }
    
}
