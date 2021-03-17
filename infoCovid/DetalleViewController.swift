// Cambio realizado por Dani

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var totalInfectionsLabel: UILabel!
    @IBOutlet weak var sevenDaysView: UIStackView!
    @IBOutlet weak var conditionImage: UIImageView!
    
    var infectionsNumber : Int = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sevenDaysView.layer.cornerRadius = 20
        sevenDaysView.layer.borderWidth = 3
        
        conditionImageControl()
        
    }
    
    func conditionImageControl(){
        
        if infectionsNumber > 800{
            conditionImage.image = UIImage.init(named: "coronavirusRojo")
        }else if infectionsNumber > 400{
            conditionImage.image = UIImage.init(named: "coronavirusAma")
        }else{
            conditionImage.image = UIImage.init(named: "coronavirusVerde")
        }
        
    }


}

