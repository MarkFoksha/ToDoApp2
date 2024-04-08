//
//  Task.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 03.01.2024.
//

import Foundation

struct Task {
    let title: String
    let description: String?
    let location: Location?
    
    var date: Date
    
    init(title: String, 
         description: String? = nil,
         date: Date? = nil,
         location: Location? = nil)
    {
        self.title = title
        self.description = description
        self.date = date ?? Date()
        self.location = location
    }
}

extension Task: Equatable {
    static func == (rhs: Task, lhs: Task) -> Bool {
        if rhs.title == lhs.title,
           rhs.description == lhs.description,
           rhs.location == lhs.location
        {
            return true
        }
        return false
    }
}
