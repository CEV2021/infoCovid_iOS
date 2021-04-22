

import UIKit
import CoreLocation

class DetalleViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var totalInfectionsLabel: UILabel!
    @IBOutlet weak var sevenDaysView: UIStackView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var comunityName: UILabel!
    
    let kMKeyNotifications = "MY_KEY_NOTIFICATIONS"
    let kMkeyActualLocation = "MY_KEY_ACTUALLOCATION"
    var notifications: Bool?
    var actualLocation: Bool?
    var locationIsSelected: Bool = false
    var tabla : SearchLocationTableViewController?
    var persistencia = Persistencia()
    
    var datos: Region?//prueba recibiendo los datos completos de la seleccion
    
    // Constante con la que manejamos los elementos de settings
    let settings = SettingsViewController()
    
    // Constante para el manager del location
    let locationManager = CLLocationManager()
    
    lazy var geocoder = CLGeocoder()
    var actualLocationLongitude: Double = 0.0
    var actualLocationLatitude: Double = 0.0
    
    
    var infectionsNumber : Double! = 0.0
    var deathsNumber: Int! = 0
    var recoveredNumber: Int! = 0
    var locationSelected: String?
    var totalNumber: Int! = 0
    var activeCasesNumber: Int! = 0
    var name = "Andalusia"
    var connection = Connection()
    var downloadData = 0
    var ia : Double = 0.0
    var updateDate = ""

    
    
    override func viewWillAppear(_ animated: Bool) {
        updateCityName()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(downloadData-1)
        //Se calculan los nuevos casos
        //newCasesNumber = ((datos?.data![downloadData].confirmed) ?? 0) - (datos?.data![downloadData-1].confirmed ?? 0)
        
        //calculo de incidencia acumulada tomando los datos de la ultima fecha y 14 dias
        ia = ((datos?.data![downloadData].incidentRate) ?? 0) - (datos?.data![downloadData-7].incidentRate ?? 0)
        
        settings.setDefaultValues()
        totalInfectionsLabel.text = String(format:"%.0f", ia)
        newCasesLabel.text = String(activeCasesNumber)
        recoveredLabel.text = String(recoveredNumber)
        deathsLabel.text = String(deathsNumber)
        totalLabel.text = String(totalNumber)
        lastUpdateLabel.text = "Última actualización: " +
            updateDate
        notifications = UserDefaults.standard.bool(forKey: kMKeyNotifications)
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if granted {
                print("Permiso aceptado")
            }else{
                print("Sin permiso")
                print(error.debugDescription)
            }
        }
        
        sevenDaysView.layer.cornerRadius = 20
        sevenDaysView.layer.borderWidth = 3
        
        //se comprueba la variable ia para que no salten dos notificaciones cuando tome los datos desde la ubicacion
        if ia != 0{
        conditionImageControl()
        }
        
    }

    //Funcion que se ocupa del formato de la imagen de cambio de nivel de alarma
    func conditionImageControl(){
        
        if ia > 150{
            conditionImage.image = UIImage.init(named: "coronavirusRojo")
            self.showNotification(text: (self.totalInfectionsLabel.text ?? ""), subtitle: "ALTO")
     
        }else if ia > 50{
            conditionImage.image = UIImage.init(named: "coronavirusAma")
            self.showNotification(text: (self.totalInfectionsLabel.text ?? ""), subtitle: "MEDIO")
            
        }else{
            conditionImage.image = UIImage.init(named: "coronavirusVerde")
            self.showNotification(text: (self.totalInfectionsLabel.text ?? ""), subtitle: "BAJO")
        }
    }
    
    // se crea la funcion para las notificaciones
    func showNotification(text: String, subtitle: String){
        if notifications! {
            let content = UNMutableNotificationContent()
            content.title = "Nivel de alerta actual"
            content.subtitle = subtitle
            content.body = "La incidencia es de: \(text) contagios"
            content.sound = .default
            content.badge = 1
            //se crea el trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            //Creamos la request y añadidos el content del trigger
            let request = UNNotificationRequest(identifier: "Mi Notificacion", content: content, trigger: trigger)
            //añadimos la notificacion al centro de notificaciones
            UNUserNotificationCenter.current().add(request) { (error) in
                
                print (error.debugDescription)
            }
        }
    }
    
    func sendReverseRequest() {
        let location = CLLocation(latitude: actualLocationLatitude, longitude: actualLocationLongitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error)  in
            self.processReverseGeocoder(withPlacemarks: placemarks, error: error)
        }
    }
    
    /*
     Función para procesar la respuesta del reverse
     */
    func processReverseGeocoder(withPlacemarks placermarks: [CLPlacemark]?, error: Error?){
        if let error = error {
            comunityName.text = "Error en localización"
        }else {
            if let placemarks = placermarks, let placemark = placermarks?.first {
                name = placemark.administrativeArea!
                connection.getRegionByName(withString: name) { (region) in
                    if let region = region {
                        if region.name == "Andalusia"{
                            region.name = "Andalucia"
                        }
                        
                        //se rellena la vista con los datos obtenidos desde la localizacion
                        DispatchQueue.main.async{
                            var downData = (region.data!.count) - 1
                            self.comunityName.text = region.name
                            self.deathsLabel.text = String( region.data![downData].deaths!)
                            self.recoveredLabel.text = String( region.data![downData].recovered!)
                            self.newCasesLabel.text = String(region.data![downData].active!)
                            self.totalLabel.text = String( region.data![downData].confirmed!)
                            self.totalInfectionsLabel.text = String(format:"%.0f",((region.data![downData].incidentRate) ?? 0) - (region.data![downData-7].incidentRate ?? 0))
                            self.lastUpdateLabel.text = "Última actualización: " +
                                region.data![downData].date!
                            
                            //se le da valor a la variable para el cambio de alerta
                            self.ia = ((region.data![downData].incidentRate) ?? 0) - (region.data![downData-7].incidentRate ?? 0)
                            
                            //se llama a la funcion de cofiguracion de icono de cambio de alerta 
                            self.conditionImageControl()
                        }
                    }
                }

            }else {
                comunityName.text = "Error"
            }
        }
    }
    
    func updateCityName(){
        actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
        if actualLocation! && !(locationIsSelected) {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }else if locationIsSelected {
            comunityName.text = locationSelected
        }
        else {
            comunityName.text = name
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location enabled")
        
        if let location = locations.first {
            actualLocationLatitude = location.coordinate.latitude
            actualLocationLongitude = location.coordinate.longitude
            sendReverseRequest()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    @IBAction func addButton(_ sender: Any) {
        
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UbicationsTableViewController{
            var arrayLocations = persistencia.RecoverArray()
            for location in arrayLocations {
                if location == comunityName.text {
                    mostrarAlert(title: "Ubicación existente", message: "La localización ya se encuentra en la lista de favoritos")
                    return
                }
            }
            destination.comunityName = comunityName.text
            print("Desde vista \(destination.locationList.count)")
        }
    }
    
    
    // Función para mostrar alert en la app
    func mostrarAlert(title: String, message: String) {
        
        // Creamos la alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        // Botones del alert para ejecutar acciones tras su pulsación
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
}




