

import Foundation


class Pokemon: Mappable{
    var id: Int?
    var name: String
    var height: Int?
    var isDefault: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case id
        case name
        case height
    }
}



