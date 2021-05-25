

import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    //OUTLETS
    @IBOutlet weak var imageCity: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var regions: [Region?] = []
    var connection = Connection()
    var filteredData : [Region?] = []
    var downloadDataNumber = 0
    
    //variables para el indicador de carga
    var activityIndicator = UIActivityIndicatorView()
    var loadingView = UIView()
    var loadingLabels = UILabel()
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //se iguala filter data a regions para poder mostrar los resultados en la nusqueda por filtrado
        filteredData = regions
        
        self.setupLoadingViews()
        self.showLoading()
        
        //Connection para recibir la lista de regiones
        connection.getRegions { (regions) in
            if let regions = regions {
                self.regions = regions
                
                DispatchQueue.main.async{
                    
                    if regions.count == 20{
                        self.setupSearch()
                        self.hideLoading()
                        self.imageCity.isHidden = false
                        
                    }
                }
            }
        }
    }
    
    //Configuracion de la barra de busqueda
    func setupSearch(){
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Introduce ubicación"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        let region = filteredData[indexPath.row]
        if region?.name == "Andalusia"{
            region?.name = "Andalucía"
        }
        if region?.name == "Aragon"{
            region?.name = "Aragón"
        }
        if region?.name == "Catalonia"{
            region?.name = "Cataluña"
        }
        if region?.name == "Pais Vasco"{
            region?.name = "País Vasco"
        }
        if region?.name == "Castilla y Leon"{
            region?.name = "Castilla y León"
        }
        if region?.name == "Spain"{
            region?.name = "España"
        }
        
        cell.regionNameLabel.text = region?.name ?? ""
        downloadDataNumber = (region?.data!.count)!
            - 1
        
        //Condiciones para setear las imagenes segun su región correspondiente
        switch cell.regionNameLabel.text  {
        
        case "Madrid":
            cell.regionImage.image = #imageLiteral(resourceName: "C.Madrid")
            
        case "Andalucía":
            cell.regionImage.image = #imageLiteral(resourceName: "andalucia")
            
        case "Galicia":
            cell.regionImage.image = #imageLiteral(resourceName: "galicia")
            
        case "C. Valenciana":
            cell.regionImage.image = #imageLiteral(resourceName: "valenciana")
            
        case "Aragón":
            cell.regionImage.image = #imageLiteral(resourceName: "aragon")
            
        case "Castilla y León":
            cell.regionImage.image = #imageLiteral(resourceName: "c.leon")
            
        case "Castilla - La Mancha":
            cell.regionImage.image = #imageLiteral(resourceName: "cm")
            
        case "Asturias":
            cell.regionImage.image = #imageLiteral(resourceName: "asturias")
            
        case "Canarias":
            cell.regionImage.image = #imageLiteral(resourceName: "canarias")
            
        case "Cantabria":
            cell.regionImage.image = #imageLiteral(resourceName: "cantabria")
            
        case "Baleares":
            cell.regionImage.image = #imageLiteral(resourceName: "baleares")
            
        case "Ceuta":
            cell.regionImage.image = #imageLiteral(resourceName: "ceuta")
            
        case "Melilla":
            cell.regionImage.image = #imageLiteral(resourceName: "melilla")
            
        case "Extremadura":
            cell.regionImage.image = #imageLiteral(resourceName: "extremadura")
            
        case "País Vasco":
            cell.regionImage.image = #imageLiteral(resourceName: "pais vasco")
            
        case "La Rioja":
            cell.regionImage.image = #imageLiteral(resourceName: "rioja")
            
        case "Murcia":
            cell.regionImage.image = #imageLiteral(resourceName: "murcia")
            
        case "Cataluña":
            cell.regionImage.image = #imageLiteral(resourceName: "cat")
            
        case "Navarra":
            cell.regionImage.image = #imageLiteral(resourceName: "navarra")
            
        case "España":
            cell.regionImage.image = #imageLiteral(resourceName: "españa")
            
        default:
            print("sin regiones")
        }
        
        cell.regionImage.layer.cornerRadius = 40
        cell.container.layer.cornerRadius = 40
        cell.container.layer.borderWidth = 4
        cell.container.layer.borderColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredData = regions.filter({ region -> Bool in
            guard let text = searchController.searchBar.text else { return false }
            return
                region!.name!.lowercased().contains(text.lowercased())
        })//.sorted { $0!.name! < $1!.name! }
        
        tableView.reloadData()
    }
    
    //Funcion para pasar los datos a las vistas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let region = filteredData[indexPath!.row]
        
        nextViewController.locationSelected = region?.name
        nextViewController.locationIsSelected = true
        nextViewController.regionData = region
        nextViewController.updateDate = (region?.data?[downloadDataNumber].date)!
        nextViewController.fromSeach = true
        
    }
    
    //configuracion del activity indicator
    func setupLoadingViews(){
        self.container.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 140, width: self.view.frame.width, height: self.view.frame.height - 140)
        self.container.backgroundColor = .systemGray5
        
        //Loading View
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        self.loadingView.center = self.view.center
        self.loadingView.backgroundColor = #colorLiteral(red: 0.2250583768, green: 0.3118225634, blue: 0.387561202, alpha: 1)
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10
        self.loadingView.layer.borderColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.loadingView.layer.borderWidth = 4
        
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
        self.loadingLabels.text = "Cargando..."
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
        //self.container.removeFromSuperview()
    }
}

