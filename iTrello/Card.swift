//
//  Card.swift
//  iTrello
//
//  Created by Jennifer Foster on 10/30/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class Card {
    var id: String
    var name: String
    var description: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.description = desc
    }
}