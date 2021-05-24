
import UIKit

class SettingsViewController: UIViewController{
    
    //OUTLETS
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var actualLocationSwitch: UISwitch!
    
    var notifications: Bool?
    var actualLocation: Bool?
    var settings: SettingsViewController!
    var fromDetail = false
    // Constantes para almacenar las clave de UserDefaults
    let kMyKeyNotifications = "MY_KEY_NOTIFICATIONS"
    let kMkeyActualLocation = "MY_KEY_ACTUALLOCATION"
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.synchronize()
        self.tabBarController?.tabBar.isHidden = false
        setDefaultValues()
        // Obtenemos el estado de las notificaciones y de la localización actual del almacenamiento interno
        notifications = UserDefaults.standard.bool(forKey: kMyKeyNotifications)
        actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
        notificationsSwitch.setOn(notifications!, animated: true)
        actualLocationSwitch.setOn(actualLocation!, animated: true)
        
        if fromDetail {
          
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewWillAppear(true)
 
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
    
    @IBAction func web01Button(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func web02Button(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func web03Button(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func web04Button(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /* Función con la que damos el valor true por defecto
     al booleano del almacenamiento interno, ya que de no haber nada
     en el almacenamiento, la variable se pone a false */
    func setDefaultValues() {
        let userDefaults = UserDefaults.standard
        let appDefaults: [String:Any] = [ kMyKeyNotifications : true,
                                          kMkeyActualLocation: true]
        userDefaults.register(defaults: appDefaults)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.synchronize()
    }
}


