import UIKit

class Connection{
    let baseURLString = "https://pokeapi.co/api/v2/"
    let baseURLString2 = "https://limitless-meadow-81250.herokuapp.com/api/regions"
    
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
    
    func getRegions( TotalRegions regions: Int, completion: @escaping(_ region: [Region?]?)-> Void){
        guard let url = URL(string: "\(baseURLString2)?count=\(regions)")else{
            completion(nil)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error == nil, let data = data{
                let region = try? JSONDecoder().decode([Region].self, from: data)
                completion(region)
                
            }else{
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    func getRegion( completion: @escaping(_ region: [Region?]?)-> Void){
        guard let url = URL(string: baseURLString2)else{
            completion(nil)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error == nil, let data = data{
                let region = try? JSONDecoder().decode([Region].self, from: data)
                completion(region)
                
            }else{
                completion(nil)
            }
            
        }
        task.resume()
    }
}

