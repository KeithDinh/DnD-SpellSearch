//
//  SpellSearchData.swift
//  DnD_SpellSearch
//
//  Created by student on 10/26/20.
//  Copyright © 2020 Dillon Jones & Kiet Dinh. All rights reserved.
//  Define the data models to convert data from API

import Foundation

//Data and Codables

var spellSchools: [String] = ["Abjuration","Conjuration","Divination","Enchantment","Evocation","Illusion","Necromancy","Transmutation"]

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
//Spell Details


struct Type: Codable {
    init() {
        name = ""
    }
    let name: String
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
struct damageType: Codable {
    init() {
        damage_type = damage_typeType()
        damage_at_slot_level = [:]
    }
    let damage_type: damage_typeType
    let damage_at_slot_level: [Int:String]
}
struct damage_typeType: Codable {
    init() {
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
        school = schoolType()
        classes = []
        subclasses = []
        url = ""
        // damage = damageType()
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
    let subclasses: [classType]?
    let url: String
    // let damage: damageType?
    //items found to be optional
    let higher_level: [String]?
    let material: String?
}

