//
//  TableViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var passedList = [Spells]()
    var selectedInformation:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the background image for the tableView
        tableView.backgroundView = UIImageView(image: UIImage(named: "urn_aaid_sc_US_1777706d-7d97-4e70-90b7-1a206e1e9534"))
    }

    override func viewDidAppear(_ animated: Bool) {
        
//        // navigationbar background color
//        navigationController?.navigationBar.barTintColor = .black
//
//        // set title color to white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//
//        // set battery icon, time, network service to white
//        navigationController?.navigationBar.barStyle = .black
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return passedList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // set cell background to transparent
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let cell_name = cell.viewWithTag(1) as! UILabel
        
        // set font type to Times New Roman, size = 30
        cell_name.font = UIFont(name: "Times New Roman", size: 25)
        
        cell_name.text = passedList[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="tableToDetail" {
            let Details = segue.destination as! FirstViewController
            Details.passedInformation = selectedInformation
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInformation = passedList[indexPath.row].url
        self.performSegue(withIdentifier: "tableToDetail", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
