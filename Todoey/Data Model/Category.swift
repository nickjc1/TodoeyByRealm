//
//  Category.swift
//  Todoey
//
//  Created by CHAO JIANG on 6/12/18.
//  Copyright © 2018 nickjc1. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var backColor: String = ""
    
    var items = List<Item>()
}
