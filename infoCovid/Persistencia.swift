

import Foundation


class Persistencia {
    
//
//    //Con esta funcion parseamos un objeto a JSON y guardamos en persistencia
//    func SaveObject(objeto: Agentes) {
//
//        //Lo encapsulamos por si da error
//        do {
//            //Creamos objeto Encoder
//            let encoder = JSONEncoder()
//
//            //Le indicamos el tipo de formateado
//            encoder.outputFormatting = .prettyPrinted
//
//            //Creamos objeto data con el objeto a traves del json encoder
//            let data = try encoder.encode(objeto)
//
//            //Creamos objeto JSON parseando variable data
//            let json = String(data: data, encoding: .utf8)
//            // Mediante UserDefaults se guarda el array en persistencia con la clave "Agentes"
//            UserDefaults.standard.setValue(json, forKey: "Agentes")
//        } catch {
//            print("No se ha podido parsear")
//        }
//    }
//
//
//
//    //Con esta funcion podemos parsear Objeto Agentes a traves de un JSON
//    func RecoverObject() -> Agentes {
//
//
//        //Creamos objeto json que almacenara los datos que obtenemos desde userdefautls y la clave "Agentes"
//        if let json = UserDefaults.standard.value(forKey: "Agentes") as? String {
//
//            //Creamos objeto decoder
//            let decoder = JSONDecoder()
//
//            //Creamos variable data con el JSON extraido de las userdefaults
//            let data = json.data(using: .utf8) ?? nil
//
//            do {
//                //Creamos un Objeto con la variable data gracias al objeto decoder
//                let array = try decoder.decode(Agentes.self, from: data!)
//
//                //retornamos el array
//                return array
//            }catch{
//                //Hubo problema, no se pudo parsear
//                print("Imposible parsear")
//            }
//        }
//        //Si no entramos al If, no hemos podido acceder a las persistencias, lo devolvemos vacio
//        return Agentes()
//    }
//
//
//
    //ESTAS DOS FUNCIONES SIGUIENTES SERIAN PARA UN ARRAY

    //Con esta funcion guardamos los datos en persistencia a traves de un Objeto a JSON
    func SaveArray(array : Array<String>) {
        do {
            //Creamos Objeto Encoder
            let encoder = JSONEncoder()

            //Le indicamos opcion de Formateo
            encoder.outputFormatting = .prettyPrinted

            //Creamos objeto data con el array a traves del objeto encoder
            let data = try encoder.encode(array)

            //Creamos Objeto JSON Parseando variable data
            let json = String(data: data, encoding: .utf8)

            //Guardamos el JSON para recuperarlo en cualquier otra vista
            UserDefaults.standard.setValue(json, forKey: "Array")
        }catch {
            print("Error en el parseo del array")
        }
    }

    
    
    //Con esta funcion recuperamos los datos de las UserDefaults
    func RecoverArray() -> Array<String>{
        
        //Creamos objeto JSON que almacenara los datos guardados en UserDefaults
        if let json = UserDefaults.standard.value(forKey: "Array") as? String {
            
            //Creamos objeto decoder
            let decoder = JSONDecoder()
            
            //Creamos variable Data con el JSON extraido de las UserDefaults
            let data = json.data(using: .utf8) ?? nil
            
            do {
                //Creamos array con la variable data gracias al objeto decoder (Indicamos tipo de objeto para parseo)
                let array = try decoder.decode([String].self, from: data!)
                
                //Devolvemos el Objeto
                return array
            }catch{}
        }
        
        //En caso de que hay algun error, devolvemos uno vacio
        print("Error en persistencia recuperación de array")
        return []
    }
    
    
}

