
//pruebo
import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var pokemons: [Pokemon?] = []
    var regions: [Region?] = []
    var connection = Connection()
    var MAX_POKEMONS = 183
    var filteredData : [Region?] = []
    var pokemonsDownload = 0
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredData = regions
        setupSearch()

        for _ in 1...10{
            connection.getRegion { (regions) in
                if let regions = regions{
                    self.regions.append(regions[14])
                }
                print(self.regions[0]?.name)
            }
        }
        
        
        
        pokemons = [Pokemon?] (repeating: nil, count: MAX_POKEMONS)
        
        //Se recorre el array hasta el numero de la variable Max_Pokemons recogiendo el contenido haciendo conexion con la API
        for i in 1...MAX_POKEMONS{
            connection.getPokemon(withID: i) { pokemon in
                self.pokemonsDownload += 1
                if let pokemon = pokemon, let id = pokemon.id{
                    self.pokemons[id-1] = pokemon
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
        cell.textLabel?.text = region?.name ?? ""
        
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if pokemonsDownload == MAX_POKEMONS {
            filteredData = regions.filter({ region -> Bool in
                guard let text = searchController.searchBar.text else { return false }
                return region!.name!.lowercased().contains(text.lowercased())
            }).sorted { $0!.name! < $1!.name! }
        }
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

