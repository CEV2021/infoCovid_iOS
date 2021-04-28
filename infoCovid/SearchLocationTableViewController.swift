

import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
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
        
        
        self.setupLoadingViews()//se hace la llamada a la funcion de carga
        self.showLoading()
        
        //Connection para recibir la lista de regiones
        connection.getRegions { (regions) in
            if let regions = regions {
                self.regions = regions

                DispatchQueue.main.async{
                    /*
                    //calculo para llenar la progressBar
                    self.progressBar.setProgress(Float(regions.capacity + regions.capacity - regions.capacity) / Float(regions.capacity), animated: true)
                    */
                    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let region = filteredData[indexPath.row]
        if region?.name == "Andalusia"{
            region?.name = "Andalucia"
        }
        if region?.name == "Catalonia"{
            region?.name = "Cataluña"
        }
        if region?.name == "Spain"{
            region?.name = "España"
        }
        cell.textLabel?.text = region?.name ?? ""
        downloadDataNumber = (region?.data!.count)!
            - 1
      
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
       
            filteredData = regions.filter({ region -> Bool in
                guard let text = searchController.searchBar.text else { return false }
                return
                    region!.name!.lowercased().contains(text.lowercased())
            }).sorted { $0!.name! < $1!.name! }
        
        tableView.reloadData()
    }
    
   
    //Funcion para pasar los datos a las vistas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let region = filteredData[indexPath!.row]
        
        nextViewController.infectionsNumber = region?.data?[downloadDataNumber].incidentRate
        nextViewController.deathsNumber = region?.data?[downloadDataNumber].deaths
        nextViewController.recoveredNumber = region?.data?[downloadDataNumber].recovered
        nextViewController.locationSelected = region?.name
        nextViewController.totalNumber = region?.data?[downloadDataNumber].confirmed
        nextViewController.locationIsSelected = true
        nextViewController.datos = region
        nextViewController.downloadData = downloadDataNumber
        nextViewController.activeCasesNumber = region?.data?[downloadDataNumber].active
        nextViewController.updateDate = (region?.data?[downloadDataNumber].date)!
        
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
        //self.container.removeFromSuperview()
    }
}

