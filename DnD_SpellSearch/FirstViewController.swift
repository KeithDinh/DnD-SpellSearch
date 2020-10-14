//
//  FirstViewController.swift
//  DnD_SpellSearch
//
//  Created by student on 10/13/20.
//  Copyright © 2020 Dillon Jones. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var passedInformation = Spells()
    
    @IBOutlet weak var test: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.test.text = passedInformation.url
    }


}

