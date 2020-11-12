//
//  SearchViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//
// https://www.dnd5eapi.co/
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    var spellList = [Spells]()
    var filteredList = [Spells]()
    var selectedSpell: String = ""

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchManager = SearchManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        searchManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchManager.fetchList()
        
        // this one is to create event listener when click on return after typing
        // it called function onReturn
       // self.searchField.addTarget(self, action: #selector(onReturn), for: UIControl.Event.editingDidEndOnExit)
        
    }
    
    @IBAction func levelButton(_ sender: Any) {
        let levelSelect = UIAlertController(title: "Sort by Level", message:"", preferredStyle: .actionSheet)
               levelSelect.addAction(UIAlertAction(title: "Any Level", style: .default, handler: {_ in
                self.searchManager.fetchList()
               }))
        for level in Range(0...9) {
            var title = ""
            if level == 0 {
                title = "Cantrip"
            }else {
                title = "\(level)"
            }
            levelSelect.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                self.searchManager.fetchLevelList(level: level)

            }))
        }
        self.present(levelSelect, animated: true, completion: nil)
    }
    
    @IBAction func schoolButton(_ sender: Any) {
        let schoolSelect = UIAlertController(title: "Sort by School", message:"", preferredStyle: .actionSheet)
               schoolSelect.addAction(UIAlertAction(title: "Any School", style: .default, handler: {_ in
                self.searchManager.fetchList()
               }))
        for school in spellSchools {
            schoolSelect.addAction(UIAlertAction(title: school, style: .default, handler: { _ in
                self.searchManager.fetchSchoolList(school: school)
            }))
        }
        self.present(schoolSelect, animated: true, completion: nil)
    }
    // WARNING
    /*
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
    */
    /*
    @IBAction func onReturn()
    {
        // not sure why, but need this line
        //self.searchField.resignFirstResponder()
        
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
*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showDetail" {
            let Details = segue.destination as! FirstViewController
            Details.passedInformation = selectedSpell
        }
    }
    
    /*
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
 */
    override func viewDidAppear(_ animated: Bool) {
        
        // navigationbar background color
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.13, blue: 0.12, alpha: 1.00)
        // set title color to white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        // set battery icon, time, network service to white
        navigationController?.navigationBar.barStyle = .black

        super.viewWillAppear(true)
        //navigationController?.setNavigationBarHidden(true, animated: true)


    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationController?.setNavigationBarHidden(false, animated: true)
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
    func setFonts() {
        //searchField.font = UIFont(name: "Bookinsanity", size: 17)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSpell = filteredList[indexPath.row].url
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let cellName = cell.viewWithTag(1) as! UILabel
        cellName.font = UIFont(name: "Mr.EavesSmallCaps", size: 20)
        cellName.text = filteredList[indexPath.row].name
        
        return cell
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    //guides.codepath.com/ios/Search-Bar-Guide
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filteredList = searchText.isEmpty ? spellList : spellList.filter {(list:Spells) -> Bool in
            return list.name.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil
            
        }
        tableView.reloadData()
    }
    
}
extension SearchViewController: SearchManagerDelegate {
    func didUpdateList (_ searchManager: SearchManager, list: [Spells]) {
        DispatchQueue.main.async {
            self.spellList = list
            self.filteredList = list
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
