
import UIKit

class UbicationsCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var heartButton: UIButton!
    
    var heartFill = false
    var arrView:[UIButton] = []
    var ubicationsTable = UbicationsTableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
    }
}


