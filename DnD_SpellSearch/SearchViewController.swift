//
//  SearchViewController.swift
//  DnD_SpellSearch
//
// !!! Requires Resnet50.mlmodel !!!
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//
// https://www.dnd5eapi.co/
import UIKit
import NaturalLanguage
class SearchViewController: UIViewController, UITextFieldDelegate {

    var spellList = [Spells]()
    var filteredList = [Spells]()
    var ListLemmas: [[String]] = []
    var selectedSpell: String = ""
    var matchingLemmaList = [Spells]()

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchManager = SearchManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adds search bar to navigation controller. Delegation is switched between Tabs
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        searchManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchManager.fetchList()
    }
    //Allows second tab to use same navigation search bar
    override func viewDidDisappear(_ animated: Bool) {
        let favoriteTab = self.tabBarController?.viewControllers![1] as! FavoriteViewController
        favoriteTab.searchBar = searchBar
     }
    
    //For each spell in spellList, make seperate list of the spell name's lemma
    func getListLemmas() {
        ListLemmas = []
        for spells in spellList{
            var Lemma: [String] = []
            var text = spells.name
            var singleWord = false
            if text.components(separatedBy: " ").filter({!$0.isEmpty}).count == 1 {
                text = "please show me \(text)"
                singleWord = true
            }
            let tagger = NLTagger(tagSchemes: [.lemma])
            tagger.string = text
            tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenId in
                if let convertedTag = tag {
                    let tagValue = convertedTag.rawValue.lowercased()
                    if singleWord == true {
                        if tagValue != "please" && tagValue != "show" && tagValue != "i" {
                            Lemma.append("\(convertedTag.rawValue.lowercased())")
                        }
                    }
                    else{
                    Lemma.append("\(convertedTag.rawValue.lowercased())")
                    }
                }
                return true
            }
            
            ListLemmas.append(Lemma)
        }
    }
    //Fetches level specified spells from API
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
    
    //Fetch school specific spells from API
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showDetail" {
            let Details = segue.destination as! FirstViewController
            Details.passedInformation = selectedSpell
        }
    }
    
    //Navigation bar Formatting
    override func viewDidAppear(_ animated: Bool) {
        searchBar.delegate = self
        // navigationbar background color
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.13, blue: 0.12, alpha: 1.00)
        // set title color to white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        // set battery icon, time, network service to white
        navigationController?.navigationBar.barStyle = .black

        //super.viewWillAppear(true)
        //navigationController?.setNavigationBarHidden(true, animated: true)


    }
}


// Table view Formatting

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if numberOfSections(in: tableView) == 2 {
            if indexPath.section == 2{
                selectedSpell = filteredList[indexPath.row].url
                performSegue(withIdentifier: "showDetail", sender: self)
            }
            else{
                selectedSpell = matchingLemmaList[indexPath.row].url
                performSegue(withIdentifier: "showDetail", sender: self)
            }
            
        }
        else{
            selectedSpell = filteredList[indexPath.row].url
            performSegue(withIdentifier: "showDetail", sender: self)
                
        }

    }
}

extension SearchViewController: UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if numberOfSections(in: tableView) > 1 {
            let label = UILabel()
            label.backgroundColor = .black
            label.textColor = .white
            label.font = UIFont(name: "Bookinsanity", size: 20)
            if section == 0 {
                label.text = " Spells with Similar Meanings"
            } else {
                label.text = " Spells with Similar Names"
            }
            return label
        } else {
            print("No label")
            return nil
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if numberOfSections(in: tableView) == 1 {
            return 0
        }else{
            return 30
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if matchingLemmaList.count != 0 {
            return 2
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSections(in: tableView) == 2{
            if section == 0 {
                return matchingLemmaList.count
            }
            else{
                return filteredList.count
            }
        }
        else{
            return filteredList.count
        }
 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let cellName = cell.viewWithTag(1) as! UILabel
        cellName.font = UIFont(name: "Mr.EavesSmallCaps", size: 20)
        
        if numberOfSections(in: tableView) == 2 {
            if indexPath.section == 0{
                cellName.text = matchingLemmaList[indexPath.row].name
            }
            else {
                cellName.text = filteredList[indexPath.row].name
            }
        }
        else {
            cellName.text = filteredList[indexPath.row].name
        }
        return cell
    }
}

//Allows search bar to update table view dynamically
extension SearchViewController: UISearchBarDelegate {
    //guides.codepath.com/ios/Search-Bar-Guide
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filteredList = searchText.isEmpty ? spellList : spellList.filter {(list:Spells) -> Bool in
            return list.name.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil
        }
        lemmatizeSearch(textToProcess : searchText)
    }
    func lemmatizeSearch(textToProcess : String) {
        matchingLemmaList = []
        var text = textToProcess
        var singleWord = false
        if text.components(separatedBy: " ").filter({!$0.isEmpty}).count == 1 {
            text = "please show me \(text)"
            singleWord = true
        }
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        var searchedLemmas: [String] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenId in
            if let convertedTag = tag {
                let tagValue = convertedTag.rawValue.lowercased()
                if singleWord == true {
                    if tagValue != "please" && tagValue != "show" && tagValue != "i" {
                        searchedLemmas.append("\(convertedTag.rawValue.lowercased())")
                    }
                }
                else{
                searchedLemmas.append("\(convertedTag.rawValue.lowercased())")
                }
                
            }
            return true
        }
        if searchedLemmas.count != 0 {
            for (index,item) in ListLemmas.enumerated() {
                if item.count != 0 {
                    if item.contains(where: searchedLemmas.contains){
                        matchingLemmaList.append(spellList[index])
                    }
                }
            }
            
        }
        tableView.reloadData()

    }
}

//Delegate of SearchManager to update lists
extension SearchViewController: SearchManagerDelegate {
    func didUpdateList (_ searchManager: SearchManager, list: [Spells]) {
        DispatchQueue.main.async {
            self.spellList = list
            self.filteredList = list
            self.getListLemmas()
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
