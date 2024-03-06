//
//  TaskManager.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 15.01.2024.
//

import Foundation

struct TaskManager {
    var tasksCount: Int {
        tasks.count
    }
    var doneTasksCount: Int {
        doneTasks.count
    }
    
    private var tasks = [Task]()
    private var doneTasks = [Task]()
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
    
    func doneTask(at index: Int) -> Task {
        doneTasks[index]
    }
    
    mutating func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    mutating func checkTask(at index: Int) {
        let removedTask = tasks.remove(at: index)
        doneTasks.append(removedTask)
    }
    
    mutating func uncheckTask(at index: Int) {
        let removedTask = doneTasks.remove(at: index)
        tasks.append(removedTask)
    }
    
    mutating func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}
