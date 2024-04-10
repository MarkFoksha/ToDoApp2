//
//  APIClient.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 09.04.2024.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        let allowedCharacters = CharacterSet.urlQueryAllowed
        guard let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
              let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {
            fatalError()
        }
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoApp.com/login?\(query)") else { fatalError() }
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else { fatalError() }
            let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String : String]
            let token = dictionary["token"]
            
            completionHandler(token, nil)
        }.resume()
    }
}
