
import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel:       UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.personImageView.layer.masksToBounds = true
        self.personImageView.layer.cornerRadius  = self.personImageView.frame.width / 2
    }
    
}
