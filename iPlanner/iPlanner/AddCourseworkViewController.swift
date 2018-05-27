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
    func saveData(name: String, module: String, dueDate: Date, level: Int32, weight: Int32, mark: Int32, notes: String)
}

class AddCourseworkViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: AddCourseworkDelegate?
    var coursework: Coursework!
    @IBOutlet weak var courseworkNameField: UITextField?
    @IBOutlet weak var moduleNameField: UITextField?
    @IBOutlet weak var dueDateField: UITextField?
    @IBOutlet weak var levelField: UITextField?
    @IBOutlet weak var overallWeightField: UITextField?
    @IBOutlet weak var finalMarkField: UISlider?
    @IBOutlet weak var notesField: UITextView?
    @IBOutlet weak var markLabel: UILabel?
    
    func setFieldsFromObject() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if let courseworkObject = coursework {
            courseworkNameField?.text = courseworkObject.name
            moduleNameField?.text = courseworkObject.moduleId
            dueDateField?.text = dateFormatter.string(from: courseworkObject.dueDate!)
            levelField?.text = String(courseworkObject.level)
            overallWeightField?.text = String(courseworkObject.weight)
            finalMarkField?.value = Float((courseworkObject.mark))
            notesField?.text = courseworkObject.notes
            markLabel?.text = String(courseworkObject.mark)
        }
    }
    
    @IBAction func didPickerValueChanged(_ sender: UISlider) {
        markLabel?.text = String(Int(sender.value))
    }
    
    @IBAction func didClickDueDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minimumDate = Date()
        dueDateField?.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddCourseworkViewController.dateChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func didClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        guard
            let name = courseworkNameField?.text, !name.isEmpty,
            let module = moduleNameField?.text, !module.isEmpty,
            let dueDate = dueDateField?.text, !dueDate.isEmpty,
            let level = levelField?.text, !level.isEmpty,
            let weight = overallWeightField?.text, !weight.isEmpty,
            let mark = markLabel?.text, !mark.isEmpty,
            let notes = notesField?.text, !notes.isEmpty,
            self.delegate != nil
        else {
            print("Could not save")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        delegate?.saveData(
            name: name,
            module: module,
            dueDate: dateFormatter.date(from: dueDate)!,
            level: Int32(level)!,
            weight: Int32(weight)!,
            mark: Int32(mark)!,
            notes: notes)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dueDateField?.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard self.coursework != nil
        else {
            markLabel?.text = "30"
            return
        }
        setFieldsFromObject()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
