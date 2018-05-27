//
//  AddTaskViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/27/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import Foundation
import UIKit

protocol AddTaskViewDelegate {
    func saveData(taskName: String, startDate: Date, dueDate: Date, complete: Int32, notes: String)
}

class AddTaskViewController: UIViewController {
    
    var delegate: AddTaskViewDelegate?
    @IBOutlet weak var fieldTaskName: UITextField!
    @IBOutlet weak var fieldStartDate: UITextField!
    @IBOutlet weak var fieldDueDate: UITextField!
    @IBOutlet weak var sliderComplete: UISlider!
    @IBOutlet weak var labelComplete: UILabel!
    @IBOutlet weak var fieldNotes: UITextView!
    
    @IBAction func didClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
