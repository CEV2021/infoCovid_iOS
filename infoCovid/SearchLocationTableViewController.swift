
//pruebo
import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var regions: [Region?] = []
    var connection = Connection()
    var filteredData : [Region?] = []
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredData = regions
        setupSearch()

        
        connection.getRegions { (regions) in
            if let regions = regions {
                self.regions = regions
                print(regions.count)
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
        
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
       
            filteredData = regions.filter({ region -> Bool in
                guard let text = searchController.searchBar.text else { return false }
                return region!.name!.lowercased().contains(text.lowercased())
            }).sorted { $0!.name! < $1!.name! }
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let region = filteredData[indexPath!.row]
        
        nextViewController.infectionsNumber = region?.data?[10].incidentRate
        nextViewController.deathsNumber = region?.data?[10].deaths
        nextViewController.recoveredNumber = region?.data?[10].recovered
        nextViewController.locationSelected = region?.name
        nextViewController.totalNumber = region?.data?[10].confirmed
        nextViewController.locationIsSelected = true
        nextViewController.datos = region
        
    }
}

