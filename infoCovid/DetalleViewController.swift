// Cambio realizado por Dani

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var totalInfectionsLabel: UILabel!
    @IBOutlet weak var sevenDaysView: UIStackView!
    @IBOutlet weak var conditionImage: UIImageView!
    
    var infectionsNumber : Int = 800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

