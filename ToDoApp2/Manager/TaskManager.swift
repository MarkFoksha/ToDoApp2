//
//  TaskManager.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 15.01.2024.
//

import Foundation
import UIKit

class TaskManager {
    private var tasks = [Task]()
    private var doneTasks = [Task]()
    
    var tasksCount: Int {
        tasks.count
    }
    var doneTasksCount: Int {
        doneTasks.count
    }
    
    var tasksURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = fileURLs.first else { fatalError() }
        return documentsURL.appendingPathComponent("tasks.plist")
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let data = try? Data(contentsOf: tasksURL) {
            let dicts = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [[String : Any]]
            guard let dictionaries = dicts else { return }
            
            for dict in dictionaries {
                if let task = Task(dict: dict) {
                    tasks.append(task)
                }
            }
        }
    }
    
    deinit {
        save()
    }
    
    @objc func save() {
        let taskDictionaries = tasks.map({ $0.dict })
        guard taskDictionaries.count > 0 else {
            try? FileManager.default.removeItem(at: tasksURL)
            return
        }
        
        let plistData = try? PropertyListSerialization.data(fromPropertyList: taskDictionaries,
                                                            format: .xml,
                                                            options: PropertyListSerialization.WriteOptions(0))
        try? plistData?.write(to: tasksURL, options: .atomic)
    }
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
    
    func doneTask(at index: Int) -> Task {
        doneTasks[index]
    }
    
    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    func checkTask(at index: Int) {
        let removedTask = tasks.remove(at: index)
        doneTasks.append(removedTask)
    }
    
    func uncheckTask(at index: Int) {
        let removedTask = doneTasks.remove(at: index)
        tasks.append(removedTask)
    }
    
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}
