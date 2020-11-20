//
//  SearchViewController.swift
//  DnD_SpellSearch
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
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchManager.fetchList()
    }
    func getListLemmas() {
        ListLemmas = []
        for spells in spellList{
            var Lemma: [String] = []
            let text = spells.name
            let tagger = NLTagger(tagSchemes: [.lemma])
            tagger.string = text
            tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenId in
                if let convertedTag = tag {
                    Lemma.append("\(convertedTag.rawValue)")
                }
                return true
            }
            
            ListLemmas.append(Lemma)
        }
        print(ListLemmas)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showDetail" {
            let Details = segue.destination as! FirstViewController
            Details.passedInformation = selectedSpell
        }
    }
    
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
}
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
            label.font = UIFont(name: "Mr.EavesSmallCaps", size: 25)
            if section == 0 {
                label.text = "Spells with Similar Meanings"
            } else {
                label.text = "Spells with Similar Names"
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
            return 50
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
        let text = textToProcess
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        var searchedLemmas: [String] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenId in
            if let convertedTag = tag {
                searchedLemmas.append(convertedTag.rawValue)
            }
            return true
        }
        print(searchedLemmas)
        if searchedLemmas.count != 0 {
            for (index,item) in ListLemmas.enumerated() {
                if item.count != 0 {
                    if item.contains(where: searchedLemmas.contains){
                        matchingLemmaList.append(spellList[index])
                    }
                }
            }
            
        }
        print(matchingLemmaList)
        tableView.reloadData()

    }
}
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
