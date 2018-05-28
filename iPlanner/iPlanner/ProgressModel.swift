//
//  PercentageModel.swift
//  iPlanner
//
//  Created by Damian Perera on 5/28/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import Foundation
import M13ProgressSuite

class ProgressModel {
    
    func getCompletedTaskPercentage(ofCoursework: Coursework) -> Int {
        var totalPercentage = 0
        let tasks = ofCoursework.tasks?.array as! [Task]
        for task in tasks {
            totalPercentage += Int(task.completed)
        }
        var percentageComplete = 0
        if (tasks.count != 0) {
            percentageComplete = totalPercentage/tasks.count
        }
        return percentageComplete
    }
    
    func getDateCountdown(ofCoursework: Coursework, forFrame: CGRect) -> M13ProgressViewSegmentedRing {
        let dateCountdown = M13ProgressViewSegmentedRing.init(frame: forFrame)
        let totalDays = Calendar.current.dateComponents([.day], from: ofCoursework.setDate!, to: ofCoursework.dueDate!).day!
        let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: ofCoursework.dueDate!).day!
        let percentageOfDaysRemaining = daysRemaining/totalDays
        dateCountdown.showPercentage = false
        dateCountdown.progressRingWidth = CGFloat(15.0)
        dateCountdown.numberOfSegments = totalDays
        dateCountdown.setProgress(CGFloat(percentageOfDaysRemaining), animated: false)
        return dateCountdown
    }
    
    func getBarProgressOfTasks(ofCoursework: Coursework, forFrame: CGRect) -> M13ProgressViewBar {
        let taskProgress = M13ProgressViewBar.init(frame: forFrame)
        let currentTaskProgress = Float(getCompletedTaskPercentage(ofCoursework: ofCoursework))/100
        taskProgress.showPercentage = false
        taskProgress.setProgress(CGFloat(currentTaskProgress), animated: false)
        return taskProgress
    }
    
    func getBorderedBarProgressofTasks(ofCoursework coursework:Coursework, forFrame frame: CGRect) -> M13ProgressViewBorderedBar {
        let taskProgress = M13ProgressViewBorderedBar.init(frame: frame)
        let currentTaskProgress = Float(getCompletedTaskPercentage(ofCoursework: coursework))/100
        taskProgress.setProgress(CGFloat(currentTaskProgress), animated: false)
        taskProgress.successColor = UIColor.green
        return taskProgress
    }
    
}
