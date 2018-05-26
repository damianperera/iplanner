//
//  DetailViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/12/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var courseworkDaysLeft: UILabel?
    @IBOutlet weak var courseworkModuleName: UILabel?
    @IBOutlet weak var courseworkWeight: UILabel?
    @IBOutlet weak var courseworkNotes: UILabel?
    @IBOutlet weak var courseworkLevel: UILabel?
    @IBOutlet weak var courseworkMark: UILabel?
    @IBOutlet weak var courseworkProgressText: UILabel?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let coursework = courseworkItem {
            if let label = defaultLabel {
                label.isHidden = true
            }
            self.title = coursework.name
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: coursework.dueDate!).day!

            courseworkModuleName?.text = coursework.moduleId
            courseworkLevel?.text = String(coursework.level)
            courseworkNotes?.text = coursework.notes
            courseworkMark?.text = String(coursework.mark)
            courseworkWeight?.text = String(coursework.weight)
            courseworkProgressText?.text = "Progressing"
            courseworkDaysLeft?.text = String(diffInDays) + " Days Left"
            
            if
                let firstView = view.viewWithTag(1),
                let secondView = view.viewWithTag(2),
                let thirdView = view.viewWithTag(3),
                let fourthView = view.viewWithTag(4) {
                    firstView.isHidden = false
                    secondView.isHidden = false
                    thirdView.isHidden = false
                    fourthView.isHidden = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var courseworkItem: Coursework? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

