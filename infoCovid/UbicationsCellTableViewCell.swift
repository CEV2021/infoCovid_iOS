//
//  UbicationsCellTableViewCell.swift
//  infoCovid
//
//  Created by daniel on 21/04/2021.
//

import UIKit

class UbicationsCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var heartButton: UIButton!
    var heartFill = false
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        if !heartFill {
            heartButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)

        }
        else {
            heartButton.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)

        }
        heartFill.toggle()
       
    }

}
