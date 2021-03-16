

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sevenDaysView: UIView!
    @IBOutlet weak var conditionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sevenDaysView.layer.cornerRadius = 20
        sevenDaysView.layer.borderWidth = 3
    }


}

