//
//  ViewController.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 04.12.2023.
//

import UIKit

class TaskListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = dataProvider.taskManager
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails), name: NSNotification.Name(rawValue: "notification"), object: nil)
        
        view.accessibilityIdentifier = "mainView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func showDetails(withNotification notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let task = userInfo["task"] as? Task,
        let detailedViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            fatalError()
        }
        detailedViewController.task = task
        navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

