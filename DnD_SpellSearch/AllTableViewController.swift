//
//  AllTableViewController.swift
//  DnD_SpellSearch
//
//  Created by admin on 10/24/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//

import UIKit

class AllTableViewController: UITableViewController {
        var passedList = [Spells]()
        var selectedInformation:String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // add the background image for the tableView
            tableView.backgroundView = UIImageView(image: UIImage(named: "urn_aaid_sc_US_1777706d-7d97-4e70-90b7-1a206e1e9534"))
        }
        override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            navigationController?.setNavigationBarHidden(false, animated: true)
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
            cell_name.font = UIFont(name: "Mr.EavesSmallCaps", size: 30)
            
            cell_name.text = passedList[indexPath.row].name
            
            return cell
        }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier=="allToDetail" {
                let Details = segue.destination as! FirstViewController
                Details.passedInformation = selectedInformation
            }
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedInformation = passedList[indexPath.row].url
            self.performSegue(withIdentifier: "allToDetail", sender: self)
        }


}
