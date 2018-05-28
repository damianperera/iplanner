//
//  PercentageModel.swift
//  iPlanner
//
//  Created by Damian Perera on 5/28/18.
//  Copyright © 2018 Damian Perera. All rights reserved.
//

import Foundation

class PercentageModel {
    
    func getCompletePercentage(ofCoursework: Coursework) -> Int {
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
    
}
