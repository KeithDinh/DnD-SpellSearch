//
//  FirstViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {

    var Favorite:[NSManagedObject] = []
    var isFav: Bool = false
    var passedInformation: String = ""
    var thisSpell = spellDetails()
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var spellName: UILabel!
    @IBOutlet weak var spellSchool: UILabel!
    @IBOutlet weak var labelCastTime: UILabel!
    @IBOutlet weak var spellCastingTime: UILabel!
    @IBOutlet weak var labelRange: UILabel!
    @IBOutlet weak var spellRange: UILabel!
    @IBOutlet weak var labelComponents: UILabel!
    @IBOutlet weak var spellComponents: UILabel!
    @IBOutlet weak var spellMat: UITextView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var spellDuration: UILabel!
    @IBOutlet weak var labelClasses: UILabel!
    @IBOutlet weak var spellClasses: UILabel!
    @IBOutlet weak var labelSubClasses: UILabel!
    @IBOutlet weak var spellSubClasses: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var spellDesc: UITextView!
    // @IBOutlet weak var spellDamageType: UILabel!
    @IBOutlet weak var labelExtra: UILabel!
    @IBOutlet weak var spellExtra: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        let url = URL(string: "https://www.dnd5eapi.co\(passedInformation)" )
        if url != nil {
            downloadData(url:url!)
        }
    }

    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    // add to core data, 
    func addToFavorite(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //step 1
        let managedContent = appDelegate.persistentContainer.viewContext
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContent)!
        let fav = NSManagedObject(entity: entity, insertInto: managedContent)
        //3
        fav.setValue(thisSpell.name, forKey: "name")
        fav.setValue(thisSpell.url, forKey: "url")
        //4
        do {
            try managedContent.save()
            Favorite.append(fav)
            setFavStatus(status: true)
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeFromFavorite(){
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContent = appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        // return the matching spell name
        fetchRequest.predicate = NSPredicate(format: "name = %@", thisSpell.name)
        
        let result = try? managedContent.fetch(fetchRequest)
        let resData = result!

        for object in resData {
            managedContent.delete(object)
        }
        do {
            try managedContent.save()
            // deactive the heart
            setFavStatus(status:false)
        }   catch let error as NSError {
            print("error in save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if isFav {
            removeFromFavorite()
        }else {
            addToFavorite()
        }
    }
    
    func setFavStatus(status:Bool){
        isFav = status
        if status {
            favButton.image = UIImage(systemName: "heart.fill")
        } else {
            favButton.image = UIImage(systemName: "heart")
        }
    }
    

    func checkFav(){
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContent = appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        // return matching spell name
        fetchRequest.predicate = NSPredicate(format: "name = %@", thisSpell.name)
        // if match there should be only 1 matching
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try managedContent.count(for: fetchRequest)
            if count > 0 {
                setFavStatus(status: true)
                return
            }else {
                setFavStatus(status: false)
                return
            }
        } catch let error as NSError {
            print("FavCheck Error \(error), \(error.userInfo)")
            return
        }
    }
    func getSchool() {
        switch self.thisSpell.level {
        case 0:
            self.spellSchool.text = "\(self.thisSpell.school.name) Cantrip"
        case 1:
            self.spellSchool.text = "1st Level \(self.thisSpell.school.name)"
        case 2:
            self.spellSchool.text = "2nd Level \(self.thisSpell.school.name)"
        case 3:
            self.spellSchool.text = "3rd Level \(self.thisSpell.school.name)"
        case 4...9:
            self.spellSchool.text = "\(self.thisSpell.level)th Level \(self.thisSpell.school.name)"
        default:
            self.spellSchool.text = ""
        }
    }
    
    func getRitual() {
        if thisSpell.ritual == true {
            self.spellSchool.text!.append("(ritual)")
        }
    }
    func getComponents() {
        var comp = ""
        for item in thisSpell.components {
            comp += item
        }
        spellComponents.text = "\(comp)"
        
    }
    func getMats() {
        if thisSpell.material != nil {
            spellMat.text = "(\(thisSpell.material!))"
        }else {
            spellMat.text = ""
        }
    }
    func getExtra() {
        if thisSpell.higher_level != nil {
            spellExtra.text = "\(thisSpell.higher_level!.joined(separator: "\n"))"
        }else{
            self.labelExtra.text = ""
            self.spellExtra.text = ""
        }
    }
    func getClasses() {
        var classList = ""
        var first = true
        for items in thisSpell.classes {
            if first == true {
                first = false
                classList += items.name
            }
            else {
            classList += ", \(items.name)"
            }
            
        }
        spellClasses.text = "\(classList)"
    }
    
    func getSubClasses() {
        if thisSpell.subclasses?.count == 0 {
            // prevent the sub class to be None
            spellSubClasses.text = thisSpell.classes[0].name
            return
        }
        var subClassList = ""
        var first = true
        for items in thisSpell.subclasses! {
            if first == true {
                first = false
                subClassList += items.name
            }
            else {
            subClassList += ", \(items.name)"
            }
            
        }
        spellSubClasses.text = "\(subClassList)"
    }
//    func getSpellDamageType()
//    {
//
//        if self.thisSpell.damage?.damage_type.name != nil {
//            spellDamageType.text = self.thisSpell.damage?.damage_type.name
//            return
//        }
//        self.spellDamageType.text = "None"
//    }
    func decodeData(downloaded_data: Data){
         do {
            let downloaded_info = try JSONDecoder().decode(spellDetails.self, from:downloaded_data)
            self.thisSpell = downloaded_info
            loadData()
            } catch {print("Decoding Error")}
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
    func loadData(){
        DispatchQueue.main.async {
            self.spellName.text = self.thisSpell.name
            self.checkFav()
            self.getSchool()
            self.getRitual()
            // self.getSpellDamageType()
            self.spellCastingTime.text  = "\(self.thisSpell.casting_time)"
            self.spellRange.text = "\(self.thisSpell.range)"
            self.spellComponents.text = "\(self.thisSpell.components.joined())"
            self.getMats()
            self.spellDuration.text = "\(self.thisSpell.duration)"
            self.getClasses()
            self.getSubClasses()
            self.spellDesc.text = self.thisSpell.desc.joined(separator: "\n \n")
            self.getExtra()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setFonts(){
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bookinsanity-Italic", size: 20)!]
        spellName.font = UIFont(name: "Bookinsanity-BoldItalic", size: 20)
        spellSchool.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelCastTime.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellCastingTime.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelRange.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellRange.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelComponents.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellComponents.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        spellMat.font = UIFont(name: "Bookinsanity-Italic", size: 10)
        labelDuration.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellDuration.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelClasses.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellClasses.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelSubClasses.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellSubClasses.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        labelDesc.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellDesc.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        spellDesc.textContainerInset = UIEdgeInsets.zero
        spellDesc.textContainer.lineFragmentPadding = 0
        labelExtra.font = UIFont(name: "Bookinsanity-BoldItalic", size: 17)
        spellExtra.font = UIFont(name: "Bookinsanity-Italic", size: 17)
        spellExtra.textContainerInset = UIEdgeInsets.zero
        spellExtra.textContainer.lineFragmentPadding = 0
        
        //Mr.EavesSmallCaps
    }
}
//Family: Bookinsanity Font names: ["Bookinsanity-Italic", "Bookinsanity-BoldItalic"]
