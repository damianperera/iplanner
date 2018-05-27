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
    var coursework: Coursework?
    @IBOutlet weak var fieldTaskName: UITextField?
    @IBOutlet weak var fieldStartDate: UITextField?
    @IBOutlet weak var fieldDueDate: UITextField?
    @IBOutlet weak var sliderComplete: UISlider?
    @IBOutlet weak var labelComplete: UILabel?
    @IBOutlet weak var fieldNotes: UITextView?
    
    @IBAction func didSliderValueChanged(_ sender: UISlider) {
        labelComplete?.text = String(Int(sender.value)) + "% Complete"
    }
    
    @IBAction func startDateEditingDidBegin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minimumDate = Date()
        datePickerView.maximumDate = coursework?.dueDate
        fieldStartDate?.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.startDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func dueDateEditingDidBegin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minimumDate = Date()
        datePickerView.maximumDate = coursework?.dueDate
        fieldDueDate?.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.dueDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func didClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        guard
            let name = fieldTaskName?.text, !name.isEmpty,
            let startDate = fieldStartDate?.text, !startDate.isEmpty,
            let dueDate = fieldDueDate?.text, !dueDate.isEmpty,
            let complete = String(Int((sliderComplete?.value)!)) as String?, !complete.isEmpty,
            let notes = fieldNotes?.text, !notes.isEmpty,
            self.delegate != nil
            else {
                print("Could not save")
                return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        delegate?.saveData(
            taskName: name,
            startDate: dateFormatter.date(from: startDate)!,
            dueDate: dateFormatter.date(from: dueDate)!,
            complete: Int32(complete)!,
            notes: notes)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dueDateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        fieldDueDate?.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func startDateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        fieldStartDate?.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelComplete?.text = "30% Complete"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
