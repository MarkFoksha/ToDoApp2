//
//  DataProvider.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 17.01.2024.
//

import UIKit

enum Section: Int, CaseIterable {
    case todo
    case done
}

class DataProvider: NSObject {
    var taskManager: TaskManager?
}

extension DataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else { return "Error" }
        
        switch section {
        case .todo: return "Done"
        case .done: return "Undone"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        
        switch section {
        case .todo:
            let task = taskManager?.task(at: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"), object: self, userInfo: ["task" : task!])
        case .done: break
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        "Section \(section)"
//    }
}

extension DataProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        guard let taskManager = taskManager else { return 0 }
        
        switch section {
        case .todo: return taskManager.tasksCount
        case .done: return taskManager.doneTasksCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let taskManager = taskManager else { return UITableViewCell() }
        
        let task: Task
        switch section {
        case .todo: task = taskManager.task(at: indexPath.row)
        case .done: task = taskManager.doneTask(at: indexPath.row)
        }
        cell.configure(withTask: task, isDone: task.isDone)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .todo: taskManager?.checkTask(at: indexPath.row)
        case .done: taskManager?.uncheckTask(at: indexPath.row)
        }
        tableView.reloadData()
    }
}
