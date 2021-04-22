

import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    var regions: [Region?] = []
    var connection = Connection()
    var filteredData : [Region?] = []
    var downloadDataNumber = 0
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //se iguala filter data a regions para poder mostrar los resultados en la nusqueda por filtrado
        filteredData = regions
      
        //Connection para recibir la lista de regiones
        connection.getRegions { (regions) in
            if let regions = regions {
                self.regions = regions
                
                
                DispatchQueue.main.async{
                    //calculo para llenar la progressBar
                    self.progressBar.setProgress(Float(regions.capacity + regions.capacity - regions.capacity) / Float(regions.capacity), animated: true)
                    
                    if self.progressBar.progress == 1{
                        self.setupSearch()
                        self.loadingLabel.text = "Info-COVID"
                        
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
        cell.textLabel?.text = region?.name ?? ""
        downloadDataNumber = (region?.data!.count)!
            - 1

        progressBar.isHidden = true
      
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
}

