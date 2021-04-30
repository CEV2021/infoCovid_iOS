
import UIKit
import CoreLocation
import WidgetKit

class DetalleViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    //OUTLETS
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var listButtonItem: UIBarButtonItem!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var IALabel: UILabel!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var comunityName: UILabel!
    @IBOutlet weak var showListButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    // Constantes para almacenar las clave de UserDefaults
    let kMKeyNotifications = "MY_KEY_NOTIFICATIONS"
    let kMkeyActualLocation = "MY_KEY_ACTUALLOCATION"
    
    var notifications: Bool?
    var actualLocation: Bool?
    var locationIsSelected: Bool = false
    var table: SearchLocationTableViewController?
    var persistence = Persistencia()
    var fromFavoriteLocationList = false
    // Variable para almacenar la localización favorita
    var favoriteLocation = ""
    
    var regionData: Region?
    
    // Constante con la que manejamos los elementos de settings
    let settings = SettingsViewController()
    
    // Constante para el manager del location
    let locationManager = CLLocationManager()
    
    lazy var geocoder = CLGeocoder()
    var actualLocationLongitude: Double = 0.0
    var actualLocationLatitude: Double = 0.0
    var locationSelected: String?
    var name = ""
    var connection = Connection()
    var ia : Double = 0.0
    var updateDate = ""
    var timeToRemember: Double = 3600.0
    var dateNotification = DateComponents()
    
    //variables para el indicador de carga
    var activityIndicator = UIActivityIndicatorView()
    var loadingView = UIView()
    var loadingLabels = UILabel()
    
    //variable reachability para la comprobacion de conexion a internet
    var reachability: Reachability?
    let hostNames = [nil, "google.com"]
    

    override func viewWillAppear(_ animated: Bool) {
     
        favoriteLocation = UserDefaults.standard.string(forKey: "favoriteLocation") ?? "Madrid"//"spain"
        updateCityName()
        
        self.showLoading()
        self.tabBarController?.tabBar.isHidden = false
        
        if fromFavoriteLocationList {
            
            addButton.isHidden = true
            showListButton.isEnabled = false
            listButton.isHidden = true
            
        }else{
            
            addButton.isHidden = false
            showListButton.isEnabled = true
            listButton.isHidden = false
        }
        
        listButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.container.isHidden = false
        self.setupLoadingViews()//se hace la llamada a la funcion de carga
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataStackView.layer.cornerRadius = 20
        dataStackView.layer.borderWidth = 3
        settings.setDefaultValues()
        notifications = UserDefaults.standard.bool(forKey: kMKeyNotifications)
        
        //valores que configuran la hora a la que se muestra la notificacion
        dateNotification.hour = 12
        dateNotification.minute = 00
        
        UNUserNotificationCenter.current().delegate = self
        startHost(at: 0) //Se inicia star host a 0 para la comprobacion de la conexion
        
        //NO HACE FALTA¿?
        /*
         //calculo de incidencia acumulada tomando los datos de la ultima fecha y 14 dias
         ia = ((datos?.data![downloadData].incidentRate) ?? 0) - (datos?.data![downloadData-6].incidentRate ?? 0)
         
         
         totalInfectionsLabel.text = String(format:"%.0f", ia)
         newCasesLabel.text = String(activeCasesNumber)
         recoveredLabel.text = String(recoveredNumber)
         deathsLabel.text = String(deathsNumber)
         totalLabel.text = String(totalNumber)
         lastUpdateLabel.text = "Última actualización: " +
         updateDate
         
         */
        
        //permisos para las notificaciones
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            if granted {
                print("Permiso aceptado")
            }else{
                print("Sin permiso")
                print(error.debugDescription)
            }
        }
        
        //se comprueba la variable ia para que no salten dos notificaciones cuando tome los datos desde la ubicacion
        if ia != 0{
            conditionImageControl()
            listButton.isHidden = false
            hideLoading()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tableController = self.tabBarController!.viewControllers![1] as! IncidenciaViewController
        print(tabBarController?.viewControllers?[1])
        tableController.region = regionData
        print(regionData?.name)
        print("Vista detalle desaparece")
    }
    
    //Funcion que se ocupa del formato de la imagen de cambio de nivel de alarma
    func conditionImageControl(){
        
        if ia > 150{
            conditionImage.image = UIImage.init(named: "coronavirusRojo")
            self.showNotification(text: (self.IALabel.text ?? ""), subtitle: "ALTO")
            
        }else if ia > 50{
            conditionImage.image = UIImage.init(named: "coronavirusAma")
            self.showNotification(text: (self.IALabel.text ?? ""), subtitle: "MEDIO")
            
        }else{
            conditionImage.image = UIImage.init(named: "coronavirusVerde")
            self.showNotification(text: (self.IALabel.text ?? ""), subtitle: "BAJO")
        }
        saveToWidget(name: comunityName.text ?? "Sin datos", incidence: IALabel.text ?? "0", date: lastUpdateLabel.text ?? "Sin datos")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //A traves del centro de notificaciones se le da funcionalidad a los botones de la notificacion
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "rememberAction"{
            dateNotification.hour = 20
            timeToRemember = 10
            conditionImageControl()
        }
        
        else if response.actionIdentifier == "deleteAction" {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["MiNotificacion"])
        }
        completionHandler()
    }
    
    //funcion para mostrar las notificaciones
    func showNotification(text: String, subtitle: String){
        
        if notifications! {
            //trigger para mostrar notificacion a la hora configurada en la variable dateNotification
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateNotification, repeats: false)
            
            //trigger para mostrar notificacion en un tiempo determinado
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeToRemember, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Nivel de alerta actual"
            content.subtitle = subtitle
            content.body = "La incidencia acumulada es: \(text)"
            content.sound = UNNotificationSound.default
            
            //opcion de la notificacion para retrasarla
            let rememberAction = UNNotificationAction(identifier: "rememberAction", title: "Recordar más tarde", options: [])
            //opcion de la notificacion para borrarla
            let deleteAction = UNNotificationAction(identifier: "deleteAction", title: "Eliminar Notificación", options: [])
            let category = UNNotificationCategory(identifier: "alertas", actions: [rememberAction, deleteAction], intentIdentifiers: [], options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([category])
            content.categoryIdentifier = "alertas"
            
            //imagen que se muestra con la notificacion
            if let path = Bundle.main.path(forResource: "Madrid", ofType: "jpg"){
                let url = URL(fileURLWithPath: path)
                
                do{
                    let attachment = try UNNotificationAttachment(identifier: "Madrid", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("no se ha cargado")
                }
            }
            
            let request = UNNotificationRequest(identifier: "MiNotificacion", content: content, trigger: trigger)
            
            //evitamos notificaciones duplicadas
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print(error)
                }
            }
        }
    }
    
    //Funcion para enviar el ReverseRequest
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
                downloadAndSetRegion(name: name)
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
            CheckStatus()
        }else if locationIsSelected {
            comunityName.text = locationSelected
            downloadAndSetRegion(name: locationSelected ?? "Madrid")
            
        }
        else {
            comunityName.text = favoriteLocation
            downloadAndSetRegion(name: comunityName.text ?? "Madrid")
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
    
    //funcion del locationManager que revisa si hay cambios en la autorizacion de permisos
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "SIN PERMISOS DE LOCALIZACIÓN", message: "Por favor, revise los ajustes si desa utilizar su localización como ubicación principal", preferredStyle: .alert)

           let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                self.downloadAndSetRegion(name: self.favoriteLocation)
                }
           }
        let cancelAction = UIAlertAction(title: "Seguir sin permisos", style: .default, handler: {action in
            self.downloadAndSetRegion(name: self.favoriteLocation)
            self.actualLocation = false
            UserDefaults.standard.set(self.actualLocation, forKey: self.kMkeyActualLocation)
            UserDefaults.standard.synchronize()
            self.actualLocation = UserDefaults.standard.bool(forKey: self.kMkeyActualLocation)
        })

        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

    
        if status == .authorizedWhenInUse{
            print("estoy autorizado")
            
        }
        
        if status == .denied{
            print("no estoy autorizado")
            actualLocation = false
            UserDefaults.standard.set(actualLocation, forKey: kMkeyActualLocation)
            UserDefaults.standard.synchronize()
            actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        
        
    }
    
    func saveToWidget(name: String, incidence: String, date: String){
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("name"), let url2 = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("incidence"), let url3 = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jorge.infoCovid")?.appendingPathComponent("date"){
            let data = Data(name .utf8)
            let data2 = Data(incidence .utf8)
            let data3 = Data(date .utf8)
            do {
                try data.write(to: url)
                try data2.write(to: url2)
                try data3.write(to: url3)
            }
            catch {
                print("Error en método saveToWidget")
            }
        }
        else {
            print("Erro en url saveToWidget")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            if let destination = segue.destination as? UbicationsTableViewController{
                var arrayLocations = persistence.RecoverArray()
                for location in arrayLocations {
                    if location == comunityName.text {
                        showAddAlert(title: "Ubicación existente", message: "La localización ya se encuentra en la lista de favoritos")
                        return
                    }
                }
                destination.comunityName = comunityName.text
                print("Desde vista \(destination.locationList.count)")
            }
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // Función para mostrar alert en la app
    func showAddAlert(title: String, message: String) {
        
        // Creamos la alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        // Botones del alert para ejecutar acciones tras su pulsación
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Función para mostrar alert en la app
    func showConnectionAlert(title: String, message: String) {
        
        // Creamos la alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: {action in
            self.viewWillAppear(true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func downloadAndSetRegion(name: String) {
        self.name = name
        if name == "Castilla - La Mancha" {
            self.name = "Castilla%20-%20La%20Mancha"
        }
        if name == "Castilla y Leon" {
            self.name = "Castilla%20y%20Leon"
        }
        if name == "Comunidad Valenciana" || name == "C. Valenciana" {
            self.name = "C.%20Valenciana"
        }
        if name == "Andalucia" {
            self.name = "Andalusia"
        }
        if name == "Pais Vasco" {
            self.name = "Pais%20Vasco"
        }
        // Controlado Cataluña daba error
        if name == "Cataluña" {
            self.name = "Catalonia"
        }
        if name == "España" {
            self.name = "Spain"
        }
        
        connection.getRegionByName(withString: self.name) { [self] (region) in
            if let region = region {
                regionData = region
                
                if region.name == "Andalusia"{
                    region.name = "Andalucia"
                }
                if region.name == "Catalonia"{
                    region.name = "Cataluña"
                }
                if region.name == "Spain"{
                    region.name = "España"
                }
                
                //se rellena la vista con los datos obtenidos desde la localizacion
                DispatchQueue.main.async{
                    
                    var downData = (region.data!.count) - 1
                    updateDate = region.data![downData].date
                    getDateFromString(updateDate: updateDate)
                    self.comunityName.text = region.name
                    self.deathsLabel.text = String( region.data![downData].deaths!)
                    self.recoveredLabel.text = String( region.data![downData].recovered!)
                    self.newCasesLabel.text = String(region.data![downData].active!)
                    self.totalLabel.text = String( region.data![downData].confirmed!)
                    self.IALabel.text = String(format:"%.0f",((region.data![downData].incidentRate) ?? 0) - (region.data![downData-6].incidentRate ?? 0))
                    self.lastUpdateLabel.text = "Última actualización: " +
                        updateDate
                    
                    if fromFavoriteLocationList{
                        listButton.isHidden = true
                        
                    }else{
                        listButton.isHidden = false
                    }
                    
                    self.tabBarController?.tabBar.isHidden = false
                    hideLoading()
                    //se le da valor a la variable para el cambio de alerta
                    self.ia = ((region.data![downData].incidentRate) ?? 0) - (region.data![downData-6].incidentRate ?? 0)
                    
                    //se llama a la funcion de cofiguracion de icono de cambio de alerta
                    self.conditionImageControl()
                    
                    let tableController = self.tabBarController?.viewControllers![1] as! IncidenciaViewController
                    tableController.region = regionData
                }
            }
        }
    }
    
    //configuracion del activity indicator
    func setupLoadingViews(){
        self.container.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 140, width: self.view.frame.width, height: self.view.frame.height - 140)
        self.container.backgroundColor = .systemGray5
        
        //Loading View
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        self.loadingView.center = self.view.center
        self.loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10
        
        //Activity Indicator View
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.center = self.view.center
        self.activityIndicator.color = .white
        self.activityIndicator.startAnimating()
        
        //Label
        self.loadingLabels.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        let center = self.activityIndicator.center
        self.loadingLabels.center = CGPoint(x: center.x, y: center.y + 40)
        self.loadingLabels.textAlignment = .center
        self.loadingLabels.text = "Loading..."
        self.loadingLabels.textColor = .white
    }
    
    //Funcion para mostrar la vista de loading
    func showLoading(){
        self.view.addSubview(self.container)
        self.view.addSubview(self.loadingView)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.loadingLabels)
    }
    
    //funcion para esconder la vista de loading
    func hideLoading(){
        self.loadingLabels.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.loadingView.removeFromSuperview()
        self.container.isHidden = true
    }
    
    //se pasa la fecha de tipo String a tipo date para poder cambiarle el formato de americano a europeo
    func getDateFromString(updateDate: String) -> (date: Date?, conversion: Bool){
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = updateDate.components(separatedBy: "-")
        
        if dateComponentArray.count == 3{
            
            var components = DateComponents()
            components.year = Int(dateComponentArray[0])
            components.month = Int(dateComponentArray[1])
            components.day = Int(dateComponentArray[2]
            )
            
            guard let date = calendar.date(from: components) else{
                return (nil, false)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.updateDate = dateFormatter.string(from: date)
            
            return (date, true)
            
        }else{
            return (nil, false)
        }
    }
    
    //CONFIGURACION DEL REACHABILITY PARA COMPROBAR LA CONEXION A INTERNET DEL DISPOSITIVO
    func startHost(at index: Int){
        reachability?.stopNotifier()
        setupReachability(hostNames[index])
        try? reachability?.startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index+1)%2)
        }
    }
    
    func setupReachability(_ hostName: String?){
        if let hostName = hostName{
            reachability = try? Reachability(hostname: hostName)
        }else{
            reachability = try? Reachability()
        }
        reachability?.whenReachable = {
            reachability in
        }
        reachability?.whenUnreachable = {
            reachability in
            self.showConnectionAlert(title: "Conexión perdida", message: "Vuelve a conectarte y pulsa Aceptar")
        }
    }
    
    //funcion que comprueba el status del request de la peticion de localizacion
    func CheckStatus(){
        
        // configuracion de alert
        let alertController = UIAlertController(title: "SIN PERMISOS DE LOCALIZACIÓN", message: "Por favor, revise los ajustes si desa utilizar su localización como ubicación", preferredStyle: .alert)
        
        //opcion del alert que se ocupa de redirigir al settings del dispositivo
        let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        
        //opcion del alert para continuar con la app sin permisos
        let cancelAction = UIAlertAction(title: "Seguir sin permisos", style: .default, handler: {action in
            self.downloadAndSetRegion(name: self.favoriteLocation)
            self.actualLocation = false
            UserDefaults.standard.set(self.actualLocation, forKey: self.kMkeyActualLocation)
            UserDefaults.standard.synchronize()
            self.actualLocation = UserDefaults.standard.bool(forKey: self.kMkeyActualLocation)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        // check the permission status
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch status {
        
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorize.")
            actualLocation = true
            UserDefaults.standard.set(actualLocation, forKey: kMkeyActualLocation)
            UserDefaults.standard.synchronize()
            actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
            
        case .restricted, .denied:
            print("restricted")
            actualLocation = false
            UserDefaults.standard.set(actualLocation, forKey: kMkeyActualLocation)
            UserDefaults.standard.synchronize()
            actualLocation = UserDefaults.standard.bool(forKey: kMkeyActualLocation)
            self.present(alertController, animated: true, completion: nil)
            
        case .notDetermined:
            print("not")
        // self.present(alertController, animated: true, completion: nil)
        
        }
    }
}









