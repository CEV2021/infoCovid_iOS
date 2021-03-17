

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Buscar Ubicación"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print (text)
    }

}
