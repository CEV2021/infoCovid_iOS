
import UIKit

class SettingsViewController: UIViewController{
    
    var notifications: Bool?
    var actualLocation: Bool?
    
    // Constantes para almacenar las clave de UserDefaults
    let kMyKeyNotifications = "MY_KEY_NOTIFICATIONS"
    let kMkeyActualLocation = "MY_KEY_ACTUALLOCATION"
    
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var actualLocationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDefaultValues()
        // Obtenemos el estado de las notificaciones y de la localización actual del almacenamiento interno
        notifications = UserDefaults.standard.bool(forKey: kMyKeyNotifications)
        actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
        notificationsSwitch.setOn(notifications!, animated: true)
        actualLocationSwitch.setOn(actualLocation!, animated: true)
        
        
    }
    @IBAction func notificationsAction(_ sender: UISwitch) {
        notifications!.toggle()
        UserDefaults.standard.set(notifications, forKey: kMyKeyNotifications)
        UserDefaults.standard.synchronize()
        notifications = UserDefaults.standard.bool(forKey: kMyKeyNotifications)
    
        
    }

    @IBAction func actualLocationAction(_ sender: UISwitch) {
        actualLocation!.toggle()
        UserDefaults.standard.set(actualLocation, forKey: kMkeyActualLocation)
        UserDefaults.standard.synchronize()
        actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
        
    }
    
   /*
    @IBAction func deleteData(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "MY_KEY_NOTIFICATIONS")
        UserDefaults.standard.removeObject(forKey: "MY_KEY_ACTUALLOCATION")
    }
    */
    
    /* Función con la que damos el valor true por defecto
     al booleano del almacenamiento interno, ya que de no haber nada
     en el almacenamiento, la variable se pone a false */
    
    func setDefaultValues() {
        let userDefaults = UserDefaults.standard
        let appDefaults: [String:Any] = [ kMyKeyNotifications : true,
                                          kMkeyActualLocation: true]
        userDefaults.register(defaults: appDefaults)
    }
}


