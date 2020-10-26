//
//  SearchViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//
// https://www.dnd5eapi.co/
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


class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var schoolList = [Spells]()
    var schoolSpecificList = [Spells]()
    var spellList = [Spells]()
    var similarList = [Spells]()
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet var schoolField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let spellUrl = URL(string: "https://www.dnd5eapi.co/api/spells")
        if spellUrl != nil {
            downloadData(url: spellUrl!, type: "spell")
        }
        let schoolUrl = URL(string: "https://www.dnd5eapi.co/api/magic-schools")
        if schoolUrl != nil {
            downloadData(url: schoolUrl!, type: "school")
        }
        // this one is to create event listener when click on return after typing
        // it called function onReturn
        self.searchField.addTarget(self, action: #selector(onReturn), for: UIControl.Event.editingDidEndOnExit)
        schoolField.delegate = self
    }
    
    // WARNING
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let actionSheetAlert = UIAlertController(title: "Pick a School", message: "", preferredStyle: .actionSheet)
        actionSheetAlert.addAction(UIAlertAction(title: "All Schools", style: .default, handler: {_ in
            self.schoolField.text = ""
            self.schoolSpecificList = []
        }))
        for school in schoolList {
            actionSheetAlert.addAction(UIAlertAction(title: school.name, style: .default, handler: { _ in
                self.schoolField.text = school.name
                self.schoolSpecificList = []
                let spellUrl = URL(string: "https://www.dnd5eapi.co/api//spells?school=\(school.name)")
                if spellUrl != nil {
                    self.downloadData(url: spellUrl!, type: "schoolspell")
                }
                
            }))
        }

        self.present(actionSheetAlert, animated: true, completion: nil)
    }
    
    @IBAction func onReturn()
    {
        // not sure why, but need this line
        self.searchField.resignFirstResponder()
        
        // Dillon's codes
        
        guard searchField.text!.count > 0 else {
            // if nothing in the textfield => show all
            // similarList = spellList
            // performSegue(withIdentifier: "table_seg", sender: self)
            createAlert(title: "Empty Field", message: "Search an item or use the Search All tab!")
            return
        }
        // if there is character in textfield => search
        let searchedText = searchField.text!.lowercased().replacingOccurrences(of: " ", with: "-")
        if schoolSpecificList.count == 0 {
            for item in spellList {
                if item.index.contains("\(searchedText)"){
                    similarList.append(item)
                }
            }
        } else {
            for item in schoolSpecificList {
                if item.index.contains("\(searchedText)"){
                    similarList.append(item)
                }
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
    
    
    func decodeData(downloaded_data: Data, type: String){
         do
         {
            let downloaded_info = try JSONDecoder().decode(Root.self, from:downloaded_data)
            let tempList = downloaded_info.results
            if type == "spell"
            {
                for items in tempList{
                    spellList.append(items)
                }
            }
            else if type == "school"
            {
                for items in tempList{
                    schoolList.append(items)
                }
            }
            else if type == "schoolspell"
            {
                for items in tempList{
                    schoolSpecificList.append(items)
                }
            }
            
         } catch {print("Decoding Error")}
        
    }
    func downloadData(url: URL, type: String) {
        let _ = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //decode
            if let downloaded_data = data {
                self.decodeData(downloaded_data: downloaded_data, type: type)
            } else if let error = error {
                print(error)
            }
        }).resume()
    }
    //hide nav bar then show again once done.
    override func viewDidAppear(_ animated: Bool) {
        
        // navigationbar background color
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.13, blue: 0.12, alpha: 1.00)
        
        // set title color to white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        // set battery icon, time, network service to white
        navigationController?.navigationBar.barStyle = .black

        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)


    }
    override func viewWillDisappear(_ animated: Bool) {
        // Function generated warnings (Product -> Scheme -> Edit Scheme -> Run -> Run -> Main Thread Checker)
        let secondTab = self.tabBarController?.viewControllers![1] as! AllTableViewController
        secondTab.passedList = spellList
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func createAlert(title: String, message: String)
    {
        // display an message to the users (basically an alert window)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // addAction: attach an action (put button on the alert window)
        // UIAlertAction: the action of the users (tap)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)}))
        // alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)}))
        
        // show the action window when users perform action
        self.present(alert, animated: true, completion: nil)
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
