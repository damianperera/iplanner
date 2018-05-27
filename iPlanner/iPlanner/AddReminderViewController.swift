//
//  AddReminderViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/27/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class AddReminderViewController: UIViewController {
    
    var store = EKEventStore()
    var isInternalNotification:Bool = false
    @IBOutlet weak var reminderText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    func addCalendarReminder(title: String, atDate: Date) {
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = atDate
                event.endDate = atDate
                
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                event.addAlarm(alarm)
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    //event created successfullt to default calendar
                } catch let error as NSError {
                    print("Failed to save reminder with error : \(error)")
                }
            } else {
                //we have error in getting access to device calnedar
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func didClickDateField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minimumDate = Date()
        dateText.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddReminderViewController.dateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateText.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func didClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if isInternalNotification {
            
        } else {
            addCalendarReminder(title: reminderText.text!, atDate: dateFormatter.date(from: dateText.text!)!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
