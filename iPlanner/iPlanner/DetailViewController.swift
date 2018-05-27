//
//  DetailViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/12/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, AddCourseworkDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    
    func saveData(name: String, module: String, dueDate: Date, level: Int32, weight: Int32, mark: Int32, notes: String) {
        courseworkItem?.setValue(name, forKey: "name")
        courseworkItem?.setValue(module, forKey: "moduleId")
        courseworkItem?.setValue(dueDate, forKey: "dueDate")
        courseworkItem?.setValue(level, forKey: "level")
        courseworkItem?.setValue(weight, forKey: "weight")
        courseworkItem?.setValue(mark, forKey: "mark")
        courseworkItem?.setValue(notes, forKey: "notes")

        do {
            try self.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
        configureView()
    }

    @IBOutlet weak var courseworkDaysLeft: UILabel?
    @IBOutlet weak var courseworkModuleName: UILabel?
    @IBOutlet weak var courseworkWeight: UILabel?
    @IBOutlet weak var courseworkNotes: UILabel?
    @IBOutlet weak var courseworkLevel: UILabel?
    @IBOutlet weak var courseworkMark: UILabel?
    @IBOutlet weak var courseworkProgressText: UILabel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCourseworkSegue" {
            let controller = segue.destination as! AddCourseworkViewController
            controller.coursework = courseworkItem
            controller.delegate = self
        }
    }
    
    func configureView() {
        if let coursework = courseworkItem {
            self.title = coursework.name
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: coursework.dueDate!).day!

            courseworkModuleName?.text = coursework.moduleId
            courseworkLevel?.text = String(coursework.level)
            courseworkNotes?.text = coursework.notes
            courseworkMark?.text = String(coursework.mark) + "/100"
            courseworkWeight?.text = String(coursework.weight) + "%"
            courseworkProgressText?.text = "Progressing"
            courseworkDaysLeft?.text = String(diffInDays) + " Days Left"
            
            toggleViews(isHidden: false)
        }
    }

    func toggleViews(isHidden: Bool) {
        if
            let firstView = view.viewWithTag(1),
            let secondView = view.viewWithTag(2),
            let thirdView = view.viewWithTag(3),
            let fourthView = view.viewWithTag(4) {
            firstView.isHidden = isHidden
            secondView.isHidden = isHidden
            thirdView.isHidden = isHidden
            fourthView.isHidden = isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toggleViews(isHidden: true)
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var courseworkItem: Coursework? {
        didSet {
            configureView()
        }
    }


}

