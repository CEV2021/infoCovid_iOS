

import UIKit

class UbicationsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let locationList = ["Madrid", "Murcia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as UITableViewCell
        let ubication = locationList[indexPath.row]
        cell.textLabel?.text = ubication
        //cell.textLabel?.text = String(pokemon?.height ?? 3)
        
        return cell
    }
    

   

}
