//
//  SecondViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var passedSpell = spellDetails()
    
    @IBOutlet weak var spellName: UILabel!
    
    @IBOutlet weak var spellCastTime: UILabel!
    @IBOutlet weak var spellComponents: UILabel!
    @IBOutlet weak var spellExtra: UITextView!
    @IBOutlet weak var spellClasses: UILabel!
    @IBOutlet weak var spellRange: UILabel!
    @IBOutlet weak var spellSchool: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
               spellName.text = passedSpell.name
        spellSchool.text = "Level \(passedSpell.level) \(passedSpell.school.name)"
               spellCastTime.text  = "Casting Time: \(passedSpell.casting_time)"
               spellRange.text = "Range: \(passedSpell.range)"
        spellComponents.text = "Components: \(passedSpell.components.joined())"
               getClasses()
               getExtra()
    }
    func getComponents() {
        var comp = ""
        for item in passedSpell.components {

            comp += item
        }
        print("here")
        spellComponents.text = "Components: \(comp)"
        
    }
    func getExtra() {
        //need to work on getting info from api (damage at level/healing at level)
    }
    func getClasses() {
        var classList = ""
        var first = true
        for items in passedSpell.classes {
            if first == true {
                first = false
                classList += items.name
            }
            else {
            classList += ",\(items.name)"
            }
            
        }
        spellClasses.text = "Classes: \(classList)"
    }
}

