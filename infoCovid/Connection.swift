import UIKit

class Connection{
    let baseURLString = "https://pokeapi.co/api/v2/"
    
    func getPokemon(withID id: Int, completion: @escaping(_ pokemon: Pokemon?)-> Void){
        guard let url = URL(string: "\(baseURLString)pokemon/\(id)")else{
            completion(nil)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error == nil, let data = data{
                let pokemon = Pokemon(withJSONData: data)
                completion(pokemon)
                
            }else{
                completion(nil)
            }
            
        }
        task.resume()
    }
}

