
import UIKit

class SettingsViewController: UIViewController{
    
    var notifications: Bool?
    
    // Constante para almacenar la clave de UserDefaults
    let kMyKey = "MY_KEY"
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDefaultValues()
        // Obtenemos el estado de las notificaciones del almacenamiento interno
        notifications = UserDefaults.standard.bool(forKey: kMyKey)
        notificationsSwitch.setOn(notifications!, animated: true)
        
        
    }
    @IBAction func notificationsAction(_ sender: Any) {
        notifications!.toggle()
        UserDefaults.standard.set(notifications, forKey: kMyKey)
        UserDefaults.standard.synchronize()
        notifications = UserDefaults.standard.bool(forKey: kMyKey)
        print(notifications!)
        
    }
    @IBAction func deleteData(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: kMyKey)
        UserDefaults.standard.synchronize()
        print("Desde almacenamiento interno dato: \(UserDefaults.standard.bool(forKey: kMyKey))")
    }
    
    /* Función con la que damos el valor true por defecto
     al booleano del almacenamiento interno, ya que de no haber nada
     en el almacenamiento, la variable se pone a false */
    
    func setDefaultValues() {
        let userDefaults = UserDefaults.standard
        let appDefaults: [String:Any] = [ kMyKey : true]
        userDefaults.register(defaults: appDefaults)
    }
}


