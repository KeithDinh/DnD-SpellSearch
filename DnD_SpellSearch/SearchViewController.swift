//
//  SearchViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit

struct Spells: Codable{
    init(){
        index = ""
        name = ""
        url = ""
    }
    let index: String
    let name: String
    let url: String
}
struct Root: Codable {
    init() {
        count = 0
        results = []
    }
    let count: Int
    let results: [Spells]
}


class SearchViewController: UIViewController {
    
    var spellList = [Spells]()
    var similarList = [Spells]()

    
    @IBOutlet weak var searchField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.dnd5eapi.co/api/spells")
        if url != nil {
            downloadData(url: url!)
        }
        
        // this one is to create event listener when click on return after typing
        // it called function onReturn
        self.searchField.addTarget(self, action: #selector(onReturn), for: UIControl.Event.editingDidEndOnExit)
        
    }
    @IBAction func onReturn()
    {
        // not sure why, but need this line
        self.searchField.resignFirstResponder()
        
        // Dillon's codes
        
        
        guard searchField.text!.count > 0 else {
            // if nothing in the textfield => show all
            similarList = spellList
            performSegue(withIdentifier: "table_seg", sender: self)
            return
        }
        // if there is character in textfield => search
        
        let searchedText = searchField.text!.lowercased().replacingOccurrences(of: " ", with: "-")

        for item in spellList {
            if item.index.contains("\(searchedText)"){
                similarList.append(item)
            }
        }
        performSegue(withIdentifier: "table_seg", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "table_seg" {
            let TableView = segue.destination as! TableViewController
            TableView.passedList = similarList
            self.similarList = []
        }
    }
    
    
    func decodeData(downloaded_data: Data){
         do {
            let downloaded_info = try JSONDecoder().decode(Root.self, from:downloaded_data)
            let tempList = downloaded_info.results
            for items in tempList{
                spellList.append(items)
            }
         //   DispatchQueue.main.async {}
               } catch {
                   print("Decoding Error")
               }
        
    }
    func downloadData(url: URL) {
        let _ = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //decode
            if let downloaded_data = data {
                self.decodeData(downloaded_data: downloaded_data)
            } else if let error = error {
                print(error)
            }
            }).resume()
    }

    
//    @IBAction func searchButton(_ sender: Any) {
//        guard searchField.text!.count > 0 else {
//                      let alert = UIAlertController(title: "Missing Spell", message: "Please enter a spell or press Show All", preferredStyle: .alert)
//                      alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)
//                      }))
//                      self.present(alert, animated: true)
//                      return
//              }
//        let searchedText = searchField.text!.lowercased().replacingOccurrences(of: " ", with: "-")
//
//        for item in spellList {
//            if item.index.contains("\(searchedText)"){
//                similarList.append(item)
//            }
//        }
//        performSegue(withIdentifier: "table_seg", sender: self)
//    }
//
//    @IBAction func showAllButton(_ sender: Any) {
//        similarList = spellList
//        performSegue(withIdentifier: "table_seg", sender: self)
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
