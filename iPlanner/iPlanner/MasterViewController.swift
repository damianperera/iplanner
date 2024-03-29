//
//  MasterViewController.swift
//  iPlanner
//
//  Created by Damian Perera on 5/12/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class CourseworkTableViewCell: UITableViewCell {
    @IBOutlet weak var courseworkName: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var moduleName: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var mark: UILabel!
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddCourseworkDelegate, UNUserNotificationCenterDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func triggerWaitingNotifications(forCoursework coursework:Coursework) {
        let tasks = coursework.tasks?.array as! [Task]
        for task in tasks {
            let diffInMinutes = Calendar.current.dateComponents([.minute], from: Date(), to: task.dueDate!).minute!
            if task.completed != 100 && task.notification && diffInMinutes <= 5 {
                showNotification(forTask: task)
            }
        }
    }
    
    func showNotification(forTask task:Task) {
        let notification = UNMutableNotificationContent()
        notification.title = "Task Due!"
        notification.subtitle = task.name!
        notification.body = task.notes!
        notification.categoryIdentifier = "TaskCategory"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let notificationIdentifier = "TaskDue"
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            print(error as Any)
        }
    }
    
    func saveData(name: String, module: String, dueDate: Date, level: Int32, weight: Int32, mark: Int32, notes: String) {
        let context = self.fetchedResultsController.managedObjectContext
        let newCoursework = Coursework(context: context)
        
        newCoursework.name = name
        newCoursework.moduleId = module
        newCoursework.dueDate = dueDate
        newCoursework.level = level
        newCoursework.weight = weight
        newCoursework.mark = mark
        newCoursework.notes = notes
        newCoursework.setDate = Date()
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        UNUserNotificationCenter.current().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.courseworkItem = object
                controller.managedObjectContext = managedObjectContext
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "AddCourseworkSegue" {
            let controller = segue.destination as! AddCourseworkViewController
            controller.delegate = self
            controller.preferredContentSize = CGSize(width: 400, height: 400)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CourseworkTableViewCell
        let coursework = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withCoursework: coursework)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func configureCell(_ cell: CourseworkTableViewCell, withCoursework coursework: Coursework) {
        cell.courseworkName.text = coursework.name
        cell.moduleName.text = coursework.moduleId
        cell.level.text = String(coursework.level)
        cell.weight.text = String(coursework.weight)
        cell.mark.text = "Mark: " + String(coursework.mark) + "/100"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.dueDate.text = "Due on: " + dateFormatter.string(from: coursework.dueDate!)
        
        if (Calendar.current.dateComponents([.hour], from: Date(), to: coursework.dueDate!).hour! < 0) {
            cell.countdown.text = "Date Passed"
        } else if Calendar.current.isDateInToday(coursework.dueDate!) {
            let diffInHours = Calendar.current.dateComponents([.hour], from: Date(), to: coursework.dueDate!).hour!
            cell.countdown.text = "0d " + String(diffInHours) + "h"
        } else {
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: coursework.dueDate!).day!
            let diffInHours = Calendar.current.dateComponents([.hour], from: Calendar.current.startOfDay(for: coursework.dueDate!), to: coursework.dueDate!).hour!
            cell.countdown.text = String(diffInDays) + "d " + String(diffInHours) + "h"
        }
        
        addTaskProgress(forCoursework: coursework, for: cell.mark)
        triggerWaitingNotifications(forCoursework: coursework)
    }
    
    func addTaskProgress(forCoursework: Coursework, for view:UILabel) {
        let taskFrame = CGRect.init(x: 100.0, y: 2.0, width: 190, height: 10)
        view.addSubview(ProgressModel().getBorderedBarProgressOfTasks(ofCoursework: forCoursework, forFrame: taskFrame))
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Coursework> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Coursework> = Coursework.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Coursework>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!) as! CourseworkTableViewCell, withCoursework: anObject as! Coursework)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! CourseworkTableViewCell, withCoursework: anObject as! Coursework)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}

