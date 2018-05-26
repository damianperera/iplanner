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

class AddCourseworkViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var courseworkName: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var overallWeight: UITextField!
    @IBOutlet weak var finalMark: UISlider!
    @IBOutlet weak var notes: UITextView!
    
    @IBAction func didClickDueDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        dueDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddCourseworkViewController.dateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dueDate.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
