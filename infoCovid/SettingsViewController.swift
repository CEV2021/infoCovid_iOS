
import UIKit

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBAction func notificationsAction(_ sender: Any) {
        
        if notificationsSwitch.isOn{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                if granted {
                    print("Permiso aceptado")
                }else{
                    print("Sin permiso")
                    print(error.debugDescription)
                }
            }
            
            
        }else{
            UNUserNotificationCenter.cancelPreviousPerformRequests(withTarget: (Any).self)
        }
        
    }
    

}
