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
    
    var dict: [String: Any] {
        var dict: [String: Any] = [:]
        dict["title"] = title
        dict["description"] = description
        dict["date"] = date
        if let location = location {
            dict["location"] = location.dict
        }
        return dict
    }
    
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

extension Task {
    typealias PListDictionary = [String : Any]
    init?(dict: PListDictionary) {
        title = dict["title"] as! String
        description = dict["description"] as? String
        date = dict["date"] as? Date ?? Date()
        if let locationDictionary = dict["location"] as? [String : Any] {
            self.location = Location(dict: locationDictionary)
        } else {
            self.location = nil
        }
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
