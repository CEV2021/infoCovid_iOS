//
//  PruebaTableViewController.swift
//  infoCovid
//
//  Created by Silvia Casanova Martinez on 29/3/21.
//

import UIKit

class UbicationsTableViewController: UITableViewController {
    
    var locationList = ["Madrid", "Murcia", "Galicia", "Extremadura"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as UITableViewCell
        let ubication = locationList[indexPath.row]
        cell.textLabel?.text = ubication
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let pokemon = locationList[indexPath!.row]
        
        
        nextViewController.locationSelected = "pokemon"
        nextViewController.infectionsNumber = 344
       
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    //Funcion para borrar las ubicaciones de la tabla, ya sea desde el modo edicion o arrastrando a la izquierda
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    //Funcion que permite reordenar las posiciones de la tabla desde el modo editar
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let locationMove = locationList[fromIndexPath.row]
        locationList.remove(at: fromIndexPath.row)
        
        locationList.insert(locationMove, at: to.row)
        tableView.reloadData()
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

   
}
