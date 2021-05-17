

import UIKit

class UbicationsTableViewController: UITableViewController {
    
    @IBOutlet weak var labelName: UILabel!
    
    var locationList: [String] = []
    var persistance = Persistencia()
    var comunityName: String?
    var arrayButton: [UIButton] = []
    let configuration = UIImage.SymbolConfiguration(scale: .large)
    var index = UserDefaults.standard.integer(forKey: "index")
    var favoriteTouch = UserDefaults.standard.bool(forKey: "favoriteTouch")
    
    
    override func viewWillDisappear(_ animated: Bool) {
        persistance.SaveArray(array: locationList)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = editButtonItem
        locationList = persistance.RecoverArray()
        if let name = comunityName {
            locationList.append(name)
           // tableView.reloadData()

        }
        // Si los datos del almacenamiento interno no son nulos, seteamos el nombre del label con ellos
        if let location = UserDefaults.standard.string(forKey: "favoriteLocation"){
            labelName.text = location
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! UbicationsCellTableViewCell
        let ubication = locationList[indexPath.row]
        cell.textLabel?.text = ubication
        // Agregamos botón al array de botones
        arrayButton.append(cell.heartButton)
        // Asignamos action al botón mediante el target
        cell.heartButton.addTarget(self, action: #selector(changeButton), for: .touchUpInside)
        // Si el indexpath de la celda coincide con el index guardado en UserDefaults quiere decir que ese es el último que se seleccionó
        // por lo que lo seteamos con la imagen del corazón relleno
 
        if indexPath.row == index, favoriteTouch {
            cell.heartButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let location = locationList[indexPath!.row]
        
        nextViewController.locationSelected = location
        nextViewController.locationIsSelected = true
        nextViewController.fromFavoriteLocationList = true
    }
    
    //Funcion para borrar las ubicaciones de la tabla, ya sea desde el modo edicion o arrastrando a la izquierda
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Si la celda en la que pulsamos es igual al index con el corazón relleno y favoriteTouch es true
            if indexPath.row == index, favoriteTouch{
                print("Borramos la favorita")
                //Hemos borrado la ubicación favorita por lo que favoriteTouch es = false
                favoriteTouch = false
                // Seteamos el label con la ubicación de España por defecto
                labelName.text = "España"
                // Guardamos tanto el label como el favoriteTouch
                UserDefaults.standard.set(labelName.text, forKey: "favoriteLocation")
                UserDefaults.standard.set(favoriteTouch, forKey: "favoriteTouch")
            }
            // Delete the row from the data source
            locationList.remove(at: indexPath.row)
            arrayButton.remove(at: indexPath.row)
            if indexPath.row < index, index > 0{
                index -= 1
                print("Resto")
                UserDefaults.standard.set(index, forKey: "index")
            }
            print("Esto es el index \(index)")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadData()
            
            if locationList.count == 0{
                labelName.text = "España"
                favoriteTouch = false
                UserDefaults.standard.set(favoriteTouch, forKey: "favoriteTouch")
                // Guardamos tanto el nombre del favorito como el index en el almacenamiento interno
                UserDefaults.standard.set(labelName.text, forKey: "favoriteLocation")
                UserDefaults.standard.synchronize()
                
            }
            
        } else if editingStyle == .insert {
        }
    }
    
    //Funcion que permite reordenar las posiciones de la tabla desde el modo editar
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let locationMove = locationList[fromIndexPath.row]
        let arrayButtonMove = arrayButton[fromIndexPath.row]
        locationList.remove(at: fromIndexPath.row)
        arrayButton.remove(at: fromIndexPath.row)
        
        locationList.insert(locationMove, at: to.row)
        arrayButton.insert(arrayButtonMove, at: to.row)
        
        // Manejamos si movemos la favorita
        if fromIndexPath.row == index {
            print("Estamos moviendo la favorita")
            index = to.row
            UserDefaults.standard.set(index, forKey: "index")
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func prueba(){
        print("\(arrayButton.count) Desde prueba")
    }
    
    /*
     Función que maneja el botón de la celda
     Al crear la celda hemos ido metiendo los botones en un array, por lo que al pulsar uno de los botones:
     */
    @objc func changeButton(sender: UIButton){
        // Recorremos el array
        for button in arrayButton {
            // Seteamos todos los botones con el corazón vacío
            button.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
        }
        // Seteamos el pulsado con el corazón lleno
        sender.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
        
        // Variable index a partir de la posición del sender en el array
         index = arrayButton.firstIndex(of: sender)!
        UserDefaults.standard.set(index, forKey: "index")
        favoriteTouch = true
       
        // Seteamos el label con la localización que corresponda a la variable index que hemos creado
        labelName.text = locationList[index]
        // Guardamos tanto el nombre del favorito como el index en el almacenamiento interno
        UserDefaults.standard.set(labelName.text, forKey: "favoriteLocation")
        UserDefaults.standard.set(favoriteTouch, forKey: "favoriteTouch")
        UserDefaults.standard.synchronize()
    }
}
