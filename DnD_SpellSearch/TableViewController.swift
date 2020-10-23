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
    var favoriteList = [Favorite]()
    var selectedInformation:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "urn_aaid_sc_US_1777706d-7d97-4e70-90b7-1a206e1e9534"))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // background navigationbar color
        navigationController?.navigationBar.barTintColor = .black
        
        // title color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        // time, battery color
        navigationController?.navigationBar.barStyle = .black
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
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let cell_name = cell.viewWithTag(1) as! UILabel
        cell_name.font = UIFont(name: "Times New Roman", size: 30)
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
            Details.favoriteList = favoriteList
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInformation = passedList[indexPath.row].url
        self.performSegue(withIdentifier: "tableToDetail", sender: self)
    }


}
