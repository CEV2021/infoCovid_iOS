
import UIKit
import UserNotifications

class SettingsViewController: UIViewController{
    
    //OUTLETS
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var actualLocationSwitch: UISwitch!
    
    var notifications: Bool?
    var actualLocation: Bool?
    var notificationSettings: Bool?
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
        notificationSettings = UserDefaults.standard.bool(forKey: "notificationSettings")
        notificationsSwitch.setOn(notifications!, animated: true)
        actualLocationSwitch.setOn(actualLocation!, animated: true)
        print(notificationSettings)
        
        if fromDetail {
            
            self.tabBarController?.tabBar.isHidden = true
        }
        
        detectNotificationPermission()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewWillAppear(true)
        
    }
    
    @IBAction func notificationsAction(_ sender: UISwitch) {
        notifications!.toggle()
        if notificationSettings == false{
            print("no no")
            notifications = false
            // Función para mostrar alert en la app
            showAddAlert(title: "SIN PERMISOS DE NOTIFICACIONES", message: "Por favor, habilita los permisos del dispositivo para poder recibir notificaciones")
            viewWillAppear(true)
        }
        UserDefaults.standard.set(notifications, forKey: kMyKeyNotifications)
        UserDefaults.standard.synchronize()
        notifications = UserDefaults.standard.bool(forKey: kMyKeyNotifications)
        viewWillAppear(true)
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
        
        notifications = UserDefaults.standard.bool(forKey: kMyKeyNotifications)
        actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
        UserDefaults.standard.synchronize()
       
    }
    
    func showAddAlert(title: String, message: String) {
        
        // Creamos la alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        // Botones del alert para ejecutar acciones tras su pulsación
        let ok = UIAlertAction(title: "Seguir sin permisos", style: .default)
        let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                self.notificationSettings = true
            }
        }
        alert.addAction(ok)
        alert.addAction(settingsAction)
        
        let sub = (alert.view.subviews.first?.subviews.first!)! as UIView
        sub.layer.cornerRadius = 15
        sub.layer.shadowColor = UIColor.black.cgColor
        sub.layer.shadowOpacity = 1
        sub.layer.shadowOffset = CGSize(width: 8, height: 0)
        sub.layer.borderWidth = 4
        sub.layer.borderColor = #colorLiteral(red: 0.2235294118, green: 0.3137254902, blue: 0.3764705882, alpha: 1)
        present(alert, animated: true, completion: nil)
        
    }
    
    //detectar el cambio en los permisos de notificaciones desde ajustes del dispositivo
    func detectNotificationPermission(){
    
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if (settings.authorizationStatus == .authorized){
                
                print("Permiso aceptado")
                self.notifications = true
                self.notificationSettings = true
                UserDefaults.standard.set(self.notificationSettings, forKey: "notificationSettings")
                UserDefaults.standard.set(self.notifications, forKey: self.kMyKeyNotifications)
                
                self.notifications = UserDefaults.standard.bool(forKey: self.kMyKeyNotifications)
                
            }else{
                print("Sin permiso")
                self.notifications = false
                self.notificationSettings = false
                UserDefaults.standard.set(self.notificationSettings, forKey: "notificationSettings")
                UserDefaults.standard.set(self.notifications, forKey: self.kMyKeyNotifications)
               
                self.notifications = UserDefaults.standard.bool(forKey: self.kMyKeyNotifications)
            }
        }
    }
}



