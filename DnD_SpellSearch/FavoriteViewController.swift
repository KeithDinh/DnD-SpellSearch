//
//  FavoriteViewController.swift
//  DnD_SpellSearch
//
//  Created by admin on 11/13/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//  Ref: guides.codepath.com/ios/Search-Bar-Guide
//  Ref: https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells
//  Ref: https://medium.com/@gayatri.hedau/core-data-ios-swift-ed66b2e700fc
//  Ref: https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial
import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // initialize the core data object
    var Favorite: [NSManagedObject] = []
    var filteredList: [NSManagedObject] = []
    // save the selected row
    var selectedFav: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if doesn't have this line, the textDidChange won't work
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        // connect FavoriteViewController searchBar to UISearchBarDelegate extension below
        self.searchBar.delegate = self
        
        // connect FavoriteViewController tableView to UITableViewDeletegate extension below
        self.tableView.delegate = self
        
        // connect FavoriteViewController tableView to UITableViewDataSource extension below
        self.tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    // 3 steps of fetching data from CoreData
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContent = appDelegate.persistentContainer.viewContext
        // 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        // 3
        do {
            Favorite = try managedContent.fetch(fetchRequest)
            filteredList = Favorite
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="favToDetail" {
            let Details = segue.destination as! FirstViewController
            Details.passedInformation = selectedFav
        }
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            // 1
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            // 2
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorite")
            // 3
            fetchRequest.predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
            do {
                filteredList = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        } else {
            filteredList = Favorite
        }
        tableView.reloadData()
    }


}

extension FavoriteViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // height removes warning "Detected a case where constraints ambiguously suggest a height of zero for a table view cell's content view. We're considering the collapse unintentional and using standard height instead"
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Fav = filteredList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        // set cell background to transparent
         cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let cell_name = cell.viewWithTag(1) as! UILabel
        
        // set font type to Times New Roman, size = 30
        cell_name.font = UIFont(name: "Mr.EavesSmallCaps", size: 20)
        
        // Get the name from CoreData Object (name,url) Fav
        cell_name.text = Fav.value(forKeyPath: "name") as? String
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fav = filteredList[indexPath.row]
        selectedFav = fav.value(forKeyPath: "url") as! String
        self.performSegue(withIdentifier: "favToDetail", sender: self)
    }
    
    // add the swiping action (delete and add)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // * Swipe removing
        if editingStyle == .delete {
        
            let fav = filteredList[indexPath.row]
            selectedFav = fav.value(forKeyPath: "name") as! String
            
            // * Remove the object from CoreData
            // 1
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            // 2
            let managedContent = appDelegate.persistentContainer.viewContext
            // 3
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.predicate = NSPredicate(format: "name == %@", selectedFav)

            do {
                let temp = try managedContent.fetch(fetchRequest)
                let objectToDelete = temp[0] // as! NSManagedObject
                
                // remove the object
                managedContent.delete(objectToDelete)
                do {
                    // Save the updated content to CoreData (like push the change in git)
                    try managedContent.save()
                    
                    // Remove the object from the Filtered list
                    if let indexFilterList = filteredList.firstIndex(of: fav) {
                        filteredList.remove(at: indexFilterList)
                    }
                    // Remove the object from the Favorite list
                    if let indexFavoriteList = Favorite.firstIndex(of: fav) {
                        Favorite.remove(at: indexFavoriteList)
                    }
                } catch let error as NSError {
                    print("Error in save \(error), \(error.userInfo)")
                }
            } catch {
                print("Error in fetch")
            }
            
            // Remove the corresponse row in table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
