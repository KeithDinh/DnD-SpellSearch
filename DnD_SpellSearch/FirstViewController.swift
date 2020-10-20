//
//  FirstViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit
struct Type: Codable {
    init() {
        name = ""
    }
    let name: String
}
struct damageType: Codable {
    init(){
        damage_type = Type()
        //damage_at_slot_level = [:]
    }
    let damage_type: Type
   // let damage_at_slot_level:[String:String]
}
struct schoolType: Codable {
    init() {
        name = ""
    }
    let name: String
}
struct classType: Codable {
    init(){
        name = ""
    }
    let name: String
}
struct spellDetails : Codable {
    init(){
        name = ""
        desc = []
        higher_level = []
        range = ""
        components = []
        material = ""
        ritual = false
        duration = ""
        concentration = false
        casting_time = ""
        level = 0
        attack_type = ""
        damage = damageType()
        school = schoolType()
        classes = []
    }
    let name: String
    let desc: [String]
    let range: String
    let components: [String]
    let ritual: Bool
    let duration: String
    let concentration: Bool
    let casting_time: String
    let level: Int
    let school: schoolType
    let classes: [classType]
    
    //items found to be optional
    let higher_level: [String]?
    let material: String?
    let attack_type: String?
    let damage: damageType?
}
class FirstViewController: UIViewController {

    var passedInformation: String = ""
    var thisSpell = spellDetails()
    
    @IBOutlet weak var spellTitle: UILabel!
    @IBOutlet weak var spellDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.dnd5eapi.co\(passedInformation)" )
        if url != nil {
            downloadData(url:url!)
        }
    }
    func loadData(){
        DispatchQueue.main.async {
            self.spellTitle.text = self.thisSpell.name
            self.spellDesc.text = self.thisSpell.desc.joined(separator: " ")
        }
 
        
        
    }
    func decodeData(downloaded_data: Data){
         do {
           let downloaded_info = try JSONDecoder().decode(spellDetails.self, from:downloaded_data)
            self.thisSpell = downloaded_info
            loadData()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        let spellDetailsView = self.tabBarController?.viewControllers![1] as! SecondViewController
        spellDetailsView.passedSpell = thisSpell
    }


}

