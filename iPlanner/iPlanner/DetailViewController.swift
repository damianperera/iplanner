//
//  DetailViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/12/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var completed: UILabel!
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasks = courseworkItem?.tasks?.array as! [Task]
        selectedTask = tasks[indexPath.row]
        selectedTaskID = indexPath.row
        performSegue(withIdentifier: "EditTaskSegue", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasks = courseworkItem?.tasks?.array as? [Task]
        if let count = (tasks?.count) {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task Cell", for: indexPath) as! TaskTableViewCell
        let tasks = courseworkItem?.tasks?.array as! [Task]
        let task = tasks[indexPath.row]
        configureCell(cell, withTask: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            courseworkItem?.removeFromTasks(at: indexPath.row)
            
            do {
                try self.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
            }
            
            tableView.reloadData()
        }
    }
    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task) {
        cell.name.text = task.name
        cell.notes.text = task.notes
        cell.completed.text = String(task.completed) + "% Completed"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if (Calendar.current.dateComponents([.hour], from: Date(), to: task.dueDate!).hour! < 0) {
            cell.countdown.text = "Date Passed"
        } else if Calendar.current.isDateInToday(task.dueDate!) {
            let diffInHours = Calendar.current.dateComponents([.hour], from: task.startDate!, to: task.dueDate!).hour!
            cell.countdown.text = "0d " + String(diffInHours) + "h"
        } else {
            let diffInDays = Calendar.current.dateComponents([.day], from: task.startDate!, to: task.dueDate!).day!
            let diffInHours = Calendar.current.dateComponents([.hour], from: Calendar.current.startOfDay(for: task.dueDate!), to: task.dueDate!).hour!
            cell.countdown.text = String(diffInDays) + "d " + String(diffInHours) + "h"
        }
    }
    
}

class DetailViewController: UIViewController, AddCourseworkDelegate, NSFetchedResultsControllerDelegate, AddTaskViewDelegate {
    
    var selectedTask:Task?
    var selectedTaskID:Int?
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    var managedObjectContext: NSManagedObjectContext?
    @IBOutlet weak var buttonReminder: UIBarButtonItem!
    @IBOutlet weak var buttonEdit: UIBarButtonItem!

    @IBOutlet weak var courseworkDaysLeft: UILabel?
    @IBOutlet weak var courseworkModuleName: UILabel?
    @IBOutlet weak var courseworkWeight: UILabel?
    @IBOutlet weak var courseworkNotes: UILabel?
    @IBOutlet weak var courseworkLevel: UILabel?
    @IBOutlet weak var courseworkMark: UILabel?
    @IBOutlet weak var courseworkProgressText: UILabel?
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCourseworkSegue" {
            let controller = segue.destination as! AddCourseworkViewController
            controller.coursework = courseworkItem
            controller.delegate = self
            controller.preferredContentSize = CGSize(width: 400, height: 400)
        } else if segue.identifier == "SetCalendarReminderSegue" {
            let controller = segue.destination as! AddReminderViewController
            controller.preferredContentSize = CGSize(width: 400, height: 150)
        } else if segue.identifier == "SetInternalReminderSegue" {
            let controller = segue.destination as! AddReminderViewController
            controller.preferredContentSize = CGSize(width: 400, height: 150)
        } else if segue.identifier == "AddTaskSegue" {
            let controller = segue.destination as! AddTaskViewController
            controller.delegate = self
            controller.coursework = courseworkItem
            controller.preferredContentSize = CGSize(width: 400, height: 250)
        } else if segue.identifier == "EditTaskSegue" {
            let controller = segue.destination as! AddTaskViewController
            controller.delegate = self
            controller.task = selectedTask
            controller.taskID = selectedTaskID
            controller.isEdit = true
            controller.preferredContentSize = CGSize(width: 400, height: 250)
        }
    }
    
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
    
    func saveData(taskName: String, startDate: Date, dueDate: Date, complete: Int32, notes: String) {
        let context = managedObjectContext
        let newTask = Task(context: context!)
        newTask.name = taskName
        newTask.startDate = startDate
        newTask.dueDate = dueDate
        newTask.completed = complete
        newTask.notes = notes
        
        courseworkItem?.addToTasks(newTask)
        do {
            try self.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
        tableView.reloadData()
        configureView()
    }
    
    func saveEditedData(taskName: String, startDate: Date, dueDate: Date, complete: Int32, notes: String, taskID: Int) {
        let context = managedObjectContext
        let newTask = Task(context: context!)
        newTask.name = taskName
        newTask.startDate = startDate
        newTask.dueDate = dueDate
        newTask.completed = complete
        newTask.notes = notes
        
        courseworkItem?.replaceTasks(at: taskID, with: newTask)
        do {
            try self.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
        tableView.reloadData()
        configureView()
    }

    func configureView() {
        if let coursework = courseworkItem {
            self.title = coursework.name
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: coursework.dueDate!).day!
            let currentTaskProgress = ProgressModel().getCompletedTaskPercentage(ofCoursework: coursework)
            courseworkModuleName?.text = coursework.moduleId
            courseworkLevel?.text = String(coursework.level)
            courseworkNotes?.text = coursework.notes
            courseworkMark?.text = String(coursework.mark) + "/100"
            courseworkWeight?.text = String(coursework.weight) + "%"
            courseworkProgressText?.text = String(currentTaskProgress) + "% Complete"
            courseworkDaysLeft?.text = String(diffInDays) + " Days Left"
            setProgressView(coursework: coursework, daysRemaining: Float(diffInDays), taskCompleteProgress: Float(currentTaskProgress)/100)
            toggleViews(isHidden: false)
        }
    }
    
    func setProgressView(coursework: Coursework, daysRemaining: Float, taskCompleteProgress: Float) {
        let dateFrame = CGRect(x: -25.0, y: -60.0, width: 150.0, height: 150.0)
        courseworkDaysLeft?.addSubview(ProgressModel().getDateCountdown(ofCoursework: coursework, forFrame: dateFrame))
        
        let taskFrame = CGRect(x: -68.0, y: 20.0, width: 250.0, height: 20.0)
        courseworkWeight?.addSubview(ProgressModel().getBarProgressOfTasks(ofCoursework: coursework, forFrame: taskFrame))
    }

    func toggleViews(isHidden: Bool) {
        if
            let firstView = view.viewWithTag(1),
            let secondView = view.viewWithTag(2),
            let thirdView = view.viewWithTag(3),
            let fourthView = view.viewWithTag(4),
            let buttonColor = isHidden ? UIColor.clear as UIColor? : UIView().tintColor as UIColor? {
            firstView.isHidden = isHidden
            secondView.isHidden = isHidden
            thirdView.isHidden = isHidden
            fourthView.isHidden = isHidden
            buttonEdit.tintColor = buttonColor
            buttonReminder.tintColor = buttonColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toggleViews(isHidden: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
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

