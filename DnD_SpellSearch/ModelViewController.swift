//
//  ModelViewController.swift
//  DnD_SpellSearch
//
//  Created by admin on 10/23/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit
struct Type: Codable {
    init() {
        name = ""
    }
    let name: String
}

struct damageTypeStruct: Codable {
    init(){
        name = Type()
        //url = Type()
    }
    let name: Type
    //let url: Type
}

struct damageStruct: Codable {
    init() {
        damageType = damageTypeStruct()
        damage_at_slot_level = [:]
    }
    let damageType: damageTypeStruct
    let damage_at_slot_level: [Int:String]
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
        damage = damageStruct()
        school = schoolType()
        classes = []
        url = ""
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
    let damage: damageStruct
    let url: String
}

class ModelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
