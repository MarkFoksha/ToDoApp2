//
//  NewTaskViewController.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 08.04.2024.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func save() {
        guard let titleString = titleTextField.text,
              let locationString = locationTextField.text,
              let dateString = dateTextField.text,
              let addressString = addressTextField.text
        else
        {
            return
        }
        let date = dateFormatter.date(from: dateString)
        let descriptionString = descriptionTextField.text
        
        geocoder.geocodeAddressString(addressString) { [unowned self] placemarks, error in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString, coordinate: coordinate)
            
            let task = Task(title: titleString, description: descriptionString, date: date, location: location)
            taskManager.add(task: task)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
}
