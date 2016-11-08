//
//  Board.swift
//  iTrello
//
//  Created by Jennifer Foster on 10/30/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class Board {
    var id: String
    var name: String
    var lists: [List]
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.lists = [List]()
    }
}