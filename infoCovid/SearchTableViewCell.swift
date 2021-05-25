
import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var regionImage: UIImageView!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var regionNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
