import UIKit

class Connection{
    let baseURLString = "https://limitless-meadow-81250.herokuapp.com/api/regions"
    
    
    func getRegions(completion: @escaping(_ region: [Region?]?)-> Void){
        guard let url = URL(string: baseURLString)else{
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
        guard let url = URL(string: baseURLString)else{
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
    
    func getRegionByName(withString name: String, completion: @escaping(_ region: Region?)-> Void){
        guard let url = URL(string: "\(baseURLString)/\(name)")else{
            completion(nil)
            print("Error en url")
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error == nil, let data = data{
                let region = Region(withJSONData: data)
                completion(region)
                
            }else{
                completion(nil)
                print("No llegan datos")
            }
            
        }
        task.resume()
    }
}

