//
//  AddCourseworkViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/26/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import Foundation
import UIKit

protocol AddCourseworkDelegate {
    
}

class AddCourseworkViewController: UIViewController {
    
    @IBOutlet weak var courseworkName: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var overallWeight: UITextField!
    @IBOutlet weak var finalMark: UISlider!
    @IBOutlet weak var notes: UITextView!
    
    @IBAction func didClickDueDate(_ sender: UITextField) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
