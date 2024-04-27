//
//  TaskCell.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 31.01.2024.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    func configure(withTask task: Task, isDone: Bool = false) {
        if isDone {
            let attributedString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attributedString
            
            dateLabel.text = ""
            locationLabel.text = ""
        } else {
            let dateString = dateFormatter.string(from: task.date)
            dateLabel.text = dateString
            titleLabel.text = task.title
            locationLabel.text = task.location?.name
        }
    }
}
