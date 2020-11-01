//
//  Person.swift
//  Project10a
//
//  Created by Alexander Ha on 10/6/20.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
