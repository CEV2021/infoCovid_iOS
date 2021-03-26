// Cambio realizado por Dani

import UIKit
import CoreLocation

class DetalleViewController: UIViewController, CLLocationManagerDelegate {
    
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
    
    // Constante con la que manejamos los elementos de settings
    let settings = SettingsViewController()
    
    // Constante para el manager del location
    let locationManager = CLLocationManager()
    
    lazy var geocoder = CLGeocoder()
    var actualLocationLongitude: Double = 0.0
    var actualLocationLatitude: Double = 0.0
    
    
    var infectionsNumber : Int! = 3
    var locationSelected: String?
    
    override func viewWillAppear(_ animated: Bool) {
        updateCityName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.setDefaultValues()
        totalInfectionsLabel.text = String(infectionsNumber)
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
        conditionImageControl()
        
    }
    
    
    
    func conditionImageControl(){
        
        if infectionsNumber > 500{
            conditionImage.image = UIImage.init(named: "coronavirusRojo")
            self.showNotification(text: (self.totalInfectionsLabel.text ?? ""), subtitle: "ALTO")
            
            
            
        }else if infectionsNumber > 400{
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
                print(placemark)
                comunityName.text = placemark.locality
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
            comunityName.text = "Favorita"
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
}




