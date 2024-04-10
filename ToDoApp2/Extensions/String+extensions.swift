//
//  String+extensions.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 10.04.2024.
//

import Foundation

extension String {
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\{},./?><")
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {
            fatalError()
        }
        return encodedString
    }
}
